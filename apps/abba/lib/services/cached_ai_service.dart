import '../models/prayer.dart';
import '../models/prayer_tier_result.dart';
import '../models/qt_meditation_result.dart';
import 'ai_service.dart';

/// Wraps an AiService with an in-memory LRU cache.
/// Same transcript+locale -> cached result (avoids duplicate API calls).
class CachedAiService implements AiService {
  final AiService _inner;
  static const int _maxCacheSize = 50;

  final _prayerCache = <String, PrayerResult>{};
  final _premiumCache = <String, PremiumContent>{};
  final _meditationCache = <String, QtMeditationResult>{};
  final _coachingCache = <String, PrayerCoaching>{};
  final _qtCoachingCache = <String, QtCoaching>{};

  CachedAiService(this._inner);

  String _key(String text, String locale) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return '${locale}_${today}_${text.hashCode}';
  }

  T? _getFromCache<T>(Map<String, T> cache, String key) {
    if (cache.containsKey(key)) {
      final value = cache.remove(key) as T;
      cache[key] = value;
      return value;
    }
    return null;
  }

  void _putInCache<T>(Map<String, T> cache, String key, T value) {
    cache[key] = value;
    while (cache.length > _maxCacheSize) {
      cache.remove(cache.keys.first);
    }
  }

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    final key = _key(transcript, locale);
    final cached = _getFromCache(_prayerCache, key);
    if (cached != null) return cached;

    final result = await _inner.analyzePrayer(
      transcript: transcript,
      locale: locale,
    );
    _putInCache(_prayerCache, key, result);
    return result;
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    final key = '${_key(transcript, locale)}_core';
    final cached = _getFromCache(_prayerCache, key);
    if (cached != null) return cached;

    final result = await _inner.analyzePrayerCore(
      transcript: transcript,
      locale: locale,
    );
    _putInCache(_prayerCache, key, result);
    return result;
  }

  @override
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  }) async {
    // Audio analysis is not cached (each recording is unique)
    return _inner.analyzePrayerFromAudio(
      audioFilePath: audioFilePath,
      locale: locale,
    );
  }

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    final key = _key(transcript, locale);
    final cached = _getFromCache(_premiumCache, key);
    if (cached != null) return cached;

    final result = await _inner.analyzePrayerPremium(
      transcript: transcript,
      locale: locale,
    );
    _putInCache(_premiumCache, key, result);
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
    final cached = _getFromCache(_meditationCache, key);
    if (cached != null) return cached;

    final result = await _inner.analyzeMeditation(
      passageReference: passageReference,
      passageText: passageText,
      meditationText: meditationText,
      locale: locale,
    );
    _putInCache(_meditationCache, key, result);
    return result;
  }

  @override
  Future<PrayerCoaching> analyzePrayerCoaching({
    required String transcript,
    required String locale,
  }) async {
    final key = '${_key(transcript, locale)}_coaching';
    final cached = _getFromCache(_coachingCache, key);
    if (cached != null) return cached;

    final result = await _inner.analyzePrayerCoaching(
      transcript: transcript,
      locale: locale,
    );
    _putInCache(_coachingCache, key, result);
    return result;
  }

  @override
  Future<QtCoaching> analyzeQtCoaching({
    required String meditation,
    required String scriptureReference,
    required String locale,
  }) async {
    final key = '${_key('$scriptureReference$meditation', locale)}_qt_coaching';
    final cached = _getFromCache(_qtCoachingCache, key);
    if (cached != null) return cached;

    final result = await _inner.analyzeQtCoaching(
      meditation: meditation,
      scriptureReference: scriptureReference,
      locale: locale,
    );
    _putInCache(_qtCoachingCache, key, result);
    return result;
  }

  // Phase 4.1 — tier-based calls pass through uncached for now. Caching
  // TierResult would require sealed-class map support; post-launch.
  @override
  Stream<TierResult> analyzePrayerStreamed({
    required String transcript,
    required String locale,
    required String userName,
  }) => _inner.analyzePrayerStreamed(
        transcript: transcript,
        locale: locale,
        userName: userName,
      );

  @override
  Future<TierResult> analyzeTier3Prayer({
    required String transcript,
    required String locale,
    required String userName,
    required TierT1Result t1Context,
    required TierT2Result t2Context,
  }) => _inner.analyzeTier3Prayer(
        transcript: transcript,
        locale: locale,
        userName: userName,
        t1Context: t1Context,
        t2Context: t2Context,
      );

  @override
  Stream<TierResult> analyzeMeditationStreamed({
    required String meditation,
    required String passageRef,
    required String passageText,
    required String locale,
    required String userName,
  }) => _inner.analyzeMeditationStreamed(
        meditation: meditation,
        passageRef: passageRef,
        passageText: passageText,
        locale: locale,
        userName: userName,
      );
}
