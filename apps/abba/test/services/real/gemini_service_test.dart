import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_lib_logging/logging.dart';

import 'package:abba/services/ai_analysis_exception.dart';
import 'package:abba/services/real/gemini_service.dart';

/// Tests the refactor introduced by commit `8cd014e`: all 7 `AiService`
/// methods now branch on `AppConfig.useMockAi` (driven by `ENABLE_MOCK_AI`
/// dotenv flag). The JSON parsers were exposed via `@visibleForTesting`
/// in R1 so the Gemini-response parsing contract can be pinned here.
///
/// Out of scope: real `GenerativeModel` calls (depends on network + API key).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // apiLog.error paths are exercised by the `catch` blocks inside each
    // parser; appLogger must be initialized before those fire or we hit a
    // LateInitializationError.
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
    // flutter_dotenv 6.0 throws NotInitializedError on `dotenv.env` until
    // load*() is called. loadFromString with isOptional=true lets us inject
    // the AI mock flag without touching the asset bundle.
    dotenv.loadFromString(
      mergeWith: const {'ENABLE_MOCK_AI': 'true'},
      isOptional: true,
    );
  });

  late GeminiService service;

  setUp(() {
    service = GeminiService();
  });

  // ---------------------------------------------------------------------------
  // parseJsonFromResponse — the lowest-level helper used by every parser.
  // ---------------------------------------------------------------------------
  group('parseJsonFromResponse', () {
    test('null text throws FormatException', () {
      expect(
        () => service.parseJsonFromResponse(null),
        throwsA(isA<FormatException>()),
      );
    });

    test('empty text throws FormatException', () {
      expect(
        () => service.parseJsonFromResponse(''),
        throwsA(isA<FormatException>()),
      );
    });

    test('valid JSON returns decoded map', () {
      final result = service.parseJsonFromResponse('{"foo":"bar","n":1}');
      expect(result['foo'], 'bar');
      expect(result['n'], 1);
    });

    test('invalid JSON propagates parse error', () {
      expect(
        () => service.parseJsonFromResponse('not json'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // parsePrayerJson — prayer analysis entry point.
  // ---------------------------------------------------------------------------
  group('parsePrayerJson', () {
    test('valid JSON maps required fields', () {
      const json = '''
      {
        "prayer_summary": {
          "gratitude": ["Thanks for morning"],
          "petition": ["Guide my steps"],
          "intercession": ["Heal my friend"]
        },
        "scripture": {"reference": "Psalm 23:1", "reason": "shepherd's care"},
        "bible_story": {"title": "David", "summary": "Shepherd king story."},
        "testimony": "Lord, thank you for today."
      }
      ''';
      final result = service.parsePrayerJson(json, 'en');
      expect(result.scripture.reference, 'Psalm 23:1');
      expect(result.scripture.reason, "shepherd's care");
      expect(result.bibleStory.title, 'David');
      expect(result.testimony, 'Lord, thank you for today.');
      expect(result.prayerSummary?.gratitude, contains('Thanks for morning'));
    });

    // 2026-04-23: Phase 3 Pending/Retry — parsePrayerJson no longer silently
    // returns a hardcoded fallback on malformed input. Throws so the UI can
    // show an explicit error view + retry CTA.
    test('malformed JSON throws AiAnalysisException(parseError)', () {
      expect(
        () => service.parsePrayerJson('not json at all', 'en'),
        throwsA(
          isA<AiAnalysisException>().having(
            (e) => e.kind,
            'kind',
            AiAnalysisFailureKind.parseError,
          ),
        ),
      );
    });

    test('null text throws AiAnalysisException(parseError)', () {
      expect(
        () => service.parsePrayerJson(null, 'en'),
        throwsA(
          isA<AiAnalysisException>().having(
            (e) => e.kind,
            'kind',
            AiAnalysisFailureKind.parseError,
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // parsePremiumJson — Premium-only fields (all optional).
  // ---------------------------------------------------------------------------
  group('parsePremiumJson', () {
    test('valid JSON with all three fields', () {
      const json = '''
      {
        "historical_story": {
          "title": "Hannah's Prayer",
          "reference": "1 Samuel 1",
          "summary": "Hannah wept before the Lord.",
          "lesson": "God hears silent prayers.",
          "is_premium": true
        },
        "ai_prayer": {
          "text": "Father, guide our hearts today.",
          "is_premium": true
        },
        "guidance": {
          "content": "Your heart is open. Keep praying.",
          "is_premium": true
        }
      }
      ''';
      final result = service.parsePremiumJson(json);
      expect(result.historicalStory?.title, "Hannah's Prayer");
      expect(result.aiPrayer?.text, contains('Father'));
      expect(result.guidance?.content, isNotEmpty);
    });

    test('missing fields return null-filled PremiumContent', () {
      final result = service.parsePremiumJson('{}');
      expect(result.historicalStory, isNull);
      expect(result.aiPrayer, isNull);
      expect(result.guidance, isNull);
    });

    test('malformed JSON returns empty PremiumContent', () {
      final result = service.parsePremiumJson('not json');
      expect(result.historicalStory, isNull);
      expect(result.aiPrayer, isNull);
      expect(result.guidance, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // parseMeditationJson — QT response with reference sanity check.
  // ---------------------------------------------------------------------------
  group('parseMeditationJson', () {
    test('valid JSON returns QtMeditationResult', () {
      const json = '''
      {
        "meditation_summary": {
          "summary": "God as shepherd.",
          "topic": "Care",
          "insight": "Trust."
        },
        "scripture": {"reference": "Psalm 23:1"},
        "application": {
          "morning_action": "Thank God.",
          "day_action": "Pause.",
          "evening_action": "Reflect."
        },
        "knowledge": {
          "historical_context": "David wrote Psalm 23."
        }
      }
      ''';
      final result = service.parseMeditationJson(json, 'en');
      expect(result.scripture.reference, 'Psalm 23:1');
      expect(result.meditationSummary.topic, 'Care');
      expect(result.application.morningAction, 'Thank God.');
    });

    // 2026-04-23: Phase 3 Pending/Retry — missing/malformed response throws.
    test('missing scripture.reference throws parseError', () {
      const json = '''
      {
        "meditation_summary": {"summary": "S", "topic": "T", "insight": "I"},
        "scripture": {"reference": ""},
        "application": {
          "morning_action": "a", "day_action": "b", "evening_action": "c"
        },
        "knowledge": {"historical_context": ""}
      }
      ''';
      expect(
        () => service.parseMeditationJson(json, 'en'),
        throwsA(
          isA<AiAnalysisException>().having(
            (e) => e.kind,
            'kind',
            AiAnalysisFailureKind.parseError,
          ),
        ),
      );
    });

    test('malformed JSON throws parseError', () {
      expect(
        () => service.parseMeditationJson('bad', 'en'),
        throwsA(
          isA<AiAnalysisException>().having(
            (e) => e.kind,
            'kind',
            AiAnalysisFailureKind.parseError,
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // parseCoachingJson — Prayer coaching with forbidden-word filter.
  // ---------------------------------------------------------------------------
  group('parseCoachingJson', () {
    test('valid JSON without forbidden words', () {
      const json = '''
      {
        "scores": {
          "specificity": 4,
          "god_centeredness": 3,
          "acts_balance": 4,
          "authenticity": 5
        },
        "strengths": ["Specific mentions of family."],
        "improvements": ["Add one line of confession."],
        "overall_feedback_en": "Beautiful balance of gratitude and intercession.",
        "overall_feedback_ko": "감사와 중보의 균형이 아름답습니다.",
        "expert_level": "growing"
      }
      ''';
      final result = service.parseCoachingJson(json);
      expect(result.scores.specificity, 4);
      expect(result.strengths, hasLength(1));
      expect(result.overallFeedbackEn, contains('Beautiful'));
    });

    test('forbidden English word → placeholder', () {
      const json = '''
      {
        "scores": {
          "specificity": 2, "god_centeredness": 2,
          "acts_balance": 2, "authenticity": 2
        },
        "strengths": ["Your prayer is inadequate here."],
        "improvements": [],
        "overall_feedback_en": "",
        "overall_feedback_ko": "",
        "expert_level": "beginner"
      }
      ''';
      final result = service.parseCoachingJson(json);
      // Placeholder has empty strengths + canonical feedback copy.
      expect(result.strengths, isEmpty);
      expect(result.overallFeedbackEn, contains('Unlock'));
    });

    test('forbidden Korean word → placeholder', () {
      const json = '''
      {
        "scores": {
          "specificity": 2, "god_centeredness": 2,
          "acts_balance": 2, "authenticity": 2
        },
        "strengths": [],
        "improvements": ["당신의 기도는 부족합니다."],
        "overall_feedback_en": "",
        "overall_feedback_ko": "",
        "expert_level": "beginner"
      }
      ''';
      final result = service.parseCoachingJson(json);
      expect(result.improvements, isEmpty);
      expect(result.overallFeedbackKo, contains('Pro'));
    });

    test('malformed JSON → placeholder', () {
      final result = service.parseCoachingJson('not json');
      expect(result.strengths, isEmpty);
      expect(result.improvements, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // parseQtCoachingJson — QT coaching with forbidden-word filter.
  // ---------------------------------------------------------------------------
  group('parseQtCoachingJson', () {
    test('valid JSON without forbidden words', () {
      const json = '''
      {
        "scores": {
          "comprehension": 4, "application": 3,
          "depth": 5, "authenticity": 4
        },
        "strengths": ["Tied the passage to daily commute."],
        "improvements": ["Consider memorizing one phrase."],
        "overall_feedback_en": "Deep engagement with the text.",
        "overall_feedback_ko": "본문과 깊이 씨름하신 흔적이 느껴집니다.",
        "expert_level": "growing"
      }
      ''';
      final result = service.parseQtCoachingJson(json);
      expect(result.scores.comprehension, 4);
      expect(result.strengths, hasLength(1));
    });

    test('forbidden word → placeholder', () {
      const json = '''
      {
        "scores": {
          "comprehension": 1, "application": 1,
          "depth": 1, "authenticity": 1
        },
        "strengths": ["Your meditation shows poor insight."],
        "improvements": [],
        "overall_feedback_en": "",
        "overall_feedback_ko": "",
        "expert_level": "beginner"
      }
      ''';
      final result = service.parseQtCoachingJson(json);
      expect(result.strengths, isEmpty);
    });

    test('malformed JSON → placeholder', () {
      final result = service.parseQtCoachingJson('bad json');
      expect(result.strengths, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // AppConfig.useMockAi=true branch — each of the 7 AiService methods should
  // return the hardcoded sample without making a Gemini call.
  // ---------------------------------------------------------------------------
  group('useMockAi=true bypass', () {
    test('analyzePrayer returns hardcoded result', () async {
      final result = await service.analyzePrayer(
        transcript: 'test prayer',
        locale: 'en',
      );
      expect(result.scripture.reference, 'Psalm 23:1');
    });

    test('analyzePrayerCore returns hardcoded result', () async {
      final result = await service.analyzePrayerCore(
        transcript: 'test prayer',
        locale: 'en',
      );
      expect(result.scripture.reference, 'Psalm 23:1');
    });

    test('analyzePrayerPremium returns hardcoded premium content', () async {
      final result = await service.analyzePrayerPremium(
        transcript: 'test prayer',
        locale: 'en',
      );
      // Hardcoded premium content has at least historicalStory or aiPrayer set.
      expect(result.historicalStory != null || result.aiPrayer != null, isTrue);
    });

    test('analyzeMeditation returns hardcoded QT result', () async {
      final result = await service.analyzeMeditation(
        passageReference: 'Psalm 23:1-6',
        passageText: '...',
        meditationText: 'test meditation',
        locale: 'en',
      );
      expect(result.scripture.reference, isNotEmpty);
      expect(result.meditationSummary.summary, isNotEmpty);
    });

    test('analyzePrayerCoaching returns hardcoded coaching', () async {
      final result = await service.analyzePrayerCoaching(
        transcript: 'test prayer',
        locale: 'en',
      );
      // Hardcoded coaching (not placeholder) has non-zero scores.
      expect(result.scores.specificity, greaterThan(0));
    });

    test('analyzeQtCoaching returns hardcoded coaching', () async {
      final result = await service.analyzeQtCoaching(
        meditation: 'test meditation',
        scriptureReference: 'Psalm 23:1',
        locale: 'en',
      );
      expect(result.scores.comprehension, greaterThan(0));
    });

    // analyzePrayerFromAudio is skipped — requires a real audio file on disk
    // even in the mock path (the method returns early before reading the file,
    // but we keep the test surface minimal and cover the text-mode branch).
  });
}
