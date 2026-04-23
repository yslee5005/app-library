import '../models/prayer.dart';
import '../models/prayer_tier_result.dart';
import '../models/qt_meditation_result.dart';

/// Abstract AI service — mock returns JSON file data, real calls Gemini API
abstract class AiService {
  /// Phase 4.1 — 3-tier lazy generation. Emits TierResult events as each
  /// tier completes. T1 first (summary+scripture), T2 automatic background
  /// (bible_story+testimony), T3 is separate (see [analyzeTier3Prayer]).
  ///
  /// UI subscribes to this stream and updates Dashboard cards progressively.
  Stream<TierResult> analyzePrayerStreamed({
    required String transcript,
    required String locale,
    required String userName,
  });

  /// Phase 4.1 — T3 Pro-only. Called on scroll trigger from Dashboard.
  /// Requires T1 + T2 context for coherence.
  Future<TierResult> analyzeTier3Prayer({
    required String transcript,
    required String locale,
    required String userName,
    required TierT1Result t1Context,
    required TierT2Result t2Context,
  });

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

  /// Evaluate a prayer transcript against the Prayer Guide (ACTS + principles).
  /// Pro-only. Returns [PrayerCoaching.placeholder] on parse/API failure.
  Future<PrayerCoaching> analyzePrayerCoaching({
    required String transcript,
    required String locale,
  });

  /// Evaluate a QT meditation against the QT Guide (comprehension / application /
  /// depth / authenticity). Pro-only. Returns [QtCoaching.placeholder] on
  /// parse/API failure.
  Future<QtCoaching> analyzeQtCoaching({
    required String meditation,
    required String scriptureReference,
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
