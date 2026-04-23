import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/models/prayer_tier_result.dart';
import 'package:abba/models/qt_meditation_result.dart';
import 'package:abba/services/ai_service.dart';
import 'package:abba/services/cached_ai_service.dart';

/// Dedicated cache-behavior tests for [CachedAiService].
///
/// NOTE: `ai_service_test.dart` has a minimal 3-test smoke set for the happy
/// path (same transcript+locale, different locale, different transcript).
/// This file expands on that with per-method caches, LRU eviction, the
/// audio-bypass contract, and independence between prayer / premium /
/// meditation / coaching caches.
void main() {
  group('CachedAiService — per-method caching', () {
    late _CountingAiService inner;
    late CachedAiService cached;

    setUp(() {
      inner = _CountingAiService();
      cached = CachedAiService(inner);
    });

    test('analyzePrayer: hit on identical (transcript, locale)', () async {
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');

      expect(inner.prayerCount, 1);
    });

    test('analyzePrayer: miss on different locale', () async {
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayer(transcript: 'hello', locale: 'ko');

      expect(inner.prayerCount, 2);
    });

    test('analyzePrayerCore: uses key distinct from analyzePrayer', () async {
      // Same transcript+locale but different method → should NOT cross-hit.
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayerCore(transcript: 'hello', locale: 'en');

      expect(inner.prayerCount, 1);
      expect(inner.prayerCoreCount, 1);
    });

    test('analyzePrayerPremium: cached independently from prayer', () async {
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayerPremium(transcript: 'hello', locale: 'en');
      await cached.analyzePrayerPremium(transcript: 'hello', locale: 'en');

      expect(inner.prayerCount, 1);
      expect(inner.premiumCount, 1);
    });

    test('analyzeMeditation: keyed on passageReference + meditationText',
        () async {
      await cached.analyzeMeditation(
        passageReference: 'Ps 23',
        passageText: 'The Lord is my shepherd',
        meditationText: 'I felt peace',
        locale: 'en',
      );
      await cached.analyzeMeditation(
        passageReference: 'Ps 23',
        passageText: 'The Lord is my shepherd',
        meditationText: 'I felt peace',
        locale: 'en',
      );
      // Same passage, different meditation text → cache miss.
      await cached.analyzeMeditation(
        passageReference: 'Ps 23',
        passageText: 'The Lord is my shepherd',
        meditationText: 'Different reflection',
        locale: 'en',
      );

      expect(inner.meditationCount, 2);
    });

    test('analyzePrayerCoaching: cached independently from prayer', () async {
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayerCoaching(transcript: 'hello', locale: 'en');
      await cached.analyzePrayerCoaching(transcript: 'hello', locale: 'en');

      expect(inner.prayerCount, 1);
      expect(inner.coachingCount, 1);
    });

    test('analyzeQtCoaching: cached independently from meditation', () async {
      await cached.analyzeMeditation(
        passageReference: 'Ps 23',
        passageText: 'x',
        meditationText: 'y',
        locale: 'en',
      );
      await cached.analyzeQtCoaching(
        meditation: 'y',
        scriptureReference: 'Ps 23',
        locale: 'en',
      );
      await cached.analyzeQtCoaching(
        meditation: 'y',
        scriptureReference: 'Ps 23',
        locale: 'en',
      );

      expect(inner.meditationCount, 1);
      expect(inner.qtCoachingCount, 1);
    });
  });

  group('CachedAiService — audio bypass', () {
    test('analyzePrayerFromAudio is never cached', () async {
      final inner = _CountingAiService();
      final cached = CachedAiService(inner);

      await cached.analyzePrayerFromAudio(
        audioFilePath: '/tmp/a.m4a',
        locale: 'en',
      );
      await cached.analyzePrayerFromAudio(
        audioFilePath: '/tmp/a.m4a',
        locale: 'en',
      );

      // Audio files are always unique recordings — inner called twice.
      expect(inner.audioCount, 2);
    });
  });

  group('CachedAiService — LRU eviction', () {
    test('exceeding maxCacheSize evicts oldest entry', () async {
      final inner = _CountingAiService();
      final cached = CachedAiService(inner);

      // _maxCacheSize is 50. Insert 51 distinct entries.
      for (var i = 0; i < 51; i++) {
        await cached.analyzePrayer(transcript: 'msg-$i', locale: 'en');
      }
      expect(inner.prayerCount, 51);

      // The OLDEST entry (msg-0) should have been evicted → re-call re-executes.
      await cached.analyzePrayer(transcript: 'msg-0', locale: 'en');
      expect(inner.prayerCount, 52);

      // The most-recent entry (msg-50) should still be cached → no new call.
      await cached.analyzePrayer(transcript: 'msg-50', locale: 'en');
      expect(inner.prayerCount, 52);
    });

    test('re-access promotes entry so it is not evicted next', () async {
      final inner = _CountingAiService();
      final cached = CachedAiService(inner);

      // Seed 50 entries (fills cache exactly).
      for (var i = 0; i < 50; i++) {
        await cached.analyzePrayer(transcript: 'msg-$i', locale: 'en');
      }
      expect(inner.prayerCount, 50);

      // Touch msg-0 → becomes most-recently-used.
      await cached.analyzePrayer(transcript: 'msg-0', locale: 'en');
      expect(inner.prayerCount, 50); // still cached

      // Add 1 new entry → now 51 entries → evicts LRU (which is msg-1, not msg-0).
      await cached.analyzePrayer(transcript: 'msg-new', locale: 'en');
      expect(inner.prayerCount, 51);

      // msg-0 should still be cached.
      await cached.analyzePrayer(transcript: 'msg-0', locale: 'en');
      expect(inner.prayerCount, 51);

      // msg-1 should have been evicted.
      await cached.analyzePrayer(transcript: 'msg-1', locale: 'en');
      expect(inner.prayerCount, 52);
    });
  });
}

