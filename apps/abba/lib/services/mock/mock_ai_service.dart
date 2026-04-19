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
}
