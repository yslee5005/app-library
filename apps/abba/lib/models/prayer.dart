class Prayer {
  final String id;
  final String userId;
  final String transcript;
  final String mode; // 'prayer' | 'qt'
  final String? qtPassageRef;
  final DateTime createdAt;
  final PrayerResult? result;

  const Prayer({
    required this.id,
    required this.userId,
    required this.transcript,
    required this.mode,
    this.qtPassageRef,
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
      createdAt: DateTime.parse(json['created_at'] as String),
      result: json['result'] != null
          ? PrayerResult.fromJson(json['result'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PrayerResult {
  final Scripture scripture;
  final BibleStory bibleStory;
  final String testimony;
  final Guidance? guidance;
  final AiPrayer? aiPrayer;
  final OriginalLanguage? originalLanguage;

  const PrayerResult({
    required this.scripture,
    required this.bibleStory,
    required this.testimony,
    this.guidance,
    this.aiPrayer,
    this.originalLanguage,
  });

  factory PrayerResult.fromJson(Map<String, dynamic> json) {
    return PrayerResult(
      scripture: Scripture.fromJson(json['scripture'] as Map<String, dynamic>),
      bibleStory:
          BibleStory.fromJson(json['bible_story'] as Map<String, dynamic>),
      testimony: json['testimony']?['transcript_en'] as String? ?? '',
      guidance: json['guidance'] != null
          ? Guidance.fromJson(json['guidance'] as Map<String, dynamic>)
          : null,
      aiPrayer: json['ai_prayer'] != null
          ? AiPrayer.fromJson(json['ai_prayer'] as Map<String, dynamic>)
          : null,
      originalLanguage: json['original_language'] != null
          ? OriginalLanguage.fromJson(
              json['original_language'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Scripture {
  final String verseEn;
  final String verseKo;
  final String reference;

  const Scripture({
    required this.verseEn,
    required this.verseKo,
    required this.reference,
  });

  factory Scripture.fromJson(Map<String, dynamic> json) {
    return Scripture(
      verseEn: json['verse_en'] as String,
      verseKo: json['verse_ko'] as String,
      reference: json['reference'] as String,
    );
  }

  String verse(String locale) => locale == 'ko' ? verseKo : verseEn;
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
