import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/models/qt_meditation_result.dart';
import 'package:abba/services/ai_service.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/services/mock/mock_ai_service.dart';
import 'package:abba/services/cached_ai_service.dart';

import '../helpers/test_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockAiService', () {
    late MockAiService service;

    setUp(() {
      // `fromData` fixtures bypass `rootBundle.loadString('assets/mock/*.json')`
      // which fails in `flutter_test` due to missing asset shim.
      final mockData = MockDataService.fromData(
        prayerResult: TestFixtures.prayerResult(),
      );
      service = MockAiService(mockData);
    });

    test('analyzePrayer returns PrayerResult', () async {
      final result = await service.analyzePrayer(
        transcript: 'Lord, thank you for today.',
        locale: 'en',
      );

      expect(result.scripture.reference, isNotEmpty);
      // Phase 6: verse text is populated at runtime via BibleTextService,
      // not by AiService. Mock service leaves it empty.
      expect(result.bibleStory.title, isNotEmpty);
      expect(result.testimony, isNotEmpty);
    });
  });

  group('CachedAiService', () {
    late _CountingAiService inner;
    late CachedAiService cached;

    setUp(() {
      inner = _CountingAiService();
      cached = CachedAiService(inner);
    });

    test('caches same transcript+locale', () async {
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');

      expect(inner.callCount, 1);
    });

    test('different locale creates separate cache entry', () async {
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayer(transcript: 'hello', locale: 'ko');

      expect(inner.callCount, 2);
    });

    test('different transcript creates separate cache entry', () async {
      await cached.analyzePrayer(transcript: 'hello', locale: 'en');
      await cached.analyzePrayer(transcript: 'goodbye', locale: 'en');

      expect(inner.callCount, 2);
    });
  });
}

class _CountingAiService implements AiService {
  int callCount = 0;

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    callCount++;
    return const PrayerResult(
      scripture: Scripture(
        reference: 'Test 1:1',
        verse: 'Test verse',
      ),
      bibleStory: BibleStory(
        title: 'Test',
        summary: 'Test story',
      ),
      testimony: 'Test transcript',
    );
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) => analyzePrayer(transcript: transcript, locale: locale);

  @override
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  }) async {
    callCount++;
    final result = await analyzePrayer(transcript: '', locale: locale);
    return (result: result, transcription: 'Mock transcription from audio');
  }

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    callCount++;
    return const PremiumContent();
  }

  @override
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  }) async {
    callCount++;
    return const QtMeditationResult(
      meditationSummary: MeditationSummary(
        summary: '',
        topic: '',
        insight: 'Test insight',
      ),
      application: ApplicationSuggestion(
        action: '테스트 행동',
      ),
      knowledge: RelatedKnowledge(
        historicalContext: 'Test context',
        crossReferences: [CrossReference(reference: 'Test 1:1', text: '')],
      ),
    );
  }

  @override
  Future<PrayerCoaching> analyzePrayerCoaching({
    required String transcript,
    required String locale,
  }) async {
    callCount++;
    return PrayerCoaching.placeholder();
  }

  @override
  Future<QtCoaching> analyzeQtCoaching({
    required String meditation,
    required String scriptureReference,
    required String locale,
  }) async {
    callCount++;
    return QtCoaching.placeholder();
  }
}
