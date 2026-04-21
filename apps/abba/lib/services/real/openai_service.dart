import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../../models/prayer.dart';
import '../../models/qt_meditation_result.dart';
import '../ai_service.dart';
import 'package:app_lib_logging/logging.dart';

class OpenAiService implements AiService {
  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    final langName = _localeName(locale);

    apiLog.info('AI API call started');

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'response_format': {'type': 'json_object'},
          'messages': [
            {'role': 'system', 'content': _buildSystemPrompt(langName) + _diversityHint()},
            {'role': 'user', 'content': transcript},
          ],
          'temperature': 0.9,
          'top_p': 0.95,
          'frequency_penalty': 0.3,
          'presence_penalty': 0.6,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode != 200) {
        apiLog.info('AI API first attempt failed: ${response.statusCode}');

        // Retry once
        final retry = await http.post(
          Uri.parse(_baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
          },
          body: jsonEncode({
            'model': 'gpt-4o-mini',
            'response_format': {'type': 'json_object'},
            'messages': [
              {'role': 'system', 'content': _buildSystemPrompt(langName)},
              {'role': 'user', 'content': transcript},
            ],
            'temperature': 0.7,
            'max_tokens': 2000,
          }),
        );

        if (retry.statusCode != 200) {
          apiLog.info('AI API retry also failed: ${retry.statusCode}');
          return _fallbackPrayerResult();
        }
        return _parsePrayerResponse(retry.body);
      }

      apiLog.info('AI API call succeeded');
      return _parsePrayerResponse(response.body);
    } catch (e, stackTrace) {
      apiLog.error('Prayer analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  @override
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  }) async {
    final langName = _localeName(locale);

    apiLog.info('QT meditation AI call started');

    try {
      final userMessage =
          'Passage: $passageReference\n\n$passageText\n\nMy meditation:\n$meditationText';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'response_format': {'type': 'json_object'},
          'messages': [
            {
              'role': 'system',
              'content': _buildMeditationPrompt(langName) + _diversityHint(),
            },
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.9,
          'top_p': 0.95,
          'frequency_penalty': 0.3,
          'presence_penalty': 0.6,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode != 200) {
        // Retry once
        final retry = await http.post(
          Uri.parse(_baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
          },
          body: jsonEncode({
            'model': 'gpt-4o-mini',
            'response_format': {'type': 'json_object'},
            'messages': [
              {
                'role': 'system',
                'content': _buildMeditationPrompt(langName),
              },
              {'role': 'user', 'content': userMessage},
            ],
            'temperature': 0.7,
            'max_tokens': 2000,
          }),
        );

        if (retry.statusCode != 200) {
          return _fallbackMeditationResult();
        }
        return _parseMeditationResponse(retry.body);
      }

      return _parseMeditationResponse(response.body);
    } catch (e, stackTrace) {
      apiLog.error('Meditation analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackMeditationResult();
    }
  }

  PrayerResult _parsePrayerResponse(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final content = json['choices'][0]['message']['content'] as String;
      final data = jsonDecode(content) as Map<String, dynamic>;
      return PrayerResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error('Prayer response parsing failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  QtMeditationResult _parseMeditationResponse(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final content = json['choices'][0]['message']['content'] as String;
      final data = jsonDecode(content) as Map<String, dynamic>;
      return QtMeditationResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error('Meditation response parsing failed', error: e, stackTrace: stackTrace);
      return _fallbackMeditationResult();
    }
  }

  @override
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  }) async {
    // OpenAI service doesn't support audio analysis — use GeminiService instead
    throw UnimplementedError('Use GeminiService for audio analysis');
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    final langName = _localeName(locale);

    apiLog.info('AI Core API call started');

    try {
      final response = await _callApi(
        systemPrompt: _buildCoreSystemPrompt(langName),
        userMessage: transcript,
        maxTokens: 1200,
      );
      return _parsePrayerResponse(response);
    } catch (e, stackTrace) {
      apiLog.error('Core prayer analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  @override
  Future<PrayerCoaching> analyzePrayerCoaching({
    required String transcript,
    required String locale,
  }) async {
    // OpenAI path is legacy; coaching relies on Gemini service. Return placeholder.
    apiLog.info('OpenAI analyzePrayerCoaching not implemented — placeholder');
    return PrayerCoaching.placeholder();
  }

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    final langName = _localeName(locale);

    apiLog.info('AI Premium API call started');

    try {
      final response = await _callApi(
        systemPrompt: _buildPremiumSystemPrompt(langName),
        userMessage: transcript,
        maxTokens: 1500,
      );
      return _parsePremiumResponse(response);
    } catch (e, stackTrace) {
      apiLog.error('Premium analysis failed', error: e, stackTrace: stackTrace);
      return const PremiumContent();
    }
  }

  /// Shared API call with retry logic
  Future<String> _callApi({
    required String systemPrompt,
    required String userMessage,
    int maxTokens = 2000,
  }) async {
    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'response_format': {'type': 'json_object'},
      'messages': [
        {'role': 'system', 'content': systemPrompt + _diversityHint()},
        {'role': 'user', 'content': userMessage},
      ],
      'temperature': 0.9,
      'top_p': 0.95,
      'frequency_penalty': 0.3,
      'presence_penalty': 0.6,
      'max_tokens': maxTokens,
    });
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
    };

    var response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      // Retry once
      response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: body,
      );
      if (response.statusCode != 200) {
        throw Exception('AI API failed: ${response.statusCode}');
      }
    }

    return response.body;
  }

  PremiumContent _parsePremiumResponse(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final content = json['choices'][0]['message']['content'] as String;
      final data = jsonDecode(content) as Map<String, dynamic>;

      return PremiumContent(
        historicalStory: data['historical_story'] != null
            ? HistoricalStory.fromJson(
                data['historical_story'] as Map<String, dynamic>,
              )
            : null,
        aiPrayer: data['ai_prayer'] != null
            ? AiPrayer.fromJson(data['ai_prayer'] as Map<String, dynamic>)
            : null,
        guidance: data['guidance'] != null
            ? Guidance.fromJson(data['guidance'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, stackTrace) {
      apiLog.error('Premium response parsing failed', error: e, stackTrace: stackTrace);
      return const PremiumContent();
    }
  }

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
        summaryEn:
            'Even when we cannot see the way, God is faithfully guiding our steps.',
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
        insightEn:
            'Your meditation reveals a heart seeking God\'s guidance and peace.',
        insightKo: '당신의 묵상에서 하나님의 인도와 평안을 구하는 마음이 느껴집니다.',
      ),
      application: ApplicationSuggestion(
        action: '오늘 잠시 조용히 묵상하는 시간을 가져보세요',
      ),
      knowledge: RelatedKnowledge(
        historicalContextEn:
            'The biblical concept of meditation involves deep reflection on God\'s Word.',
        historicalContextKo: '성경에서의 묵상은 하나님의 말씀에 대한 깊은 성찰을 의미합니다.',
        crossReferences: [
          CrossReference(reference: 'Psalm 1:2', text: ''),
          CrossReference(reference: 'Joshua 1:8', text: ''),
        ],
      ),
    );
  }

  /// Adds a random creative direction hint per request for variety.
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
    return '\n\n${ hints[index]}';
  }

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
    "summary_en": "A story with narrative arc (7-10+ sentences in English): [Beginning] Setting — who, where, what situation. [Rising] Crisis — what hardship, trial, or desperation they faced. Vivid and dramatic. [Turning] Encounter with God — prayer answered, faith decision, divine intervention. [Resolution] Outcome and transformation — what changed, what we learn.",
    "summary_ko": "기승전결 구조의 이야기 (7-10문장 이상, 한국어): [기] 배경 설정 — 인물이 어떤 상황에 있었는지 생생하게 묘사. [승] 갈등/위기 — 어떤 어려움, 고난, 시험에 직면했는지. 처절하고 극적으로. [전] 전환점 — 하나님과의 만남, 믿음의 결단, 기도의 응답. [결] 결과와 교훈 — 어떻게 변화되었는지.",
    "lesson_en": "Specific lesson for this person (2-3 sentences in English)",
    "lesson_ko": "이 이야기에서 오늘 기도하신 분에게 전하는 구체적 교훈 (2-3문장)",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "A deeply moving prayer (5-8 sentences in English): [Opening] Address God, confessing His attributes (love, faithfulness, omnipotence). [Gratitude] Specifically mention what the user is thankful for. [Petition] Connect user's requests to God's promises logically. [Trust] Surrender everything to God's will. [Closing] In Jesus Christ's name, Amen.",
    "text_ko": "감동적인 기도문 (5-8문장, 한국어): [시작] 하나님을 부르며, 그분의 속성을 고백. [감사] 사용자의 감사 항목을 구체적으로 언급. [간구] 사용자의 기도를 하나님의 약속과 연결. [위탁] 모든 것을 하나님의 뜻에 맡기는 신뢰. [마무리] 예수 그리스도의 이름으로, 아멘.",
    "is_premium": true
  }
}

