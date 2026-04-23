import 'prayer.dart';
import 'qt_meditation_result.dart';
import '../services/ai_analysis_exception.dart';

/// Result of a single tier Gemini call. Emitted as a Stream from
/// `GeminiService.analyzePrayerStreamed()` so UI can reveal sections
/// progressively.
///
/// See: apps/abba/specs/phase_4_1_section_based_ai/_details/architecture.md
sealed class TierResult {
  const TierResult();
}

/// T1 result — summary + scripture (immediate, streaming).
class TierT1Result extends TierResult {
  final PrayerSummary summary;
  final Scripture scripture;

  const TierT1Result({
    required this.summary,
    required this.scripture,
  });
}

/// T2 result — bible_story + testimony (background).
class TierT2Result extends TierResult {
  final BibleStory bibleStory;
  final String testimony;

  const TierT2Result({
    required this.bibleStory,
    required this.testimony,
  });
}

/// T3 result — Pro premium sections (on scroll trigger).
class TierT3Result extends TierResult {
  final Guidance? guidance;
  final AiPrayer? aiPrayer;
  final HistoricalStory? historicalStory;

  const TierT3Result({
    this.guidance,
    this.aiPrayer,
    this.historicalStory,
  });
}

/// QT T1 result — meditation_summary + scripture.
class QtTierT1Result extends TierResult {
  final MeditationSummary meditationSummary;
  final Scripture scripture;

  const QtTierT1Result({
    required this.meditationSummary,
    required this.scripture,
  });
}

/// QT T2 result — application + knowledge.
class QtTierT2Result extends TierResult {
  final ApplicationSuggestion application;
  final RelatedKnowledge knowledge;

  const QtTierT2Result({
    required this.application,
    required this.knowledge,
  });
}

/// Tier failed — emit this instead of the tier-specific result. UI may
/// render a partial error state (only this section affected).
class TierFailed extends TierResult {
  final String tier; // 't1' | 't2' | 't3'
  final AiAnalysisException error;

  const TierFailed({
    required this.tier,
    required this.error,
  });
}
