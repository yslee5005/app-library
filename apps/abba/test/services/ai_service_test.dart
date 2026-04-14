import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/models/qt_meditation_result.dart';
import 'package:abba/services/ai_service.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/services/mock/mock_ai_service.dart';
import 'package:abba/services/cached_ai_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockAiService', () {
    late MockAiService service;

    setUp(() {
      service = MockAiService(MockDataService());
    });

    test('analyzePrayer returns PrayerResult', () async {
      final result = await service.analyzePrayer(
        transcript: 'Lord, thank you for today.',
        locale: 'en',
      );

      expect(result.scripture.reference, isNotEmpty);
      expect(result.scripture.verseEn, isNotEmpty);
      expect(result.bibleStory.titleEn, isNotEmpty);
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
        verseEn: 'Test verse',
        verseKo: '테스트 구절',
        reference: 'Test 1:1',
      ),
      bibleStory: BibleStory(
        titleEn: 'Test',
        titleKo: '테스트',
        summaryEn: 'Test story',
        summaryKo: '테스트 이야기',
      ),
      testimonyEn: 'Test transcript',
      testimonyKo: '테스트 간증',
    );
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
      analysis: MeditationAnalysis(
        keyThemeEn: 'Test',
        keyThemeKo: '테스트',
        insightEn: 'Test insight',
        insightKo: '테스트 인사이트',
      ),
      application: ApplicationSuggestion(
        action: '테스트 행동',
      ),
      knowledge: RelatedKnowledge(
        historicalContextEn: 'Test context',
        historicalContextKo: '테스트 배경',
        crossReferences: [CrossReference(reference: 'Test 1:1', text: '')],
      ),
    );
  }
}
