import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Phase 4.1 — Gemini Context Cache manager (Strategy B: universal shared cache).
///
/// Manages creation/retrieval/invalidation of Gemini context caches containing
/// rubric documents. Strategy B = single shared English cache per mode
/// (prayer, qt), used across all 35 locales. The locale-aware instruction is
/// passed via the user prompt at call time.
///
/// Lazy creation: cache is created on first Gemini call of the day (or when
/// TTL expires, or when rubric bundle hash changes). No pg_cron needed.
///
/// See:
///   apps/abba/specs/phase_4_1_section_based_ai/_details/cache_strategy.md
class GeminiCacheManager {
  final SupabaseClient _supabase;

  /// Asset paths that form the "rubric bundle" per mode. Changing any of
  /// these files invalidates the cache (via SHA256 hash comparison).
  static const _prayerAssets = <String>[
    'assets/prompts/system_base.md',
    'assets/prompts/prayer/summary_rubric.md',
    'assets/prompts/prayer/scripture_rubric.md',
    'assets/prompts/prayer/bible_story_rubric.md',
    'assets/prompts/prayer/testimony_rubric.md',
    'assets/prompts/prayer/guidance_rubric.md',
    'assets/prompts/prayer/ai_prayer_rubric.md',
    'assets/prompts/prayer/historical_story_rubric.md',
  ];

  static const _qtAssets = <String>[
    'assets/prompts/system_base.md',
    'assets/prompts/qt/meditation_summary_rubric.md',
    'assets/prompts/qt/application_rubric.md',
    'assets/prompts/qt/knowledge_rubric.md',
  ];

  /// In-memory hash cache to avoid re-reading bundle on every call.
  String? _cachedPrayerHash;
  String? _cachedQtHash;
  String? _cachedRubricBundlePrayer;
  String? _cachedRubricBundleQt;

  GeminiCacheManager(this._supabase);

  /// Assemble the full rubric bundle content for a mode (concatenated md).
  /// Returns the raw system instruction string to send to Gemini.
  Future<String> loadRubricBundle(String mode) async {
    final cached = mode == 'prayer' ? _cachedRubricBundlePrayer : _cachedRubricBundleQt;
    if (cached != null) return cached;

    final assets = mode == 'prayer' ? _prayerAssets : _qtAssets;
    final buf = StringBuffer();
    for (final path in assets) {
      buf.writeln(await rootBundle.loadString(path));
      buf.writeln();
    }
    final bundle = buf.toString();

    if (mode == 'prayer') {
      _cachedRubricBundlePrayer = bundle;
    } else {
      _cachedRubricBundleQt = bundle;
    }
    return bundle;
  }

  /// SHA256-ish hash of rubric bundle (stable across runs, changes when any
  /// file changes). We use a simple accumulating hash rather than crypto
  /// package to avoid dependency — it's sufficient for change detection.
  Future<String> computeBundleHash(String mode) async {
    final cached = mode == 'prayer' ? _cachedPrayerHash : _cachedQtHash;
    if (cached != null) return cached;

    final bundle = await loadRubricBundle(mode);
    final bytes = utf8.encode(bundle);

    // Simple but stable hash: FNV-1a variant. Not cryptographic but detects
    // any content change reliably (collision prob for our use case ~0).
    var hash = BigInt.parse('cbf29ce484222325', radix: 16);
    final prime = BigInt.parse('100000001b3', radix: 16);
    final mask64 = (BigInt.one << 64) - BigInt.one;
    for (final byte in bytes) {
      hash = hash ^ BigInt.from(byte);
      hash = (hash * prime) & mask64;
    }
    final hexHash = hash.toRadixString(16).padLeft(16, '0');

    if (mode == 'prayer') {
      _cachedPrayerHash = hexHash;
    } else {
      _cachedQtHash = hexHash;
    }
    return hexHash;
  }

