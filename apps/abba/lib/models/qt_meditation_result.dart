import 'prayer.dart';

/// Single-field summary of the user's meditation plus the passage topic.
/// Added in qt_output_redesign Phase 1. Rendered by `MeditationSummaryCard`.
class MeditationSummary {
  final String summary; // 1-2 sentence summary of the user's meditation text
  final String topic;   // Short 1-line topic of today's passage

  const MeditationSummary({
    required this.summary,
    required this.topic,
  });

  factory MeditationSummary.fromJson(Map<String, dynamic> json) {
    return MeditationSummary(
      summary: json['summary'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
    );
  }

  bool get isEmpty => summary.isEmpty && topic.isEmpty;
}

class QtMeditationResult {
  final MeditationSummary meditationSummary; // Phase 1 — new
  final Scripture scripture;                 // Phase 1 — new (Scripture Deep)
  final MeditationAnalysis analysis;
  final ApplicationSuggestion application;
  final RelatedKnowledge knowledge;
  final GrowthStory? growthStory;

  const QtMeditationResult({
    this.meditationSummary = const MeditationSummary(summary: '', topic: ''),
    this.scripture = const Scripture(reference: ''),
    required this.analysis,
    required this.application,
    required this.knowledge,
    this.growthStory,
  });

  /// Immutable copy with scripture replaced (e.g. after BibleTextService fills
  /// verse text from the PD bundle lookup).
  QtMeditationResult copyWithScripture(Scripture scripture) {
    return QtMeditationResult(
      meditationSummary: meditationSummary,
      scripture: scripture,
      analysis: analysis,
      application: application,
      knowledge: knowledge,
      growthStory: growthStory,
    );
  }

  /// Defensive cast: tolerates `Map<dynamic, dynamic>` JSON literals (common
  /// in tests and from some JSON libraries) without throwing.
  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return const {};
  }

  factory QtMeditationResult.fromJson(Map<String, dynamic> json) {
    final analysis = MeditationAnalysis.fromJson(_asMap(json['analysis']));

    // Phase 1 — parse new `meditation_summary` if present. Otherwise fall
    // back to legacy format: infer topic from analysis.keyTheme, leave
    // summary empty (hidden card if both empty).
    final MeditationSummary summary;
    final rawSummary = json['meditation_summary'];
    if (rawSummary is Map) {
      summary = MeditationSummary.fromJson(_asMap(rawSummary));
    } else {
      // Legacy compat: previous records have no meditation_summary.
      // Use English keyTheme as a best-effort topic (locale-agnostic here —
      // the card will hide automatically if both summary + topic are empty).
      final legacyTopic = analysis.keyThemeEn.isNotEmpty
          ? analysis.keyThemeEn
          : analysis.keyThemeKo;
      summary = MeditationSummary(summary: '', topic: legacyTopic);
    }

    // Phase 1 — parse new `scripture`. Legacy records have no scripture key;
    // default to an empty Scripture (reference: ''). ScriptureCard will
    // render nothing meaningful when reference is empty, which is fine for
    // legacy records rendered in history view.
    final Scripture scripture;
    final rawScripture = json['scripture'];
    if (rawScripture is Map) {
      scripture = Scripture.fromJson(_asMap(rawScripture));
    } else {
      scripture = const Scripture(reference: '');
    }

    return QtMeditationResult(
      meditationSummary: summary,
      scripture: scripture,
      analysis: analysis,
      application: ApplicationSuggestion.fromJson(_asMap(json['application'])),
      knowledge: RelatedKnowledge.fromJson(_asMap(json['knowledge'])),
      growthStory: json['growth_story'] != null
          ? GrowthStory.fromJson(_asMap(json['growth_story']))
          : null,
    );
  }
}

class MeditationAnalysis {
  final String keyThemeEn;
  final String keyThemeKo;
  final String insightEn;
  final String insightKo;

  const MeditationAnalysis({
    required this.keyThemeEn,
    required this.keyThemeKo,
    required this.insightEn,
    required this.insightKo,
  });

