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
  final PrayerResult? result;

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
  });

  factory Prayer.fromJson(Map<String, dynamic> json) {
    return Prayer(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      transcript: json['transcript'] as String,
      mode: json['mode'] as String,
      qtPassageRef: json['qt_passage_ref'] as String?,
      audioPath: json['audio_path'] as String?,
      audioStoragePath: json['audio_storage_path'] as String?,
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      result: json['result'] != null
          ? PrayerResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
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
  final String titleEn;
  final String titleKo;
  final String reference;
  final String summaryEn;
  final String summaryKo;
  final String lessonEn;
  final String lessonKo;
  final bool isPremium;

  const HistoricalStory({
    required this.titleEn,
    required this.titleKo,
    required this.reference,
    required this.summaryEn,
    required this.summaryKo,
    required this.lessonEn,
    required this.lessonKo,
    required this.isPremium,
  });

  factory HistoricalStory.fromJson(Map<String, dynamic> json) {
    return HistoricalStory(
      titleEn: json['title_en'] as String,
      titleKo: json['title_ko'] as String,
      reference: json['reference'] as String,
      summaryEn: json['summary_en'] as String,
      summaryKo: json['summary_ko'] as String,
      lessonEn: json['lesson_en'] as String,
      lessonKo: json['lesson_ko'] as String,
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  String title(String locale) => locale == 'ko' ? titleKo : titleEn;
  String summary(String locale) => locale == 'ko' ? summaryKo : summaryEn;
  String lesson(String locale) => locale == 'ko' ? lessonKo : lessonEn;

  /// Placeholder for locked premium card display
  factory HistoricalStory.placeholder() => const HistoricalStory(
        titleEn: 'A Story of Faith',
        titleKo: '믿음의 이야기',
        reference: '',
        summaryEn: 'Unlock to discover a powerful story from Bible history...',
        summaryKo: '성경 역사 속 감동적인 이야기를 만나보세요...',
        lessonEn: '',
        lessonKo: '',
        isPremium: true,
      );
}

class PrayerResult {
  final Scripture scripture;
  final BibleStory bibleStory;
  final String testimonyEn;
  final String testimonyKo;

  String testimony(String locale) => locale == 'ko' ? testimonyKo : testimonyEn;
  final Guidance? guidance;
  final AiPrayer? aiPrayer;
  final OriginalLanguage? originalLanguage;
  final PrayerSummary? prayerSummary;
  final HistoricalStory? historicalStory;

  const PrayerResult({
    required this.scripture,
    required this.bibleStory,
    required this.testimonyEn,
    required this.testimonyKo,
    this.guidance,
    this.aiPrayer,
    this.originalLanguage,
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
      testimonyEn: testimonyEn,
      testimonyKo: testimonyKo,
      prayerSummary: prayerSummary,
      originalLanguage: originalLanguage,
      historicalStory: historicalStory ?? this.historicalStory,
      aiPrayer: aiPrayer ?? this.aiPrayer,
      guidance: guidance ?? this.guidance,
    );
  }

  factory PrayerResult.fromJson(Map<String, dynamic> json) {
    return PrayerResult(
      scripture: Scripture.fromJson(json['scripture'] as Map<String, dynamic>),
      bibleStory: BibleStory.fromJson(
        json['bible_story'] as Map<String, dynamic>,
      ),
      testimonyEn: json['testimony']?['transcript_en'] as String? ?? '',
      testimonyKo: json['testimony']?['transcript_ko'] as String? ?? '',
      guidance: json['guidance'] != null
          ? Guidance.fromJson(json['guidance'] as Map<String, dynamic>)
          : null,
      aiPrayer: json['ai_prayer'] != null
          ? AiPrayer.fromJson(json['ai_prayer'] as Map<String, dynamic>)
          : null,
      originalLanguage: json['original_language'] != null
          ? OriginalLanguage.fromJson(
              json['original_language'] as Map<String, dynamic>,
            )
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
  final String verseEn;
  final String verseKo;
  final String reference;
  final String reasonEn;
  final String reasonKo;

  const Scripture({
    required this.verseEn,
    required this.verseKo,
    required this.reference,
    this.reasonEn = '',
    this.reasonKo = '',
  });

  factory Scripture.fromJson(Map<String, dynamic> json) {
    return Scripture(
      verseEn: json['verse_en'] as String? ?? json['verse'] as String? ?? '',
      verseKo: json['verse_ko'] as String? ?? json['verse'] as String? ?? '',
      reference: json['reference'] as String,
      reasonEn: json['reason_en'] as String? ?? json['reason'] as String? ?? '',
      reasonKo: json['reason_ko'] as String? ?? json['reason'] as String? ?? '',
    );
  }

  String verse(String locale) => locale == 'ko' ? verseKo : verseEn;
  String reason(String locale) => locale == 'ko' ? reasonKo : reasonEn;
}

class BibleStory {
  final String titleEn;
  final String titleKo;
  final String summaryEn;
  final String summaryKo;

  const BibleStory({
    required this.titleEn,
    required this.titleKo,
    required this.summaryEn,
    required this.summaryKo,
  });

  factory BibleStory.fromJson(Map<String, dynamic> json) {
    return BibleStory(
      titleEn: json['title_en'] as String,
      titleKo: json['title_ko'] as String,
      summaryEn: json['summary_en'] as String,
      summaryKo: json['summary_ko'] as String,
    );
  }

  String title(String locale) => locale == 'ko' ? titleKo : titleEn;
  String summary(String locale) => locale == 'ko' ? summaryKo : summaryEn;
}

class Guidance {
  final String contentEn;
  final String contentKo;
  final bool isPremium;

  const Guidance({
    required this.contentEn,
    required this.contentKo,
    required this.isPremium,
  });

  factory Guidance.fromJson(Map<String, dynamic> json) {
    return Guidance(
      contentEn: json['content_en'] as String,
      contentKo: json['content_ko'] as String,
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  String content(String locale) => locale == 'ko' ? contentKo : contentEn;
}

class AiPrayer {
  final String textEn;
  final String textKo;
  final String? audioUrl;
  final bool isPremium;

  const AiPrayer({
    required this.textEn,
    required this.textKo,
    this.audioUrl,
    required this.isPremium,
  });

  factory AiPrayer.fromJson(Map<String, dynamic> json) {
    return AiPrayer(
      textEn: json['text_en'] as String,
      textKo: json['text_ko'] as String,
      audioUrl: json['audio_url'] as String?,
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  String text(String locale) => locale == 'ko' ? textKo : textEn;

  /// Placeholder for locked premium card display
  factory AiPrayer.placeholder() => const AiPrayer(
        textEn: 'Unlock to receive a personalized prayer...',
        textKo: '당신만을 위한 기도문을 받아보세요...',
        isPremium: true,
      );
}

class OriginalLanguage {
  final String word;
  final String transliteration;
  final String language;
  final String meaningEn;
  final String meaningKo;
  final String contextEn;
  final String contextKo;
  final bool isPremium;

  const OriginalLanguage({
    required this.word,
    required this.transliteration,
    required this.language,
    required this.meaningEn,
    required this.meaningKo,
    required this.contextEn,
    required this.contextKo,
    required this.isPremium,
  });

  factory OriginalLanguage.fromJson(Map<String, dynamic> json) {
    return OriginalLanguage(
      word: json['word'] as String,
      transliteration: json['transliteration'] as String,
      language: json['language'] as String,
      meaningEn: json['meaning_en'] as String,
      meaningKo: json['meaning_ko'] as String,
      contextEn: json['context_en'] as String,
      contextKo: json['context_ko'] as String,
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  String meaning(String locale) => locale == 'ko' ? meaningKo : meaningEn;
  String context(String locale) => locale == 'ko' ? contextKo : contextEn;
}
