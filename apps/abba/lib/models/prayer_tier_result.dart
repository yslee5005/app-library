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

/// Phase 4.2 Phase C — emitted mid-stream when the tier1 analyzer has
/// extracted `scripture.reference` from the incoming Gemini chunks via
/// regex, BEFORE the full JSON is parsed. Lets the UI navigate from the
/// loading screen to the Dashboard while the verse is still being
/// validated and the summary is still arriving.
///
/// Followed by a full [TierT1Result] once the stream completes.
class TierT1ScriptureRef extends TierResult {
  final String reference;
  const TierT1ScriptureRef(this.reference);
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

/// Phase 4.2 Phase C — QT equivalent of [TierT1ScriptureRef]. Emitted as
/// soon as the QT tier1 analyzer has extracted `scripture.reference` from
/// the incoming stream so the Dashboard can navigate with a placeholder
/// scripture card while verse validation and meditation_summary are
/// still arriving.
class QtTierT1ScriptureRef extends TierResult {
  final String reference;
  const QtTierT1ScriptureRef(this.reference);
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
