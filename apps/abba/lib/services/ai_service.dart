import '../models/prayer.dart';
import '../models/qt_meditation_result.dart';

/// Abstract AI service — mock returns JSON file data, real calls Gemini API
abstract class AiService {
  /// Analyze prayer transcript and return structured result (all sections)
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  });

  /// Analyze prayer — core sections only (summary, scripture, testimony, bible story)
  /// Used for initial fast response. Premium sections are null.
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  });

  /// Analyze prayer from audio file — Gemini transcribes + analyzes in one call.
  /// Returns both the PrayerResult and the raw transcription.
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  });

  /// Generate premium sections only (historical story, ai prayer, guidance)
  /// Called on-demand when user expands a premium card.
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  });

  /// Analyze QT meditation and return structured result
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  });
}

/// Premium-only content generated on-demand
class PremiumContent {
  final HistoricalStory? historicalStory;
  final AiPrayer? aiPrayer;
  final Guidance? guidance;

  const PremiumContent({
    this.historicalStory,
    this.aiPrayer,
    this.guidance,
  });
}
