class QtMeditationResult {
  final MeditationAnalysis analysis;
  final ApplicationSuggestion application;
  final RelatedKnowledge knowledge;
  final GrowthStory? growthStory;

  const QtMeditationResult({
    required this.analysis,
    required this.application,
    required this.knowledge,
    this.growthStory,
  });

  factory QtMeditationResult.fromJson(Map<String, dynamic> json) {
    return QtMeditationResult(
      analysis: MeditationAnalysis.fromJson(
        json['analysis'] as Map<String, dynamic>,
      ),
      application: ApplicationSuggestion.fromJson(
        json['application'] as Map<String, dynamic>,
      ),
      knowledge: RelatedKnowledge.fromJson(
        json['knowledge'] as Map<String, dynamic>,
      ),
      growthStory: json['growth_story'] != null
          ? GrowthStory.fromJson(
              json['growth_story'] as Map<String, dynamic>,
            )
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
    return MeditationAnalysis(
      keyThemeEn: json['key_theme_en'] as String,
      keyThemeKo: json['key_theme_ko'] as String,
      insightEn: json['insight_en'] as String,
      insightKo: json['insight_ko'] as String,
    );
  }

  String keyTheme(String locale) => locale == 'ko' ? keyThemeKo : keyThemeEn;
  String insight(String locale) => locale == 'ko' ? insightKo : insightEn;
}

class ApplicationSuggestion {
  final String actionEn;
  final String actionKo;
  final String whenEn;
  final String whenKo;
  final String contextEn;
  final String contextKo;

  const ApplicationSuggestion({
    required this.actionEn,
    required this.actionKo,
    required this.whenEn,
    required this.whenKo,
    required this.contextEn,
    required this.contextKo,
  });

  factory ApplicationSuggestion.fromJson(Map<String, dynamic> json) {
    return ApplicationSuggestion(
      actionEn: json['action_en'] as String,
      actionKo: json['action_ko'] as String,
      whenEn: json['when_en'] as String,
      whenKo: json['when_ko'] as String,
      contextEn: json['context_en'] as String,
      contextKo: json['context_ko'] as String,
    );
  }

  String action(String locale) => locale == 'ko' ? actionKo : actionEn;
  String when(String locale) => locale == 'ko' ? whenKo : whenEn;
  String context(String locale) => locale == 'ko' ? contextKo : contextEn;
}

class RelatedKnowledge {
  final OriginalWord? originalWord;
  final String historicalContextEn;
  final String historicalContextKo;
  final List<String> crossReferences;

  const RelatedKnowledge({
    this.originalWord,
    required this.historicalContextEn,
    required this.historicalContextKo,
    required this.crossReferences,
  });

  factory RelatedKnowledge.fromJson(Map<String, dynamic> json) {
    return RelatedKnowledge(
      originalWord: json['original_word'] != null
          ? OriginalWord.fromJson(
              json['original_word'] as Map<String, dynamic>,
            )
          : null,
      historicalContextEn: json['historical_context_en'] as String,
      historicalContextKo: json['historical_context_ko'] as String,
      crossReferences: (json['cross_references'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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

class GrowthStory {
  final String titleEn;
  final String titleKo;
  final String summaryEn;
  final String summaryKo;
  final String lessonEn;
  final String lessonKo;
  final bool isPremium;

  const GrowthStory({
    required this.titleEn,
    required this.titleKo,
    required this.summaryEn,
    required this.summaryKo,
    required this.lessonEn,
    required this.lessonKo,
    required this.isPremium,
  });

  factory GrowthStory.fromJson(Map<String, dynamic> json) {
    return GrowthStory(
      titleEn: json['title_en'] as String,
      titleKo: json['title_ko'] as String,
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
}