  /// Get or create the Gemini context cache for a mode. Returns the cache
  /// identifier (to be passed as `cachedContent` in generateContent calls),
  /// or null if caching is unavailable (graceful degrade to uncached calls).
  ///
  /// [mode] = 'prayer' | 'qt'
  Future<String?> getOrCreateCache({required String mode}) async {
    assert(mode == 'prayer' || mode == 'qt');

    try {
      final config = await _fetchSystemConfig();
      final cacheId = config['${mode}_cache_id'];
      final expiresAtRaw = config['${mode}_cache_expires_at'];
      final storedHash = config['${mode}_rubrics_version'] as String?;

      final currentHash = await computeBundleHash(mode);

      // 1. Hash mismatch → rubric changed, force re-create.
      if (storedHash == null || storedHash.isEmpty || storedHash != currentHash) {
        apiLog.info('[Cache] $mode hash mismatch — creating new cache');
        return await _createAndSave(mode, currentHash);
      }

      // 2. Cache expired (or <5 min remaining) → re-create.
      if (cacheId == null || cacheId is! String || cacheId.isEmpty) {
        apiLog.info('[Cache] $mode cache_id missing — creating');
        return await _createAndSave(mode, currentHash);
      }
      if (expiresAtRaw is String) {
        final expiresAt = DateTime.tryParse(expiresAtRaw);
        if (expiresAt == null ||
            expiresAt.isBefore(DateTime.now().add(const Duration(minutes: 5)))) {
          apiLog.info('[Cache] $mode expiring soon — re-creating');
          return await _createAndSave(mode, currentHash);
        }
      }

      // 3. Cache valid → reuse.
      apiLog.debug('[Cache] $mode reusing existing cache');
      return cacheId;
    } catch (e) {
      apiLog.warning('[Cache] $mode getOrCreate failed — fallback to uncached',
          error: e);
      return null; // Graceful: caller will use regular call
    }
  }

  /// Internal: create Gemini cache + persist id/expires/hash.
  ///
  /// Note: actual Gemini cache creation requires calling Google's Caches API.
  /// The `google_generative_ai` package supports this via `CachedContent`.
  /// This method creates the cache on Gemini's servers and saves metadata
  /// to `public.system_config` via Supabase.
  ///
  /// Placeholder implementation: If the SDK path is not available or fails,
  /// returns null to trigger uncached fallback.
  Future<String?> _createAndSave(String mode, String hash) async {
    try {
      // NOTE: google_generative_ai Dart SDK (v0.4.x) does not yet expose
      // context cache create via a stable API. When it does, replace this
      // block with the actual Gemini API call.
      //
      // For MVP, we return a pseudo cache id that just indicates rubric
      // presence. Upstream callers will then include the rubric as system
      // instruction directly (no cost savings until real caching is wired).
      //
      // Placeholder: use bundle hash as the cache identifier. When Gemini
      // caching is enabled, this will be replaced with the actual cache
      // resource name returned by the API.
      const useRealCache = false; // Flip to true when SDK supports it

      // ignore: dead_code
      if (!useRealCache) {
        apiLog.info(
          '[Cache] $mode placeholder (real caching not wired in SDK yet). '
          'System prompt will be sent inline on each call.',
        );
        // Save metadata so we know rubric version is tracked, but return null
        // to tell caller to send full prompt inline.
        await _upsertSystemConfig({
          '${mode}_rubrics_version': hash,
          '${mode}_cache_id': null,
          '${mode}_cache_expires_at': null,
        });
        return null;
      }

      // ignore: dead_code
      // When wired: call Gemini REST API POST /v1beta/cachedContents
      // Request body: { model, systemInstruction, ttl }
      // Response: { name: "cachedContents/abc123", expireTime: "..." }
      // final result = await _geminiClient.caches.create(...);
      // await _upsertSystemConfig({
      //   '${mode}_cache_id': result.name,
      //   '${mode}_cache_expires_at': result.expireTime.toIso8601String(),
      //   '${mode}_rubrics_version': hash,
      // });
      // return result.name;

      // ignore: dead_code
      return null;
    } catch (e) {
      apiLog.warning('[Cache] $mode create failed', error: e);
      return null;
    }
  }

  Future<Map<String, dynamic>> _fetchSystemConfig() async {
    final rows = await _supabase.from('system_config').select('key, value');
    final map = <String, dynamic>{};
    for (final row in rows as List) {
      final key = row['key'] as String;
      map[key] = row['value'];
    }
    return map;
  }

  Future<void> _upsertSystemConfig(Map<String, dynamic> entries) async {
    final rows = entries.entries.map((e) => {
          'key': e.key,
          'value': e.value,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });
    for (final row in rows) {
      await _supabase.from('system_config').upsert(row);
    }
  }

  /// Invalidate in-memory caches (call on app config change).
  void clearMemoryCache() {
    _cachedPrayerHash = null;
    _cachedQtHash = null;
    _cachedRubricBundlePrayer = null;
    _cachedRubricBundleQt = null;
  }
}
