import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:app_lib_logging/logging.dart';

import '../../config/app_config.dart';
import '../../models/prayer.dart';
import '../../models/qt_meditation_result.dart';
import '../ai_service.dart';

class GeminiService implements AiService {
  GenerativeModel _createModel({
    required String systemPrompt,
    double temperature = 0.9,
  }) {
    return GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: AppConfig.geminiApiKey,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: temperature,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Prayer analysis (text)
  // ---------------------------------------------------------------------------

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    final langName = _localeName(locale);
    apiLog.info('Gemini full prayer analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildSystemPrompt(langName) + _diversityHint(),
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      return _parsePrayerJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini prayer analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    final langName = _localeName(locale);
    apiLog.info('Gemini core prayer analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildCoreSystemPrompt(langName) + _diversityHint(),
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      return _parsePrayerJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini core analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  // ---------------------------------------------------------------------------
  // Prayer analysis from audio (Gemini processes audio directly)
  // ---------------------------------------------------------------------------

  @override
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  }) async {
    final langName = _localeName(locale);
    apiLog.info('Gemini audio prayer analysis started');

    try {
      final audioBytes = await File(audioFilePath).readAsBytes();
      final model = _createModel(
        systemPrompt: _buildAudioCoreSystemPrompt(langName) + _diversityHint(),
      );

      final response = await model.generateContent([
        Content('user', [
          DataPart('audio/mp4', audioBytes),
          TextPart('This is a prayer audio recording. Transcribe and analyze it.'),
        ]),
      ]);

      final json = _parseJsonFromResponse(response.text);
      final transcription = json['transcription'] as String? ?? '';
      final result = PrayerResult.fromJson(json);
      return (result: result, transcription: transcription);
    } catch (e, stackTrace) {
      apiLog.error('Gemini audio analysis failed', error: e, stackTrace: stackTrace);
      return (result: _fallbackPrayerResult(), transcription: '');
    }
  }

  // ---------------------------------------------------------------------------
  // Premium analysis (text only — transcript already available)
  // ---------------------------------------------------------------------------

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    final langName = _localeName(locale);
    apiLog.info('Gemini premium analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildPremiumSystemPrompt(langName) + _diversityHint(),
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      return _parsePremiumJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini premium analysis failed', error: e, stackTrace: stackTrace);
      return const PremiumContent();
    }
  }

  // ---------------------------------------------------------------------------
  // QT Meditation analysis
  // ---------------------------------------------------------------------------

