import 'qt_meditation_result.dart';

/// AI analysis lifecycle state (2026-04-23 Pending/Retry 아키텍처).
/// See apps/abba/specs/DESIGN.md §10.
enum PrayerAiStatus {
  /// Raw prayer saved, awaiting AI analysis.
  pending,

  /// Edge Function is currently running AI analysis.
  processing,

  /// AI analysis complete, `result`/`qtResult` populated.
  completed,

  /// Edge Function exceeded 10 retries — permanent failure. Raw prayer
  /// still preserved; user sees "분석 어려움" message.
  failed,
}

PrayerAiStatus _parseAiStatus(dynamic raw) {
  if (raw is String) {
    switch (raw) {
      case 'pending':
        return PrayerAiStatus.pending;
      case 'processing':
        return PrayerAiStatus.processing;
      case 'failed':
        return PrayerAiStatus.failed;
      case 'completed':
      default:
        return PrayerAiStatus.completed;
    }
  }
  // Legacy rows pre-migration: treat as completed (they were analyzed).
  return PrayerAiStatus.completed;
}

class Prayer {
  final String id;
  final String userId;
  final String transcript;
  final String mode; // 'prayer' | 'qt'
  final String? qtPassageRef;
  final String? audioPath; // local file path for voice recordings
  final String? audioStoragePath; // Supabase Storage path (e.g., 'abba/{userId}/{id}.m4a')
  final int durationSeconds;
  final DateTime createdAt;
  final PrayerResult? result;     // mode='prayer' — AI prayer analysis
  final QtMeditationResult? qtResult; // Phase 5D — mode='qt' persistence

  /// 2026-04-23 Pending/Retry: AI analysis lifecycle state.
  final PrayerAiStatus aiStatus;

  /// 2026-04-23 Pending/Retry: last Edge Function retry timestamp (for
  /// 10-minute cooldown). Null = never retried server-side.
  final DateTime? lastRetryAt;

  const Prayer({
    required this.id,
    required this.userId,
    required this.transcript,
    required this.mode,
    this.qtPassageRef,
    this.audioPath,
    this.audioStoragePath,
    this.durationSeconds = 0,
    required this.createdAt,
    this.result,
    this.qtResult,
    this.aiStatus = PrayerAiStatus.completed,
    this.lastRetryAt,
  });

  factory Prayer.fromJson(Map<String, dynamic> json) {
    // Phase 5D — `result` JSONB is mode-polymorphic. Dispatch on `mode`:
    //   mode='qt'     → QtMeditationResult (new) into `qtResult`
    //   mode='prayer' → PrayerResult into `result`
    // Legacy QT records written before Phase 5D carry result=null, which is
    // fine — both fields stay null and history list still renders the row.
    final mode = json['mode'] as String;
    final resultJson = json['result'];

    PrayerResult? prayerResult;
    QtMeditationResult? qtResult;
    if (resultJson is Map<String, dynamic>) {
      if (mode == 'qt') {
        qtResult = QtMeditationResult.fromJson(resultJson);
      } else {
        prayerResult = PrayerResult.fromJson(resultJson);
      }
    }

    final lastRetryRaw = json['last_retry_at'];
    return Prayer(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      transcript: json['transcript'] as String? ?? '',
      mode: mode,
      qtPassageRef: json['qt_passage_ref'] as String?,
      audioPath: json['audio_path'] as String?,
      audioStoragePath: json['audio_storage_path'] as String?,
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      result: prayerResult,
      qtResult: qtResult,
      aiStatus: _parseAiStatus(json['ai_status']),
      lastRetryAt: lastRetryRaw is String ? DateTime.parse(lastRetryRaw) : null,
    );
  }
}

class PrayerSummary {
  final List<String> gratitude;
  final List<String> petition;
  final List<String> intercession;
  final int durationSeconds;

  const PrayerSummary({
    required this.gratitude,
    required this.petition,
    required this.intercession,
    this.durationSeconds = 0,
  });