  factory MeditationAnalysis.fromJson(Map<String, dynamic> json) {
    // Phase 1 prompt uses single `insight` + no key_theme (topic moved to
    // meditationSummary). Legacy records still carry _en/_ko variants.
    final insight = json['insight'] as String?;
    return MeditationAnalysis(
      keyThemeEn: json['key_theme_en'] as String? ?? '',
      keyThemeKo: json['key_theme_ko'] as String? ?? '',
      insightEn: insight ?? json['insight_en'] as String? ?? '',
      insightKo: insight ?? json['insight_ko'] as String? ?? '',
    );
  }

  String keyTheme(String locale) => locale == 'ko' ? keyThemeKo : keyThemeEn;
  String insight(String locale) => locale == 'ko' ? insightKo : insightEn;
}

class ApplicationSuggestion {
  final String action;

  const ApplicationSuggestion({this.action = ''});

  factory ApplicationSuggestion.fromJson(Map<String, dynamic> json) {
    // New format (single action)
    if (json.containsKey('action') && json['action'] is String) {
      return ApplicationSuggestion(action: json['action'] as String);
    }
    // Legacy format fallback (action_ko or action_en)
    return ApplicationSuggestion(
      action: json['action_ko'] as String? ?? json['action_en'] as String? ?? '',
    );
  }
}

class CrossReference {
  final String reference;
  final String text;

  const CrossReference({required this.reference, required this.text});

  factory CrossReference.fromJson(Map<String, dynamic> json) {
    return CrossReference(
      reference: json['reference'] as String,
      text: json['text'] as String? ?? '',
    );
  }
}

class RelatedKnowledge {
  final OriginalWord? originalWord;
  final String historicalContextEn;
  final String historicalContextKo;
  final List<CrossReference> crossReferences;

  /// QT citations (Phase 3, qt_output_redesign). Mirrors `AiPrayer.citations`.
  /// Each citation: `{type: "quote"|"science"|"history"|"example",
  /// source: "author/work/year", content: "the quoted/factual statement"}`.
  /// Empty list when the model is not confident about any verifiable reference.
  final List<Citation> citations;

  const RelatedKnowledge({
    this.originalWord,
    this.historicalContextEn = '',
    this.historicalContextKo = '',
    this.crossReferences = const [],
    this.citations = const [],
  });

