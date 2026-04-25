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

  /// Locale → translation metadata (name + license), for Settings
  /// attribution page.
  Map<String, BibleTranslationInfo> attributions();
}

/// Display metadata for a bundled translation.
class BibleTranslationInfo {
  final String name;
  final String license;
  const BibleTranslationInfo({required this.name, required this.license});
}

/// Bundle file naming: `{locale}_{code}.json` (e.g., `ko_krv.json`).
class _BundleDescriptor {
  final String locale;
  final String code;
  final String name;

  /// Short license tag for the Settings attribution page.
  /// Defaults to "Public Domain" — override for CC-licensed bundles.
  final String license;

  const _BundleDescriptor({
    required this.locale,
    required this.code,
    required this.name,
    this.license = 'Public Domain',
  });

  String get fileName => '${locale}_$code.json';
  String get storagePath => 'bibles/$fileName';
}

class SupabaseStorageBibleTextService implements BibleTextService {
  SupabaseStorageBibleTextService({
    SupabaseClient? client,
    String bucket = 'abba',
  }) : _client = client ?? Supabase.instance.client,
       _bucket = bucket;

  final SupabaseClient _client;
  final String _bucket;

  /// Which translation file we use per locale (Phase 1 = ko + en only).
  /// 31 locales with bundled Bible translations. The remaining 4 locales
  /// (am, ar, no, th) fall back to reference-only UI because their only
  /// available translations have commercial-use restrictions. Full audit:
  /// `apps/abba/specs/bible_text_i18n/COPYRIGHT.md`.
  static const Map<String, _BundleDescriptor> _bundles = {
    'ko': _BundleDescriptor(locale: 'ko', code: 'krv', name: '개역한글 (KRV)'),
    'en': _BundleDescriptor(
      locale: 'en',
      code: 'web',
      name: 'World English Bible',
    ),
    'es': _BundleDescriptor(
      locale: 'es',
      code: 'rv1909',
      name: 'Reina-Valera Antigua',
    ),
    'fr': _BundleDescriptor(
      locale: 'fr',
      code: 'synodale',
      name: 'Synodale 1921',
    ),
    'de': _BundleDescriptor(
      locale: 'de',
      code: 'elb1905',
      name: 'Elberfelder 1905',
    ),
    'pt': _BundleDescriptor(locale: 'pt', code: 'almeida', name: 'Almeida'),
    'ru': _BundleDescriptor(
      locale: 'ru',
      code: 'synodal',
      name: 'Synodal 1876',
    ),
    'zh': _BundleDescriptor(
      locale: 'zh',
      code: 'union',
      name: '和合本 (Chinese Union Version)',
    ),
    'ja': _BundleDescriptor(locale: 'ja', code: 'kougo', name: '口語訳'),
    'nl': _BundleDescriptor(locale: 'nl', code: 'svv', name: 'Statenvertaling'),
    'el': _BundleDescriptor(locale: 'el', code: 'vamvas', name: 'Βάμβας'),
    'pl': _BundleDescriptor(
      locale: 'pl',
      code: 'gdanska',
      name: 'Biblia Gdańska',
    ),
    'cs': _BundleDescriptor(locale: 'cs', code: 'bkr', name: 'Bible Kralická'),
    'he': _BundleDescriptor(
      locale: 'he',
      code: 'modern',
      name: 'Modern Hebrew Bible',
    ),
    'sv': _BundleDescriptor(locale: 'sv', code: '1917', name: 'Bibeln 1917'),
    'fi': _BundleDescriptor(
      locale: 'fi',
      code: 'pr1933',
      name: 'Raamattu 1933/38',
    ),
    'hu': _BundleDescriptor(locale: 'hu', code: 'karoli', name: 'Károli'),
    'vi': _BundleDescriptor(
      locale: 'vi',
      code: 'bible',
      name: 'Kinh Thánh Việt',
    ),
    'fil': _BundleDescriptor(
      locale: 'fil',
      code: 'adb',
      name: 'Ang Dating Biblia',
    ),
    'ro': _BundleDescriptor(
      locale: 'ro',
      code: 'ronc',
      name: 'Cornilescu 1924',
    ),
    'it': _BundleDescriptor(
      locale: 'it',
      code: 'diodati',
      name: 'Diodati 1927',
    ),
    'id': _BundleDescriptor(
      locale: 'id',
      code: 'tl',
      name: 'Alkitab BahasaKita (Albata)',
      license: 'CC BY-SA 4.0 · © Yayasan Alkitab BahasaKita',
    ),
    'sw': _BundleDescriptor(
      locale: 'sw',
      code: 'swh1850',
      name: 'Swahili 1850 (NT)',
    ),
    'tr': _BundleDescriptor(
      locale: 'tr',
      code: 'turobt',
      name: 'Open Basic Turkish NT',
      license: 'CC BY-SA 4.0 · © Biblica',
    ),
    'hi': _BundleDescriptor(
      locale: 'hi',
      code: 'cv',
      name: 'Hindi Common Version',
      license: 'CC BY-SA 4.0 · © Biblica',
    ),
    'da': _BundleDescriptor(
      locale: 'da',
      code: '1871',
      name: 'Dansk 1871/1907',
    ),
    'uk': _BundleDescriptor(locale: 'uk', code: 'ogienko', name: 'Огієнко'),
    'my': _BundleDescriptor(locale: 'my', code: 'judson', name: 'Judson 1835'),
    'hr': _BundleDescriptor(
      locale: 'hr',
      code: 'sh',
      name: 'Croatian Bible (Šarić)',
    ),
    // CC BY-SA / BY-ND 4.0 — commercial OK with attribution (see Settings).
    'ms': _BundleDescriptor(
      locale: 'ms',
      code: 'ksi',
      name: 'Kitab Suci (Malay NT)',
      license: 'CC BY-ND 4.0 · © Pengamat Kitab Mulia',
    ),
    'sk': _BundleDescriptor(
      locale: 'sk',
      code: 'hyr',
      name: 'Nádej pre každého (Slovak NT)',
      license: 'CC BY-SA 4.0 · © Biblica',
    ),
    // NOTE: `am` (Amharic), `th` (Thai), `no` (Norwegian) intentionally
    // excluded — see specs/bible_text_i18n/COPYRIGHT.md for the audit.
  };