  factory PrayerSummary.fromJson(Map<String, dynamic> json) {
    return PrayerSummary(
      gratitude: (json['gratitude'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      petition: (json['petition'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      intercession: (json['intercession'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      durationSeconds: json['duration_seconds'] as int? ?? 0,
    );
  }
}

class HistoricalStory {
  final String title;
  final String reference;
  final String summary;
  final String lesson;
  final bool isPremium;

  const HistoricalStory({
    required this.title,
    required this.reference,
    required this.summary,
    required this.lesson,
    required this.isPremium,
  });

  factory HistoricalStory.fromJson(Map<String, dynamic> json) {
    return HistoricalStory(
      title: json['title'] as String?
          ?? json['title_en'] as String?
          ?? json['title_ko'] as String?
          ?? '',
      reference: json['reference'] as String? ?? '',
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

  /// Placeholder for locked premium card display (locale-aware).
  factory HistoricalStory.placeholder(String locale) => HistoricalStory(
        title: locale == 'ko' ? '믿음의 이야기' : 'A Story of Faith',
        reference: '',
        summary: locale == 'ko'
            ? '성경 역사 속 감동적인 이야기를 만나보세요...'
            : 'Unlock to discover a powerful story from Bible history...',
        lesson: '',
        isPremium: true,
      );
}

class PrayerResult {
  final Scripture scripture;
  final BibleStory bibleStory;
  final String testimony;
  final Guidance? guidance;
  final AiPrayer? aiPrayer;
  final PrayerSummary? prayerSummary;
  final HistoricalStory? historicalStory;

  const PrayerResult({
    required this.scripture,
    required this.bibleStory,
    required this.testimony,
    this.guidance,
    this.aiPrayer,
    this.prayerSummary,
    this.historicalStory,
  });

  /// Merge premium content into an existing core result
  PrayerResult copyWithPremium({
    HistoricalStory? historicalStory,
    AiPrayer? aiPrayer,
    Guidance? guidance,
  }) {
    return PrayerResult(
      scripture: scripture,
      bibleStory: bibleStory,
      testimony: testimony,
      prayerSummary: prayerSummary,
      historicalStory: historicalStory ?? this.historicalStory,
      aiPrayer: aiPrayer ?? this.aiPrayer,
      guidance: guidance ?? this.guidance,
    );
  }

  factory PrayerResult.fromJson(Map<String, dynamic> json) {
    // Accept both flat (new Phase 6+ format: testimony: "...") and nested
    // legacy (Phase 1-5: testimony.transcript_en/_ko). 3-tier fallback.
    final testimonyRaw = json['testimony'];
    final String testimonyValue = switch (testimonyRaw) {
      String s => s,
      Map m => (m['transcript'] as String?)
          ?? (m['transcript_en'] as String?)
          ?? (m['transcript_ko'] as String?)
          ?? '',
      _ => '',
    };
    return PrayerResult(
      scripture: Scripture.fromJson(json['scripture'] as Map<String, dynamic>),
      bibleStory: BibleStory.fromJson(
        json['bible_story'] as Map<String, dynamic>,
      ),
      testimony: testimonyValue,
      guidance: json['guidance'] != null
          ? Guidance.fromJson(json['guidance'] as Map<String, dynamic>)
          : null,
      aiPrayer: json['ai_prayer'] != null
          ? AiPrayer.fromJson(json['ai_prayer'] as Map<String, dynamic>)
          : null,
      prayerSummary: json['prayer_summary'] != null
          ? PrayerSummary.fromJson(
              json['prayer_summary'] as Map<String, dynamic>,
            )
          : null,
      historicalStory: json['historical_story'] != null
          ? HistoricalStory.fromJson(
              json['historical_story'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class Scripture {
  final String reference;
  final String verse;        // PD translation text (from BibleTextService lookup)
  final String reason;       // AI 창작 (사용자 locale)
  final String posture;      // AI 창작
  final String keyWordHint;  // ✨ 핵심 단어 원-라이너 (AI 창작)
  final List<ScriptureOriginalWord> originalWords;

  const Scripture({
    required this.reference,
    this.verse = '',
    this.reason = '',
    this.posture = '',
    this.keyWordHint = '',
    this.originalWords = const [],
  });

  factory Scripture.fromJson(Map<String, dynamic> json) {
    return Scripture(
      reference: json['reference'] as String? ?? '',
      // BibleTextService가 runtime에 채움. legacy verse_en/verse_ko 는 무시.
      verse: json['verse'] as String? ?? '',
      reason: json['reason'] as String?
          ?? json['reason_en'] as String?
          ?? json['reason_ko'] as String?
          ?? '',
      posture: json['posture'] as String?
          ?? json['posture_en'] as String?
          ?? json['posture_ko'] as String?
          ?? '',
      keyWordHint: json['key_word_hint'] as String? ?? '',
      originalWords: (json['original_words'] as List<dynamic>?)
              ?.map((e) => ScriptureOriginalWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// Immutable copy with verse text filled (e.g., after BibleTextService lookup).
  Scripture withVerse(String verseText) => Scripture(
        reference: reference,
        verse: verseText,
        reason: reason,
        posture: posture,
        keyWordHint: keyWordHint,
        originalWords: originalWords,
      );
}

/// Phase 5A (qt_output_redesign) — single-field in user's locale (Gemini
/// generates in the active locale). Shared by Prayer + QT Scripture cards.
/// Legacy records carrying `meaning_en`/`_ko` + `nuance_en`/`_ko` parse via
/// the 3-tier fallback below.
class ScriptureOriginalWord {
  final String word;
  final String transliteration;
  final String language; // "Hebrew" | "Greek"
  final String meaning;
  final String nuance;

  const ScriptureOriginalWord({
    required this.word,
    required this.transliteration,
    required this.language,
    this.meaning = '',
    this.nuance = '',
  });

  factory ScriptureOriginalWord.fromJson(Map<String, dynamic> json) {
    return ScriptureOriginalWord(
      word: json['word'] as String,
      transliteration: json['transliteration'] as String,
      language: json['language'] as String,
      meaning: json['meaning'] as String?
          ?? json['meaning_en'] as String?
          ?? json['meaning_ko'] as String?
          ?? '',
      nuance: json['nuance'] as String?
          ?? json['nuance_en'] as String?
          ?? json['nuance_ko'] as String?
          ?? '',
    );
  }

  /// Phase 5D — single-field snake_case (no legacy `_en`/`_ko` dual write).
  Map<String, dynamic> toJson() => {
        'word': word,
        'transliteration': transliteration,
        'language': language,
        'meaning': meaning,
        'nuance': nuance,
      };

  bool get isRtl => language == 'Hebrew';
}

class BibleStory {
  final String title;
  final String summary;

  const BibleStory({required this.title, required this.summary});

  factory BibleStory.fromJson(Map<String, dynamic> json) {
    return BibleStory(
      title: json['title'] as String?
          ?? json['title_en'] as String?
          ?? json['title_ko'] as String?
          ?? '',
      summary: json['summary'] as String?
          ?? json['summary_en'] as String?
          ?? json['summary_ko'] as String?
          ?? '',
    );
  }
}

class Guidance {
  final String content;
  final bool isPremium;

  const Guidance({required this.content, required this.isPremium});

  factory Guidance.fromJson(Map<String, dynamic> json) {
    return Guidance(
      content: json['content'] as String?
          ?? json['content_en'] as String?
          ?? json['content_ko'] as String?
          ?? '',
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }
}

class AiPrayer {
  final String text;
  final List<Citation> citations;
  final bool isPremium;

  const AiPrayer({
    required this.text,
    this.citations = const [],
    required this.isPremium,
  });

  factory AiPrayer.fromJson(Map<String, dynamic> json) {
    return AiPrayer(
      text: json['text'] as String?
          ?? json['text_en'] as String?
          ?? json['text_ko'] as String?
          ?? '',
      citations: (json['citations'] as List<dynamic>?)
              ?.map((e) => Citation.fromJson(e as Map<String, dynamic>))
              .where((c) => c.content.isNotEmpty)
              .toList() ??
          const [],
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  /// Placeholder for locked premium card display (locale-aware).
  factory AiPrayer.placeholder(String locale) => AiPrayer(
        text: locale == 'ko'
            ? '당신만을 위한 기도문을 받아보세요...'
            : 'Unlock to receive a personalized prayer...',
        isPremium: true,
      );
}

/// Citation attached to an AI-generated prayer or QT meditation — source
/// for a quote, scientific fact, historical reference, or concrete example.
/// Used to deepen meaning with verifiable references.
class Citation {
  final String type;    // "quote" | "science" | "history" | "example"
  final String source;  // author, work, or study (may be empty for "example")
  final String content; // the quoted text or factual statement in user locale

  const Citation({
    required this.type,
    required this.source,
    required this.content,
  });

  factory Citation.fromJson(Map<String, dynamic> json) {
    return Citation(
      type: json['type'] as String? ?? 'quote',
      source: json['source'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }
}

class CoachingScores {
  final int specificity;
  final int godCenteredness;
  final int actsBalance;
  final int authenticity;

  const CoachingScores({
    required this.specificity,
    required this.godCenteredness,
    required this.actsBalance,
    required this.authenticity,
  });

  factory CoachingScores.fromJson(Map<String, dynamic> json) {
    return CoachingScores(
      specificity: (json['specificity'] as num?)?.toInt() ?? 0,
      godCenteredness: (json['god_centeredness'] as num?)?.toInt() ?? 0,
      actsBalance: (json['acts_balance'] as num?)?.toInt() ?? 0,
      authenticity: (json['authenticity'] as num?)?.toInt() ?? 0,
    );
  }

  double get average =>
      (specificity + godCenteredness + actsBalance + authenticity) / 4.0;
}

class PrayerCoaching {
  final CoachingScores scores;
  final List<String> strengths;
  final List<String> improvements;
  final String overallFeedbackEn;
  final String overallFeedbackKo;
  final String expertLevel; // "beginner" | "growing" | "expert"
  final bool isPremium;

  const PrayerCoaching({
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

  factory PrayerCoaching.fromJson(Map<String, dynamic> json) {
    return PrayerCoaching(
      scores: CoachingScores.fromJson(
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

  /// Placeholder for locked premium card display (Free users).
  factory PrayerCoaching.placeholder() => const PrayerCoaching(
        scores: CoachingScores(
          specificity: 0,
          godCenteredness: 0,
          actsBalance: 0,
          authenticity: 0,
        ),
        strengths: [],
        improvements: [],
        overallFeedbackEn: 'Unlock your personal prayer coaching feedback...',
        overallFeedbackKo: 'Pro로 당신의 기도에 대한 맞춤 코칭을 받아보세요...',
        expertLevel: 'growing',
      );
}
