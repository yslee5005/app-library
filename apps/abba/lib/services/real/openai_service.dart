import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../../models/prayer.dart';
import '../../models/qt_meditation_result.dart';
import '../ai_service.dart';
import '../error_logging_service.dart';

class OpenAiService implements AiService {
  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    final langName = _localeName(locale);

    ErrorLoggingService.addBreadcrumb('AI API call started', category: 'ai');

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
            {'role': 'system', 'content': _buildSystemPrompt(langName)},
            {'role': 'user', 'content': transcript},
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode != 200) {
        ErrorLoggingService.addBreadcrumb(
          'AI API first attempt failed: ${response.statusCode}',
          category: 'ai',
        );

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
          ErrorLoggingService.addBreadcrumb(
            'AI API retry also failed: ${retry.statusCode}',
            category: 'ai',
          );
          return _fallbackPrayerResult();
        }
        return _parsePrayerResponse(retry.body);
      }

      ErrorLoggingService.addBreadcrumb(
        'AI API call succeeded',
        category: 'ai',
      );
      return _parsePrayerResponse(response.body);
    } catch (e, stackTrace) {
      ErrorLoggingService.captureException(e, stackTrace);
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

    ErrorLoggingService.addBreadcrumb(
      'QT meditation AI call started',
      category: 'ai',
    );

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
              'content': _buildMeditationPrompt(langName),
            },
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
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
      ErrorLoggingService.captureException(e, stackTrace);
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
      ErrorLoggingService.captureException(e, stackTrace);
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
      ErrorLoggingService.captureException(e, stackTrace);
      return _fallbackMeditationResult();
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
      testimony: '',
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
        actionEn: 'Take a moment of quiet reflection today',
        actionKo: '오늘 잠시 조용히 묵상하는 시간을 가져보세요',
        whenEn: 'During a quiet moment',
        whenKo: '조용한 시간에',
        contextEn: 'Wherever you are',
        contextKo: '어디에서든',
      ),
      knowledge: RelatedKnowledge(
        historicalContextEn:
            'The biblical concept of meditation involves deep reflection on God\'s Word.',
        historicalContextKo: '성경에서의 묵상은 하나님의 말씀에 대한 깊은 성찰을 의미합니다.',
        crossReferences: ['Psalm 1:2', 'Joshua 1:8'],
      ),
    );
  }

  static String _localeName(String locale) {
    return switch (locale) {
      'ko' => 'Korean',
      'ja' => 'Japanese',
      'es' => 'Spanish',
      'zh' => 'Chinese (Simplified)',
      _ => 'English',
    };
  }

  String _buildSystemPrompt(String langName) {
    return '''You are a compassionate Christian AI counselor.
Analyze the user's prayer and respond in $langName language.
Return a JSON object with these exact fields:
{
  "prayer_summary": {
    "gratitude": ["gratitude item 1", "gratitude item 2"],
    "petition": ["petition item 1"],
    "intercession": ["intercession item 1"]
  },
  "scripture": {
    "verse_en": "relevant Bible verse in English",
    "verse_ko": "same verse in Korean",
    "reference": "Book Chapter:Verse"
  },
  "bible_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "summary_en": "3-4 sentence summary in English",
    "summary_ko": "3-4 sentence summary in Korean"
  },
  "testimony": {
    "transcript_en": "the prayer text in English",
    "transcript_ko": "the prayer text in Korean"
  },
  "historical_story": {
    "title_en": "Hannah's Prayer",
    "title_ko": "한나의 기도",
    "reference": "1 Samuel 1-2",
    "summary_en": "A real Bible or church history story related to the prayer's main theme...",
    "summary_ko": "기도의 주제와 관련된 실제 성경 또는 교회사 이야기...",
    "lesson_en": "A practical lesson from the story.",
    "lesson_ko": "이야기에서 얻는 실천적 교훈.",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "a prayer written for this person in English (5-6 sentences)",
    "text_ko": "a prayer written for this person in Korean (5-6 sentences)",
    "is_premium": true
  }
}
The historical_story should be a real Bible story or church history story that relates to the prayer's main theme. Include a practical lesson.
Be warm, encouraging, biblically accurate.
Never judge. Always point to God's love and grace.''';
  }

  String _buildMeditationPrompt(String langName) {
    return '''You are a wise Bible study guide.
The user has meditated on a Bible passage and shared their reflection.
Analyze their meditation and respond in $langName language.

Return a JSON object:
{
  "analysis": {
    "key_theme_en": "Rest and Peace",
    "key_theme_ko": "쉼과 평안",
    "insight_en": "Your meditation reveals a longing for rest...",
    "insight_ko": "당신의 묵상에서 쉼에 대한 갈망이 느껴집니다..."
  },
  "application": {
    "action_en": "Take 15 minutes of intentional rest today",
    "action_ko": "오늘 15분간 의도적으로 쉬는 시간을 가져보세요",
    "when_en": "During lunch break",
    "when_ko": "점심시간에",
    "context_en": "At your workplace",
    "context_ko": "직장에서"
  },
  "knowledge": {
    "original_word": {
      "word": "one key Hebrew or Greek word from the passage",
      "transliteration": "romanized pronunciation",
      "language": "Hebrew or Greek",
      "meaning_en": "meaning with cultural nuance in English",
      "meaning_ko": "문화적 뉘앙스를 포함한 의미 (한국어)"
    },
    "historical_context_en": "Historical/cultural background of the passage...",
    "historical_context_ko": "말씀의 역사적/문화적 배경...",
    "cross_references": ["Matthew 11:28", "Hebrews 4:9-11"]
  },
  "growth_story": {
    "title_en": "A real story from Bible or church history",
    "title_ko": "성경 또는 교회사에서 가져온 실제 이야기",
    "summary_en": "3-4 sentence summary...",
    "summary_ko": "3-4문장 요약...",
    "lesson_en": "A practical lesson.",
    "lesson_ko": "실천적 교훈.",
    "is_premium": true
  }
}

Make the application SPECIFIC and ACTIONABLE (not vague like "live better").
The growth_story should be a real story from Bible or church history.
Be warm, encouraging, biblically accurate.''';
  }
}