  /// verses-by-locale memory cache (cleared only on app restart).
  final Map<String, Map<String, String>> _memCache = {};

  /// In-flight download promises (dedupe concurrent calls for same locale).
  final Map<String, Future<Map<String, String>?>> _loading = {};

  @override
  bool hasBundleForLocale(String locale) => _bundles.containsKey(locale);

  @override
  Map<String, BibleTranslationInfo> attributions() {
    return {
      for (final entry in _bundles.entries)
        entry.key: BibleTranslationInfo(
          name: entry.value.name,
          license: entry.value.license,
        ),
    };
  }

  @override
  Future<void> preload(String locale) async {
    if (_memCache.containsKey(locale)) {
      apiLog.debug('[Bible] preload skip: $locale already in memory');
      return;
    }
    apiLog.info('[Bible] preload start: $locale');
    await _loadBundle(locale);
  }

  @override
  Future<String?> lookup(String reference, String locale) async {
    if (!_bundles.containsKey(locale)) {
      apiLog.info(
        '[Bible] lookup unsupported: locale=$locale (no bundle) ref=$reference → fallback UI',
      );
      return null;
    }

    // 1st tier: memory cache.
    var verses = _memCache[locale];
    if (verses != null) {
      final text = _resolveReference(reference, verses);
      apiLog.debug(
        '[Bible] lookup mem-hit: $locale $reference → ${text == null ? "NOT FOUND" : "${text.length} chars"}',
      );
      return text;
    }

    // 2nd/3rd tier: local file or download.
    verses = await _loadBundle(locale);
    if (verses == null) {
      apiLog.warning(
        '[Bible] lookup load-failed: $locale — no local cache and download failed',
      );
      return null;
    }

    final text = _resolveReference(reference, verses);
    if (text == null) {
      apiLog.warning(
        '[Bible] lookup ref-missing: $locale $reference not in bundle (${verses.length} verses)',
      );
    } else {
      apiLog.info(
        '[Bible] lookup ok: $locale $reference → ${text.length} chars',
      );
    }
    return text;
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
    if (desc == null) {
      apiLog.info(
        '[Bible] preload skip: locale=$locale not in bundle registry '
        '→ reference-only fallback at prayer time',
      );
      return null;
    }

    // 2nd tier: local file cache.
    try {
      final file = await _localFile(desc.fileName);
      if (await file.exists()) {
        final stopwatch = Stopwatch()..start();
        final raw = await file.readAsString();
        final verses = _parseVersesFromJson(raw);
        stopwatch.stop();
        _memCache[locale] = verses;
        apiLog.info(
          '[Bible] file-cache hit: $locale ${verses.length} verses '
          '(${raw.length ~/ 1024}KB, ${stopwatch.elapsedMilliseconds}ms)',
        );
        return verses;
      } else {
        apiLog.debug('[Bible] file-cache miss: $locale — will download');
      }
    } catch (e) {
      apiLog.warning('[Bible] file-cache read failed: $locale', error: e);
    }

    // 3rd tier: download from Supabase Storage.
    final stopwatch = Stopwatch()..start();
    try {
      apiLog.info(
        '[Bible] download start: $locale ← $_bucket/${desc.storagePath}',
      );
      final bytes = await _client.storage
          .from(_bucket)
          .download(desc.storagePath);
      final raw = utf8.decode(bytes);
      final verses = _parseVersesFromJson(raw);
      stopwatch.stop();

      // Persist to local file cache (best-effort).
      unawaited(_writeLocal(desc.fileName, bytes));

      _memCache[locale] = verses;
      apiLog.info(
        '[Bible] download ok: $locale ${verses.length} verses '
        '(${bytes.length ~/ 1024}KB, ${stopwatch.elapsedMilliseconds}ms)',
      );
      return verses;
    } catch (e, stack) {
      stopwatch.stop();
      apiLog.error(
        '[Bible] download FAILED: $locale ← $_bucket/${desc.storagePath} '
        '(after ${stopwatch.elapsedMilliseconds}ms)',
        error: e,
        stackTrace: stack,
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
    final versePart = reference.substring(colon + 1); // e.g., "1-3"
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
