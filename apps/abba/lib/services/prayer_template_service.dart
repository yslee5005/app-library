import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../models/prayer.dart';

/// Phase 4.1 INT-033 — Day-1 template fallback.
///
/// When Gemini is cold/unreachable (network failure, first launch without
/// cache), show a category-aware PrayerResult built from bundled JSON so
/// the user never sees an empty Dashboard. Templates live in
/// `assets/prayer_templates/{category}_{locale}.json` and are loaded
/// lazily; results are cached in memory for the session.
class PrayerTemplateService {
  PrayerTemplateService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Map<String, PrayerResult> _cache = {};

  static const _supportedCategories = {
    'health',
    'family',
    'gratitude',
    // Expand as new templates land in assets/prayer_templates/.
  };

  static const _localeFallback = 'en';

  /// Returns null when no template is available for the (category, locale)
  /// pair and the fallback asset is also missing. Callers should treat null
  /// as "render empty state" rather than as an error.
  Future<PrayerResult?> loadTemplate({
    required String category,
    required String locale,
  }) async {
    final key = '${category}_$locale';
    if (_cache.containsKey(key)) return _cache[key];

    final normalisedCategory = _supportedCategories.contains(category)
        ? category
        : 'gratitude';

    Future<String?> readAsset(String path) async {
      try {
        return await _bundle.loadString(path);
      } catch (_) {
        return null;
      }
    }

    final primary =
        'assets/prayer_templates/${normalisedCategory}_$locale.json';
    final fallback =
        'assets/prayer_templates/${normalisedCategory}_$_localeFallback.json';

    final raw = await readAsset(primary) ?? await readAsset(fallback);
    if (raw == null) {
      prayerLog.info(
        '[Template] no template for category=$category locale=$locale',
      );
      return null;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final result = PrayerResult.fromJson(json);
      _cache[key] = result;
      return result;
    } catch (e, st) {
      prayerLog.error(
        '[Template] parse failed for category=$category locale=$locale',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
