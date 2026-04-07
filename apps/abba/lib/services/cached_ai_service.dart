import '../models/prayer.dart';
import '../models/qt_meditation_result.dart';
import 'ai_service.dart';

/// Wraps an AiService with an in-memory LRU cache.
/// Same transcript+locale -> cached result (avoids duplicate API calls).
class CachedAiService implements AiService {
  final AiService _inner;
  static const int _maxCacheSize = 50;

  final _prayerCache = <String, PrayerResult>{};
  final _meditationCache = <String, QtMeditationResult>{};

  CachedAiService(this._inner);

  String _key(String text, String locale) =>
      '${locale}_${text.hashCode}';

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    final key = _key(transcript, locale);

    if (_prayerCache.containsKey(key)) {
      // Move to end (most recently used)
      final value = _prayerCache.remove(key)!;
      _prayerCache[key] = value;
      return value;
    }

    final result = await _inner.analyzePrayer(
      transcript: transcript,
      locale: locale,
    );

    _prayerCache[key] = result;

    // Evict oldest if over limit
    while (_prayerCache.length > _maxCacheSize) {
      _prayerCache.remove(_prayerCache.keys.first);
    }

    return result;
  }

  @override
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  }) async {
    final key = _key('$passageReference$meditationText', locale);

    if (_meditationCache.containsKey(key)) {
      final value = _meditationCache.remove(key)!;
      _meditationCache[key] = value;
      return value;
    }

    final result = await _inner.analyzeMeditation(
      passageReference: passageReference,
      passageText: passageText,
      meditationText: meditationText,
      locale: locale,
    );

    _meditationCache[key] = result;

    while (_meditationCache.length > _maxCacheSize) {
      _meditationCache.remove(_meditationCache.keys.first);
    }

    return result;
  }
}
