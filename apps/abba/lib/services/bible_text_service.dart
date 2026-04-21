import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_lib_logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Looks up Bible verse text by reference + locale.
///
/// Verse text comes from Public Domain translations hosted on Supabase
/// Storage (`abba/bibles/{locale}_{code}.json`). AI never generates verse
/// text directly — it only selects a reference, then this service fills it in.
abstract class BibleTextService {
  /// Returns verse text for the given reference, or null when not available.
  ///
  /// Reference format: "Book Chapter:Verse" or "Book Chapter:Start-End".
  /// Examples: "Psalm 23:1", "Psalm 23:1-3", "1 Corinthians 13:4-7".
  Future<String?> lookup(String reference, String locale);

  /// Whether a bundle exists for the given locale (network-free check).
  bool hasBundleForLocale(String locale);

  /// Pre-download a locale bundle so the first [lookup] is instant.
  /// Safe to call multiple times; no-op once cached.
  Future<void> preload(String locale);

  /// Locale → translation name, for Settings attribution page.
  Map<String, String> attributions();
}

/// Bundle file naming: `{locale}_{code}.json` (e.g., `ko_krv.json`).
class _BundleDescriptor {
  final String locale;
  final String code;
  final String name;
  const _BundleDescriptor({
    required this.locale,
    required this.code,
    required this.name,
  });

  String get fileName => '${locale}_$code.json';
  String get storagePath => 'bibles/$fileName';
}

class SupabaseStorageBibleTextService implements BibleTextService {
  SupabaseStorageBibleTextService({
    SupabaseClient? client,
    String bucket = 'abba',
  })  : _client = client ?? Supabase.instance.client,
        _bucket = bucket;

  final SupabaseClient _client;
  final String _bucket;

  /// Which translation file we use per locale (Phase 1 = ko + en only).
  /// Extended in Phase 3 for remaining locales.
  static const Map<String, _BundleDescriptor> _bundles = {
    'ko': _BundleDescriptor(locale: 'ko', code: 'krv', name: '개역한글 (KRV)'),
    'en': _BundleDescriptor(
      locale: 'en',
      code: 'web',
      name: 'World English Bible',
    ),
  };

  /// verses-by-locale memory cache (cleared only on app restart).
  final Map<String, Map<String, String>> _memCache = {};

  /// In-flight download promises (dedupe concurrent calls for same locale).
  final Map<String, Future<Map<String, String>?>> _loading = {};

  @override
  bool hasBundleForLocale(String locale) => _bundles.containsKey(locale);

  @override
  Map<String, String> attributions() {
    return {
      for (final entry in _bundles.entries)
        entry.key: entry.value.name,
    };
  }

  @override
  Future<void> preload(String locale) async {
    if (_memCache.containsKey(locale)) return;
    await _loadBundle(locale);
  }

  @override
  Future<String?> lookup(String reference, String locale) async {
    if (!_bundles.containsKey(locale)) return null;

    final verses = _memCache[locale] ?? await _loadBundle(locale);
    if (verses == null) return null;

    return _resolveReference(reference, verses);
  }

  // --------------------------------------------------------------------------
  // Loading: memory → local file → Supabase download
  // --------------------------------------------------------------------------

  Future<Map<String, String>?> _loadBundle(String locale) {
    final existing = _loading[locale];
    if (existing != null) return existing;

    final future = _loadBundleUncached(locale);
    _loading[locale] = future;
    future.whenComplete(() => _loading.remove(locale));
    return future;
  }

  Future<Map<String, String>?> _loadBundleUncached(String locale) async {
    final desc = _bundles[locale];
    if (desc == null) return null;

    // 2nd tier: local file cache.
    try {
      final file = await _localFile(desc.fileName);
      if (await file.exists()) {
        final raw = await file.readAsString();
        final verses = _parseVersesFromJson(raw);
        _memCache[locale] = verses;
        apiLog.debug('BibleTextService: local cache hit for $locale');
        return verses;
      }
    } catch (e) {
      apiLog.warning(
        'BibleTextService: local cache read failed for $locale',
        error: e,
      );
    }

    // 3rd tier: download from Supabase Storage.
    try {
      final bytes = await _client.storage.from(_bucket).download(desc.storagePath);
      final raw = utf8.decode(bytes);
      final verses = _parseVersesFromJson(raw);

      // Persist to local file cache (best-effort).
      unawaited(_writeLocal(desc.fileName, bytes));

      _memCache[locale] = verses;
      apiLog.info(
        'BibleTextService: downloaded $locale bundle (${bytes.length ~/ 1024}KB)',
      );
      return verses;
    } catch (e) {
      apiLog.warning(
        'BibleTextService: download failed for $locale',
        error: e,
      );
      return null;
    }
  }

  Map<String, String> _parseVersesFromJson(String raw) {
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final verses = data['verses'] as Map<String, dynamic>? ?? const {};
    return verses.map((key, value) => MapEntry(key, value as String));
  }

  Future<File> _localFile(String fileName) async {
    final dir = await getApplicationSupportDirectory();
    final sub = Directory('${dir.path}/bibles');
    if (!await sub.exists()) {
      await sub.create(recursive: true);
    }
    return File('${sub.path}/$fileName');
  }

  Future<void> _writeLocal(String fileName, List<int> bytes) async {
    try {
      final file = await _localFile(fileName);
      await file.writeAsBytes(bytes, flush: true);
    } catch (e) {
      apiLog.warning(
        'BibleTextService: local cache write failed for $fileName',
        error: e,
      );
    }
  }

  // --------------------------------------------------------------------------
  // Reference parsing
  // --------------------------------------------------------------------------

  /// Supports:
  /// - "Psalm 23:1" — single verse
  /// - "Psalm 23:1-3" — verse range within same chapter
  /// - "Genesis 1:1" — with spaces in book name ("1 Corinthians 13:4")
  ///
  /// Returns joined text (space-separated) or null if not found.
  String? _resolveReference(String reference, Map<String, String> verses) {
    // Direct hit first.
    final direct = verses[reference];
    if (direct != null) return direct;

    // Parse for verse range.
    // Find the last ':' which separates chapter from verse(s).
    final colon = reference.lastIndexOf(':');
    if (colon < 0) return null;

    final bookChapter = reference.substring(0, colon); // e.g., "Psalm 23"
    final versePart = reference.substring(colon + 1);  // e.g., "1-3"
    final dash = versePart.indexOf('-');
    if (dash < 0) {
      // Single verse but direct lookup already failed.
      return null;
    }

    final startStr = versePart.substring(0, dash);
    final endStr = versePart.substring(dash + 1);
    final start = int.tryParse(startStr);
    final end = int.tryParse(endStr);
    if (start == null || end == null || end < start) return null;

    final collected = <String>[];
    for (var v = start; v <= end; v++) {
      final key = '$bookChapter:$v';
      final text = verses[key];
      if (text != null) collected.add(text);
    }
    if (collected.isEmpty) return null;
    return collected.join(' ');
  }
}
