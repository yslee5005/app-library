import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';
import '../../models/prayer.dart';
import '../ai_service.dart';
import '../error_logging_service.dart';

class OpenAiService implements AiService {
  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    final langName = locale == 'ko' ? 'Korean' : 'English';

    ErrorLoggingService.addBreadcrumb(
      'AI API call started',
      category: 'ai',
    );

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
            {
              'role': 'system',
              'content': _buildSystemPrompt(langName),
            },
            {
              'role': 'user',
              'content': transcript,
            },
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
              {
                'role': 'system',
                'content': _buildSystemPrompt(langName),
              },
              {
                'role': 'user',
                'content': transcript,
              },
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
          return _fallbackResult();
        }
        return _parseResponse(retry.body);
      }

      ErrorLoggingService.addBreadcrumb(
        'AI API call succeeded',
        category: 'ai',
      );
      return _parseResponse(response.body);
    } catch (e, stackTrace) {
      ErrorLoggingService.captureException(e, stackTrace);
      return _fallbackResult();
    }
  }

  PrayerResult _parseResponse(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final content =
          json['choices'][0]['message']['content'] as String;
      final data = jsonDecode(content) as Map<String, dynamic>;
      return PrayerResult.fromJson(data);
    } catch (e, stackTrace) {
      ErrorLoggingService.captureException(e, stackTrace);
      return _fallbackResult();
    }
  }

  PrayerResult _fallbackResult() {
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
      testimony: '',
    );
  }

  String _buildSystemPrompt(String langName) {
    return '''You are a compassionate Christian AI counselor.
Analyze the user's prayer and respond in $langName language.
Return a JSON object with these exact fields:
{
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
  "guidance": {
    "content_en": "personalized spiritual guidance in English (3-4 sentences)",
    "content_ko": "personalized spiritual guidance in Korean (3-4 sentences)",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "a prayer written for this person in English (5-6 sentences)",
    "text_ko": "a prayer written for this person in Korean (5-6 sentences)",
    "is_premium": true
  },
  "original_language": {
    "word": "one key Hebrew or Greek word from the scripture",
    "transliteration": "romanized pronunciation",
    "language": "Hebrew or Greek",
    "meaning_en": "meaning and implications in English",
    "meaning_ko": "meaning and implications in Korean",
    "context_en": "cultural/historical context in English",
    "context_ko": "cultural/historical context in Korean",
    "is_premium": true
  }
}
Be warm, encouraging, biblically accurate.
Never judge. Always point to God's love and grace.''';
  }
}