/// Per-method counters so tests can assert which cache was hit.
class _CountingAiService implements AiService {
  int prayerCount = 0;
  int prayerCoreCount = 0;
  int audioCount = 0;
  int premiumCount = 0;
  int meditationCount = 0;
  int coachingCount = 0;
  int qtCoachingCount = 0;

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    prayerCount++;
    return _stubResult();
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    prayerCoreCount++;
    return _stubResult();
  }

  @override
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  }) async {
    audioCount++;
    return (result: _stubResult(), transcription: 'audio-$audioCount');
  }

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    premiumCount++;
    return const PremiumContent();
  }

  @override
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  }) async {
    meditationCount++;
    return const QtMeditationResult(
      meditationSummary: MeditationSummary(
        summary: '',
        topic: '',
        insight: 'stub',
      ),
      application: ApplicationSuggestion(action: 'stub'),
      knowledge: RelatedKnowledge(
        historicalContext: '',
        crossReferences: [CrossReference(reference: 'Ps 23', text: '')],
      ),
    );
  }

  @override
  Future<PrayerCoaching> analyzePrayerCoaching({
    required String transcript,
    required String locale,
  }) async {
    coachingCount++;
    return PrayerCoaching.placeholder();
  }

  @override
  Future<QtCoaching> analyzeQtCoaching({
    required String meditation,
    required String scriptureReference,
    required String locale,
  }) async {
    qtCoachingCount++;
    return QtCoaching.placeholder();
  }

  PrayerResult _stubResult() => const PrayerResult(
        scripture: Scripture(reference: 'Test 1:1', verse: 'stub'),
        bibleStory: BibleStory(title: 'stub', summary: 'stub'),
        testimony: 'stub',
      );

  @override
  Stream<TierResult> analyzePrayerStreamed({
    required String transcript,
    required String locale,
    required String userName,
  }) async* {
    // Minimal stub — tier-based caching is pass-through
  }

  @override
  Future<TierResult> analyzeTier3Prayer({
    required String transcript,
    required String locale,
    required String userName,
    required TierT1Result t1Context,
    required TierT2Result t2Context,
  }) async => const TierT3Result();
}