  factory RelatedKnowledge.fromJson(Map<String, dynamic> json) {
    final single = json['historical_context'] as String?;
    return RelatedKnowledge(
      originalWord: json['original_word'] != null
          ? OriginalWord.fromJson(
              json['original_word'] as Map<String, dynamic>,
            )
          : null,
      historicalContextEn:
          single ?? json['historical_context_en'] as String? ?? '',
      historicalContextKo:
          single ?? json['historical_context_ko'] as String? ?? '',
      crossReferences: (json['cross_references'] as List<dynamic>?)
              ?.map((e) {
                if (e is String) return CrossReference(reference: e, text: '');
                return CrossReference.fromJson(e as Map<String, dynamic>);
              })
              .toList() ??
          [],
      citations: (json['citations'] as List<dynamic>?)
              ?.map((e) => Citation.fromJson(e as Map<String, dynamic>))
              .where((c) => c.content.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  String historicalContext(String locale) =>
      locale == 'ko' ? historicalContextKo : historicalContextEn;
}

class OriginalWord {
  final String word;
  final String transliteration;
  final String language;
  final String meaningEn;
  final String meaningKo;

  const OriginalWord({
    required this.word,
    required this.transliteration,
    required this.language,
    required this.meaningEn,
    required this.meaningKo,
  });

  factory OriginalWord.fromJson(Map<String, dynamic> json) {
    return OriginalWord(
      word: json['word'] as String,
      transliteration: json['transliteration'] as String,
      language: json['language'] as String,
      meaningEn: json['meaning_en'] as String,
      meaningKo: json['meaning_ko'] as String,
    );
  }

  String meaning(String locale) => locale == 'ko' ? meaningKo : meaningEn;
}

/// Spiritual growth story tied to today's meditation. Phase 4 of
/// qt_output_redesign collapsed this to single-field (generated in the user's
/// locale by Gemini). Legacy DB records that still carry `_en`/`_ko` pairs
/// fall through a 3-stage resolver: `title` → `title_en` → `title_ko`.
class GrowthStory {
  final String title;   // In the user's locale (Gemini-generated)
  final String summary; // 8-12 sentence narrative of a REAL Bible/church-history figure
  final String lesson;  // 2-3 sentence application tied to today's meditation
  final bool isPremium;

  const GrowthStory({
    required this.title,
    required this.summary,
    required this.lesson,
    required this.isPremium,
  });

  factory GrowthStory.fromJson(Map<String, dynamic> json) {
    // Phase 4 — single-field is the primary schema. `_en`/`_ko` are legacy
    // fallbacks so historical DB records keep rendering. No locale info is
    // available here, so prefer English, then Korean, then empty string.
    return GrowthStory(
      title: json['title'] as String?
          ?? json['title_en'] as String?
          ?? json['title_ko'] as String?
          ?? '',
      summary: json['summary'] as String?
          ?? json['summary_en'] as String?
          ?? json['summary_ko'] as String?
          ?? '',
      lesson: json['lesson'] as String?
          ?? json['lesson_en'] as String?
          ?? json['lesson_ko'] as String?
          ?? '',
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }
}

/// QT Coaching scores — Pro-only, mirrors `CoachingScores` but with the
/// QT 4 axes: comprehension / application / depth / authenticity.
/// Phase 2 of qt_output_redesign (INT-112).
class QtScores {
  final int comprehension; // 본문 이해 1-5
  final int application;    // 개인 적용 (3P) 1-5
  final int depth;          // 영적 깊이 1-5
  final int authenticity;   // 진정성 1-5

  const QtScores({
    required this.comprehension,
    required this.application,
    required this.depth,
    required this.authenticity,
  });

  factory QtScores.fromJson(Map<String, dynamic> json) {
    return QtScores(
      comprehension: (json['comprehension'] as num?)?.toInt() ?? 0,
      application: (json['application'] as num?)?.toInt() ?? 0,
      depth: (json['depth'] as num?)?.toInt() ?? 0,
      authenticity: (json['authenticity'] as num?)?.toInt() ?? 0,
    );
  }

  double get average =>
      (comprehension + application + depth + authenticity) / 4.0;
}

/// QT Coaching result — Pro-only, mirrors `PrayerCoaching` but evaluated
/// against the QT Guide (`assets/docs/qt_guide.md`). Phase 2 of
/// qt_output_redesign (INT-111).
class QtCoaching {
  final QtScores scores;
  final List<String> strengths;
  final List<String> improvements;
  final String overallFeedbackEn;
  final String overallFeedbackKo;
  final String expertLevel; // "beginner" | "growing" | "expert"
  final bool isPremium;

  const QtCoaching({
    required this.scores,
    required this.strengths,
    required this.improvements,
    required this.overallFeedbackEn,
    required this.overallFeedbackKo,
    required this.expertLevel,
    this.isPremium = true,
  });

  String overallFeedback(String locale) =>
      locale == 'ko' ? overallFeedbackKo : overallFeedbackEn;

  factory QtCoaching.fromJson(Map<String, dynamic> json) {
    return QtCoaching(
      scores: QtScores.fromJson(
        json['scores'] as Map<String, dynamic>? ?? const {},
      ),
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      improvements: (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      overallFeedbackEn: json['overall_feedback_en'] as String? ?? '',
      overallFeedbackKo: json['overall_feedback_ko'] as String? ?? '',
      expertLevel: json['expert_level'] as String? ?? 'growing',
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  /// Placeholder for locked card display (Free users) and API failures.
  factory QtCoaching.placeholder() => const QtCoaching(
        scores: QtScores(
          comprehension: 0,
          application: 0,
          depth: 0,
          authenticity: 0,
        ),
        strengths: [],
        improvements: [],
        overallFeedbackEn:
            'Unlock your personal meditation coaching feedback...',
        overallFeedbackKo: 'Pro로 당신의 묵상에 대한 맞춤 코칭을 받아보세요...',
        expertLevel: 'growing',
      );
}
