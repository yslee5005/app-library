import '../models/prayer.dart';
import 'ai_service.dart';

/// Wraps an AiService with an in-memory LRU cache.
/// Same transcript+locale → cached result (avoids duplicate API calls).
class CachedAiService implements AiService {
  final AiService _inner;
  static const int _maxCacheSize = 50;

  final _cache = <String, PrayerResult>{};

  CachedAiService(this._inner);

  String _key(String transcript, String locale) =>
      '${locale}_${transcript.hashCode}';

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    final key = _key(transcript, locale);

    if (_cache.containsKey(key)) {
      // Move to end (most recently used)
      final value = _cache.remove(key)!;
      _cache[key] = value;
      return value;
    }

    final result = await _inner.analyzePrayer(
      transcript: transcript,
      locale: locale,
    );

    _cache[key] = result;

    // Evict oldest if over limit
    while (_cache.length > _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

    return result;
  }
}