  @override
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  }) async {
    final langName = _localeName(locale);
    apiLog.info('Gemini meditation analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildMeditationPrompt(langName) + _diversityHint(),
      );
      final userMessage =
          'Passage: $passageReference\n\n$passageText\n\nMy meditation:\n$meditationText';
      final response = await model.generateContent([
        Content('user', [TextPart(userMessage)]),
      ]);
      return _parseMeditationJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini meditation analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackMeditationResult();
    }
  }

  // ---------------------------------------------------------------------------
  // JSON parsing
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _parseJsonFromResponse(String? text) {
    if (text == null || text.isEmpty) throw FormatException('Empty response');
    return jsonDecode(text) as Map<String, dynamic>;
  }

  PrayerResult _parsePrayerJson(String? text) {
    try {
      final data = _parseJsonFromResponse(text);
      return PrayerResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error('Prayer JSON parse failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  PremiumContent _parsePremiumJson(String? text) {
    try {
      final data = _parseJsonFromResponse(text);
      return PremiumContent(
        historicalStory: data['historical_story'] != null
            ? HistoricalStory.fromJson(data['historical_story'] as Map<String, dynamic>)
            : null,
        aiPrayer: data['ai_prayer'] != null
            ? AiPrayer.fromJson(data['ai_prayer'] as Map<String, dynamic>)
            : null,
        guidance: data['guidance'] != null
            ? Guidance.fromJson(data['guidance'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, stackTrace) {
      apiLog.error('Premium JSON parse failed', error: e, stackTrace: stackTrace);
      return const PremiumContent();
    }
  }

  QtMeditationResult _parseMeditationJson(String? text) {
    try {
      final data = _parseJsonFromResponse(text);
      return QtMeditationResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error('Meditation JSON parse failed', error: e, stackTrace: stackTrace);
      return _fallbackMeditationResult();
    }
  }

  // ---------------------------------------------------------------------------
  // Fallbacks
  // ---------------------------------------------------------------------------

  PrayerResult _fallbackPrayerResult() {
    return PrayerResult(
      scripture: const Scripture(
        verseEn: 'The LORD is my shepherd; I shall not want.',
        verseKo: '여호와는 나의 목자시니 내게 부족함이 없으리로다',
        reference: 'Psalm 23:1',
      ),
      bibleStory: const BibleStory(
        titleEn: 'God is faithful',
        titleKo: '하나님은 신실하십니다',
        summaryEn: 'Even when we cannot see the way, God is faithfully guiding our steps.',
        summaryKo: '우리가 길을 볼 수 없을 때에도, 하나님은 신실하게 우리의 발걸음을 인도하십니다.',
      ),
      testimonyEn: '',
      testimonyKo: '',
    );
  }

  QtMeditationResult _fallbackMeditationResult() {
    return const QtMeditationResult(
      analysis: MeditationAnalysis(
        keyThemeEn: 'God\'s Faithfulness',
        keyThemeKo: '하나님의 신실하심',
        insightEn: 'Your meditation reveals a heart seeking God\'s guidance and peace.',
        insightKo: '당신의 묵상에서 하나님의 인도와 평안을 구하는 마음이 느껴집니다.',
      ),
      application: ApplicationSuggestion(
        action: '오늘 잠시 조용히 묵상하는 시간을 가져보세요',
      ),
      knowledge: RelatedKnowledge(
        historicalContextEn: 'The biblical concept of meditation involves deep reflection on God\'s Word.',
        historicalContextKo: '성경에서의 묵상은 하나님의 말씀에 대한 깊은 성찰을 의미합니다.',
        crossReferences: [
          CrossReference(reference: 'Psalm 1:2', text: ''),
          CrossReference(reference: 'Joshua 1:8', text: ''),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Diversity hint
  // ---------------------------------------------------------------------------

  String _diversityHint() {
    const hints = [
      'TODAY: Focus on a lesser-known character from the Old Testament.',
      'TODAY: Find a connection to one of Jesus\' parables.',
      'TODAY: Choose a verse from the Prophets (Isaiah-Malachi).',
      'TODAY: Select a verse from Wisdom Literature (Job, Proverbs, Ecclesiastes, Song of Solomon).',
      'TODAY: Feature a woman of faith from the Bible.',
      'TODAY: Connect to a story from the book of Acts.',
      'TODAY: Find a Psalm that is NOT commonly cited (avoid Psalm 23, 91, 121).',
      'TODAY: Use a story from the period of the Judges.',
      'TODAY: Choose a verse from one of Paul\'s lesser-read epistles (Philemon, Titus, 2 Timothy).',
      'TODAY: Feature a story about answered prayer from the Bible.',
      'TODAY: Explore a verse about God\'s faithfulness from the minor prophets.',
      'TODAY: Connect to a story about transformation and new beginnings.',
      'TODAY: Use a verse from Genesis or Exodus that is not commonly quoted.',
      'TODAY: Feature a church history figure (not biblical) in the historical story.',
      'TODAY: Choose a verse from Hebrews, James, or 1 Peter.',
    ];
    final index = (DateTime.now().millisecondsSinceEpoch ~/ 1000 + Random().nextInt(hints.length)) % hints.length;
    return '\n\n${hints[index]}';
  }

  // ---------------------------------------------------------------------------
  // Locale name mapping
  // ---------------------------------------------------------------------------

  static String _localeName(String locale) {
    return switch (locale) {
      'ko' => 'Korean',
      'ja' => 'Japanese',
      'es' => 'Spanish',
      'zh' => 'Chinese (Simplified)',
      'pt' => 'Portuguese',
      'fr' => 'French',
      'hi' => 'Hindi',
      'fil' => 'Filipino',
      'sw' => 'Swahili',
      'de' => 'German',
      'it' => 'Italian',
      'pl' => 'Polish',
      'ru' => 'Russian',
      'id' => 'Indonesian',
      'uk' => 'Ukrainian',
      'ro' => 'Romanian',
      'nl' => 'Dutch',
      'hu' => 'Hungarian',
      'cs' => 'Czech',
      'vi' => 'Vietnamese',
      'th' => 'Thai',
      'tr' => 'Turkish',
      'ar' => 'Arabic',
      'he' => 'Hebrew',
      'el' => 'Greek',
      'sv' => 'Swedish',
      'no' => 'Norwegian',
      'da' => 'Danish',
      'fi' => 'Finnish',
      'hr' => 'Croatian',
      'sk' => 'Slovak',
      'ms' => 'Malay',
      'am' => 'Amharic',
      'my' => 'Burmese',
      _ => 'English',
    };
  }

  // ---------------------------------------------------------------------------
  // System prompts (preserved from OpenAI service)
  // ---------------------------------------------------------------------------

  String _buildSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Analyze their prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. The user's prayer transcript is their raw spoken words — summarize and organize it in $langName.

Return a JSON object:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "verse_en": "Bible verse in English",
    "verse_ko": "same verse in Korean",
    "reference": "Book Chapter:Verse",
    "reason_en": "Why this verse was chosen (2-3 sentences in English)",
    "reason_ko": "이 말씀을 선택한 이유 (2-3문장, 한국어)"
  },
  "bible_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "summary_en": "3-4 sentence summary in English",
    "summary_ko": "3-4 sentence summary in Korean"
  },
  "testimony": {
    "transcript_en": "the prayer reorganized in English as a testimony",
    "transcript_ko": "기도 내용을 한국어 간증문으로 재구성"
  },
  "historical_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "reference": "source (Bible chapter:verse or historical source)",
    "summary_en": "A story with narrative arc (7-10+ sentences in English)",
    "summary_ko": "기승전결 구조의 이야기 (7-10문장 이상, 한국어)",
    "lesson_en": "Specific lesson for this person (2-3 sentences in English)",
    "lesson_ko": "이 이야기에서 오늘 기도하신 분에게 전하는 구체적 교훈 (2-3문장)",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "A deeply moving prayer (5-8 sentences in English)",
    "text_ko": "감동적인 기도문 (5-8문장, 한국어)",
    "is_premium": true
  }
}

WRITING STYLE (critical for quality):
- Write like a master short story author, NOT a report writer.
- Use SENSORY details: what they saw, heard, felt, smelled.
- Include INNER MONOLOGUE: what the person thought and felt inside.
- VARY sentence structure: mix short punchy sentences with flowing long ones.
- Use METAPHORS and SIMILES: at least 2 per story.
- Show, don't tell: describe SCENES, not summaries.
- The ai_prayer should read like poetry — rhythmic, building in intensity.

IMPORTANT:
- The historical_story must be a REAL story from the Bible or verified church history.
- Do NOT make up stories.
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.

DIVERSITY:
- NEVER default to "popular" verses unless they are genuinely the BEST fit.
- Choose from the FULL canon of 66 books. Rotate between Old Testament and New Testament.
- Prefer lesser-cited books.''';
  }

  String _buildCoreSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Analyze their prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. The user's prayer transcript is their raw spoken words — summarize and organize it in $langName.

Return a JSON object with ONLY these core sections:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "verse_en": "Bible verse in English",
    "verse_ko": "same verse in Korean",
    "reference": "Book Chapter:Verse",
    "reason_en": "Why this verse was chosen (2-3 sentences in English)",
    "reason_ko": "이 말씀을 선택한 이유 (2-3문장, 한국어)"
  },
  "bible_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "summary_en": "3-4 sentence summary in English",
    "summary_ko": "3-4 sentence summary in Korean"
  },
  "testimony": {
    "transcript_en": "the prayer reorganized in English as a testimony",
    "transcript_ko": "기도 내용을 한국어 간증문으로 재구성"
  }
}

IMPORTANT:
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.
- The scripture must be a REAL Bible verse. Do NOT make up verses.''';
  }

  String _buildAudioCoreSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has submitted an audio recording of their prayer.

STEP 1: Accurately transcribe the audio in the language spoken.
STEP 2: Analyze the prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. All analysis fields must be in $langName.
2. The "transcription" field must contain the EXACT words spoken in the audio.

Return a JSON object:

{
  "transcription": "The exact transcription of the prayer audio in the original language spoken",
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "verse_en": "Bible verse in English",
    "verse_ko": "same verse in Korean",
    "reference": "Book Chapter:Verse",
    "reason_en": "Why this verse was chosen (2-3 sentences in English)",
    "reason_ko": "이 말씀을 선택한 이유 (2-3문장, 한국어)"
  },
  "bible_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "summary_en": "3-4 sentence summary in English",
    "summary_ko": "3-4 sentence summary in Korean"
  },
  "testimony": {
    "transcript_en": "the prayer reorganized in English as a testimony",
    "transcript_ko": "기도 내용을 한국어 간증문으로 재구성"
  }
}

IMPORTANT:
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.
- The scripture must be a REAL Bible verse. Do NOT make up verses.''';
  }

  String _buildPremiumSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Generate premium content based on their prayer.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.

Return a JSON object with ONLY these premium sections:

{
  "historical_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "reference": "source (Bible chapter:verse or historical source)",
    "summary_en": "A story with narrative arc (7-10+ sentences in English)",
    "summary_ko": "기승전결 구조의 이야기 (7-10문장 이상, 한국어)",
    "lesson_en": "Specific lesson for this person (2-3 sentences in English)",
    "lesson_ko": "이 이야기에서 오늘 기도하신 분에게 전하는 구체적 교훈 (2-3문장)",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "A deeply moving prayer (5-8 sentences in English)",
    "text_ko": "감동적인 기도문 (5-8문장, 한국어)",
    "is_premium": true
  }
}

WRITING STYLE:
- Write like a master short story author, NOT a report writer.
- Use SENSORY details, INNER MONOLOGUE, METAPHORS and SIMILES.
- VARY sentence structure. Show, don't tell.
- The ai_prayer should read like poetry.

IMPORTANT:
- The historical_story must be a REAL story from the Bible or verified church history.
- Do NOT make up stories.''';
  }

  String _buildMeditationPrompt(String langName) {
    return '''You are the world's most insightful Bible study guide and spiritual mentor.
The user has meditated on a Bible passage and shared their reflection.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.

Return a JSON object:

{
  "analysis": {
    "key_theme_en": "key theme in English (2-3 words)",
    "key_theme_ko": "핵심 테마 (2-3단어, 한국어)",
    "insight_en": "Deep analysis of the user's meditation (3-4 sentences in English).",
    "insight_ko": "사용자의 묵상을 깊이 분석한 인사이트 (3-4문장)."
  },
  "application": {
    "action": "A very specific actionable application in $langName. Must include who/what/how."
  },
  "knowledge": {
    "original_word": {
      "word": "Hebrew or Greek word from the passage",
      "transliteration": "romanized pronunciation",
      "language": "Hebrew or Greek",
      "meaning_en": "Deep meaning (2-3 sentences in English).",
      "meaning_ko": "원어의 깊은 뜻 (2-3문장)."
    },
    "historical_context_en": "Historical/cultural background (3-4 sentences in English).",
    "historical_context_ko": "역사적/문화적 배경 (3-4문장).",
    "cross_references": [
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"},
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"}
    ]
  },
  "growth_story": {
    "title_en": "Growth story title in English",
    "title_ko": "영적 성장 스토리 제목 (한국어)",
    "summary_en": "A story with narrative arc (8-12 sentences in English).",
    "summary_ko": "기승전결 구조의 감동적인 실화 (8-12문장).",
    "lesson_en": "How this story connects to today's meditation (2-3 sentences)",
    "lesson_ko": "이 이야기가 오늘 묵상과 어떻게 연결되는지 (2-3문장)",
    "is_premium": true
  }
}

WRITING STYLE:
- Write like a master short story author, NOT a report writer.
- Use SENSORY details, INNER MONOLOGUE, METAPHORS and SIMILES.
- VARY sentence structure. Show, don't tell.

IMPORTANT:
- cross_references: Include 2-3 verses with both "reference" and full "text" in $langName.
- application.action: Must be SPECIFIC and ACTIONABLE with who/what/how.
- growth_story: Must be a REAL story from Bible or verified church history. Minimum 8 sentences.''';
  }
}
