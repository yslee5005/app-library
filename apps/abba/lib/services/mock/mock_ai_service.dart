import '../../models/prayer.dart';
import '../../models/qt_meditation_result.dart';
import '../ai_service.dart';
import '../mock_data.dart';

class MockAiService implements AiService {
  final MockDataService _mockData;

  MockAiService(this._mockData);

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return _mockData.getPrayerResult();
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final full = await _mockData.getPrayerResult();
    return PrayerResult(
      scripture: full.scripture,
      bibleStory: full.bibleStory,
      testimonyEn: full.testimonyEn,
      testimonyKo: full.testimonyKo,
      prayerSummary: full.prayerSummary,
    );
  }

  @override
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final full = await _mockData.getPrayerResult();
    final result = PrayerResult(
      scripture: full.scripture,
      bibleStory: full.bibleStory,
      testimonyEn: full.testimonyEn,
      testimonyKo: full.testimonyKo,
      prayerSummary: full.prayerSummary,
    );
    return (
      result: result,
      transcription: 'Dear Lord, I thank you for this beautiful morning. Please guide my steps today.',
    );
  }

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final full = await _mockData.getPrayerResult();
    return PremiumContent(
      historicalStory: full.historicalStory,
      aiPrayer: full.aiPrayer,
      guidance: full.guidance,
    );
  }

  @override
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return _mockData.getQtMeditationResult();
  }

  @override
  Future<PrayerCoaching> analyzePrayerCoaching({
    required String transcript,
    required String locale,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return const PrayerCoaching(
      scores: CoachingScores(
        specificity: 4,
        godCenteredness: 3,
        actsBalance: 4,
        authenticity: 4,
      ),
      strengths: [
        '가족과 친구를 구체적으로 떠올리며 기도하신 점이 좋습니다 — 이는 구체성의 좋은 예입니다.',
        '"감사합니다"로 시작해 "간구합니다"로 이어지는 흐름이 ACTS의 T와 S를 자연스럽게 담고 있어요.',
      ],
      improvements: [
        '회개 (Confession) 한 문장을 더해 보세요. 예: "오늘 급한 말을 용서해 주소서." 이것만으로도 ACTS 4축이 채워집니다.',
        '하나님의 속성 한 가지 — "거룩하신 주님" 같은 찬양 한 문장 — 을 시작에 더하시면 기도가 더 깊어질 거예요.',
      ],
      overallFeedbackEn:
          'Your prayer shows beautiful balance of gratitude and intercession. Adding one sentence of confession would complete the ACTS rhythm. God loves every heart that prays.',
      overallFeedbackKo:
          '감사와 중보가 아름답게 균형 잡힌 기도예요. 회개 한 문장을 더하시면 ACTS 4축이 완성됩니다. 하나님은 기도하는 당신의 마음을 사랑하십니다.',
      expertLevel: 'growing',
    );
  }
}