WRITING STYLE (critical for quality):
- Write like a master short story author, NOT a report writer.
- Use SENSORY details: what they saw, heard, felt, smelled (e.g. "the cold stone floor pressed against her knees" not "she knelt down")
- Include INNER MONOLOGUE: what the person thought and felt inside (e.g. "Her heart whispered: Had God forgotten her?" not "She was sad")
- VARY sentence structure: mix short punchy sentences with flowing long ones. NEVER repeat the same pattern (X했습니다. Y했습니다. Z했습니다.)
- Use METAPHORS and SIMILES: at least 2 per story (e.g. "her prayers rose like incense through cracked ceilings")
- Show, don't tell: describe SCENES, not summaries
- The ai_prayer should read like poetry — rhythmic, building in intensity, with unexpected beautiful phrases that pierce the heart

IMPORTANT:
- The historical_story must be a REAL story from the Bible or verified church history.
- Do NOT make up stories. Use real biblical figures (Abraham, Moses, David, Elijah, Hannah, Paul, etc.) or real church history figures (Corrie ten Boom, George Müller, Hudson Taylor, etc.).
- The ai_prayer must flow logically from gratitude → petition → trust → surrender.
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.

DIVERSITY (equally important as accuracy):
- NEVER default to "popular" verses (Psalm 23, Jeremiah 29:11, Philippians 4:13, Romans 8:28) unless they are genuinely the BEST fit. Prefer surprising, lesser-known connections.
- Choose from the FULL canon of 66 books. Rotate between Old Testament and New Testament.
- Prefer lesser-cited books: Habakkuk, Zephaniah, Micah, Nahum, Philemon, 2 John, 3 John, Jude, Song of Solomon, Ecclesiastes, Ruth, Esther, Nehemiah, Obadiah, Haggai, Malachi.
- For bible_story: rotate through DIFFERENT biblical eras — Patriarchs, Exodus, Judges, United Kingdom, Divided Kingdom, Exile/Return, Prophets, Gospels, Early Church.
- For historical_story: alternate between biblical figures (70%) and church history figures (30%): Corrie ten Boom, George Müller, Hudson Taylor, Dietrich Bonhoeffer, Brother Lawrence, Amy Carmichael, Watchman Nee, Gladys Aylward, Fanny Crosby, Richard Wurmbrand.
- For original_language: explore DIFFERENT Hebrew/Greek words each time. The Bible has thousands of unique words.
- For ai_prayer: vary the opening style — sometimes praise, sometimes confession, sometimes intimate ("Abba, Father"), sometimes formal ("Almighty God").''';
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
    "summary_en": "A story with narrative arc (7-10+ sentences in English): [Beginning] Setting — who, where, what situation. [Rising] Crisis — what hardship, trial, or desperation they faced. Vivid and dramatic. [Turning] Encounter with God — prayer answered, faith decision, divine intervention. [Resolution] Outcome and transformation — what changed, what we learn.",
    "summary_ko": "기승전결 구조의 이야기 (7-10문장 이상, 한국어): [기] 배경 설정 — 인물이 어떤 상황에 있었는지 생생하게 묘사. [승] 갈등/위기 — 어떤 어려움, 고난, 시험에 직면했는지. 처절하고 극적으로. [전] 전환점 — 하나님과의 만남, 믿음의 결단, 기도의 응답. [결] 결과와 교훈 — 어떻게 변화되었는지.",
    "lesson_en": "Specific lesson for this person (2-3 sentences in English)",
    "lesson_ko": "이 이야기에서 오늘 기도하신 분에게 전하는 구체적 교훈 (2-3문장)",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "A deeply moving prayer (5-8 sentences in English): [Opening] Address God, confessing His attributes. [Gratitude] Specifically mention what the user is thankful for. [Petition] Connect user's requests to God's promises. [Trust] Surrender everything to God's will. [Closing] In Jesus Christ's name, Amen.",
    "text_ko": "감동적인 기도문 (5-8문장, 한국어): [시작] 하나님을 부르며, 그분의 속성을 고백. [감사] 사용자의 감사 항목을 구체적으로 언급. [간구] 사용자의 기도를 하나님의 약속과 연결. [위탁] 모든 것을 하나님의 뜻에 맡기는 신뢰. [마무리] 예수 그리스도의 이름으로, 아멘.",
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
- Do NOT make up stories. Use real biblical figures or real church history figures.
- The ai_prayer must flow logically from gratitude → petition → trust → surrender.''';
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
    "insight_en": "Deep analysis of the user's meditation (3-4 sentences in English). Acknowledge what they discovered, then add deeper meaning.",
    "insight_ko": "사용자의 묵상을 깊이 분석한 인사이트 (3-4문장). 사용자가 발견한 것을 인정하고, 더 깊은 의미를 추가."
  },
  "application": {
    "action": "A very specific actionable application in $langName. BAD: 'Be more grateful' (abstract). BAD: 'Trust God more' (vague). GOOD: 'At dinner tonight, tell your family 3 things you are thankful for this year'. GOOD: 'Tomorrow morning before work, read Psalm 23 aloud for 5 minutes'. GOOD: 'Today, buy coffee for a colleague you are in conflict with and greet them first'. Must include who/what/how."
  },
  "knowledge": {
    "original_word": {
      "word": "Hebrew or Greek word from the passage",
      "transliteration": "romanized pronunciation",
      "language": "Hebrew or Greek",
      "meaning_en": "Deep meaning (2-3 sentences in English). Not just dictionary meaning but cultural/theological background.",
      "meaning_ko": "원어의 깊은 뜻 (2-3문장). 단순 사전적 의미가 아닌, 문화적/신학적 배경까지."
    },
    "historical_context_en": "Historical/cultural background (3-4 sentences in English). What this text meant to its original audience.",
    "historical_context_ko": "역사적/문화적 배경 (3-4문장). 당시 독자들에게 이 말씀이 어떤 의미였는지.",
    "cross_references": [
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"},
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"}
    ]
  },
  "growth_story": {
    "title_en": "Growth story title in English",
    "title_ko": "영적 성장 스토리 제목 (한국어)",
    "summary_en": "A story with narrative arc (8-12 sentences in English): [Beginning] Ordinary life or background. Who is this person and what was their situation? [Rising] Crisis begins. A dramatic event testing faith — desperation, suffering. Vivid scene description. [Turning] Encounter with God's Word, answered prayer, or faith decision. How God worked — dramatic reversal. [Resolution] Transformation and fruit. How they changed. Connection to today's passage.",
    "summary_ko": "기승전결 구조의 감동적인 실화 (8-12문장): [기] 평범한 일상/배경. 이 사람은 누구이고 어떤 상황이었는지. [승] 위기 시작. 신앙을 시험하는 극적 사건, 고난, 절망. 구체적 장면 묘사. [전] 전환점. 말씀과의 만남, 기도의 응답, 믿음의 결단. 하나님의 역사 — 극적 반전. [결] 변화와 열매. 그 경험 이후 어떻게 달라졌는지. 오늘 묵상 말씀과의 연결.",
    "lesson_en": "How this story connects to today's meditation and specific lesson for the reader (2-3 sentences)",
    "lesson_ko": "이 이야기가 오늘 묵상과 어떻게 연결되는지, 독자에게 주는 구체적 교훈 (2-3문장)",
    "is_premium": true
  }
}

WRITING STYLE (critical for quality):
- Write like a master short story author, NOT a report writer.
- Use SENSORY details: what they saw, heard, felt (e.g. "rain hammered the tin roof as he prayed" not "it was raining")
- Include INNER MONOLOGUE: thoughts and doubts of the person (e.g. "Could God really see him in this forgotten corner of the world?")
- VARY sentence structure: mix short and long. NEVER use repetitive patterns.
- Use METAPHORS and SIMILES: at least 2 per story (e.g. "faith, thin as a spider's thread, held him over the abyss")
- Show, don't tell: describe SCENES with vivid detail
- The growth_story should make the reader feel they are INSIDE the story, living it

IMPORTANT:
- cross_references: Include 2-3 verses. Each must have both "reference" and full "text" in $langName.
- application.action: Must be SPECIFIC and ACTIONABLE. Include who/what/how.
- growth_story: Must be a REAL story from Bible or verified church history. Minimum 8 sentences.
- Do NOT use generic phrases. Every response must be personalized to THIS meditation.''';
  }
}
