import 'package:abba/models/prayer.dart';
import 'package:abba/services/ai_analysis_exception.dart';
import 'package:abba/services/bible_text_service.dart';
import 'package:abba/services/gemini_cache_manager.dart';
import 'package:abba/services/real/section_analyzers/tier1_analyzer.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory BibleTextService for unit tests.
class _FakeBibleTextService implements BibleTextService {
  _FakeBibleTextService(this._data);

  final Map<String, String> _data; // key = "ref|locale"

  @override
  Future<String?> lookup(String reference, String locale) async {
    return _data['$reference|$locale'];
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

/// GeminiCacheManager requires a Supabase client. We construct one with
/// a dummy client and never call `loadRubricBundle` in these tests
/// (they exercise only the pure parse/extract helpers).
class _StubCacheManager implements GeminiCacheManager {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // tier1_analyzer logs via apiLog / prayerLog → requires appLogger.
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
  });

  Tier1Analyzer build({Map<String, String> verses = const {}}) {
    return Tier1Analyzer(
      cache: _StubCacheManager(),
      bible: _FakeBibleTextService(verses),
      apiKey: 'test-key',
    );
  }

  group('Tier1Analyzer.parseJsonForTest', () {
    test('valid JSON parses to Map', () {
      final a = build();
      final result = a.parseJsonForTest(
        '{"summary": {"gratitude": ["g"]}, "scripture": {"reference": "Psalm 23:1"}}',
      );
      expect(result['scripture'], isA<Map>());
    });

    test('null text throws parseError', () {
      final a = build();
      expect(
        () => a.parseJsonForTest(null),
        throwsA(
          isA<AiAnalysisException>().having(
            (e) => e.kind,
            'kind',
            AiAnalysisFailureKind.parseError,
          ),
        ),
      );
    });

    test('empty text throws parseError', () {
      final a = build();
      expect(() => a.parseJsonForTest(''), throwsA(isA<AiAnalysisException>()));
    });

    test('malformed JSON throws parseError', () {
      final a = build();
      expect(
        () => a.parseJsonForTest('{"summary": '),
        throwsA(
          isA<AiAnalysisException>().having(
            (e) => e.kind,
            'kind',
            AiAnalysisFailureKind.parseError,
          ),
        ),
      );
    });

    test('strips ```json``` code fence', () {
      final a = build();
      final result = a.parseJsonForTest(
        '```json\n{"summary": {}, "scripture": {"reference": "Psalm 1:1"}}\n```',
      );
      expect(result['scripture']['reference'], 'Psalm 1:1');
    });
  });

  group('Tier1Analyzer.extractT1ForTest', () {
    test('happy path — full summary + scripture', () {
      final a = build();
      final out = a.extractT1ForTest({
        'summary': {
          'gratitude': ['오늘 호흡'],
          'petition': ['가족 건강'],
          'intercession': ['교회 지체'],
        },
        'scripture': {
          'reference': 'Psalm 23:1',
          'reason': '하나님이 돌보심',
          'posture': '조용히 낭독',
          'key_word_hint': "'목자' = 돌보는 분",
          'original_words': [
            {
              'word': 'רֹעִי',
              'transliteration': "ro'i",
              'language': 'Hebrew',
              'meaning': '나의 목자',
              'nuance': '개인적 돌봄',
            },
          ],
        },
      }, 'ko');

      expect(out.summary.gratitude, ['오늘 호흡']);
      expect(out.scripture.reference, 'Psalm 23:1');
      expect(out.scripture.originalWords.single.transliteration, "ro'i");
    });

    test('missing summary key throws parseError', () {
      final a = build();
      expect(
        () => a.extractT1ForTest({
          'scripture': {'reference': 'Psalm 1:1'},
        }, 'en'),
        throwsA(isA<AiAnalysisException>()),
      );
    });

    test('missing scripture key throws parseError', () {
      final a = build();
      expect(
        () => a.extractT1ForTest({
          'summary': {'gratitude': [], 'petition': [], 'intercession': []},
        }, 'en'),
        throwsA(isA<AiAnalysisException>()),
      );
    });

    test('original_words entries pass through to Scripture.fromJson', () {
      // Tier1 delegates original_words parsing to Scripture.fromJson
      // which does NOT filter by word.isEmpty; downstream UI handles
      // empty entries via ScriptureOriginalWord rendering guards.
      final a = build();
      final out = a.extractT1ForTest({
        'summary': {'gratitude': [], 'petition': [], 'intercession': []},
        'scripture': {
          'reference': 'Psalm 1:1',
          'original_words': [
            {
              'word': 'וַיְהִי',
              'transliteration': 'vayehi',
              'language': 'Hebrew',
              'meaning': 'and it was',
            },
          ],
        },
      }, 'en');

      expect(out.scripture.originalWords.length, 1);
      expect(out.scripture.originalWords.single.transliteration, 'vayehi');
    });

    test('GROUNDING block present in user prompt (Wave B B1)', () {
      final a = build();
      final prompt = a.buildUserPromptForTest(
        transcript: 'I am thankful',
        locale: 'en',
        userName: 'Yong',
      );
      expect(prompt, contains('GROUNDING (★ critical):'));
      expect(prompt, contains("user's own words"));
      expect(prompt, contains('Do NOT invent ownership'));
      expect(prompt, contains('grammar is ambiguous'));
      // Order check — GROUNDING must come BEFORE the transcript.
      final groundingIdx = prompt.indexOf('GROUNDING');
      final transcriptIdx = prompt.indexOf('User prayer transcript:');
      expect(groundingIdx, lessThan(transcriptIdx));
    });

    test(
      'stripPostureQuotes removes guillemets / German low quotes / '
      'Japanese book marks (Wave B B4)',
      () {
        final a = build();
        // Stress every newly-added glyph in one shot. After stripping the
        // posture should be a clean ASCII text.
        final dirty = Scripture(
          reference: 'Psalm 1:1',
          posture: '«verse» „quote" 〝Japanese〟 ‚single‚',
        );
        final cleaned = a.stripPostureQuotesForTest(dirty);
        for (final glyph in const ['«', '»', '„', '‚', '〝', '〟']) {
          expect(cleaned.posture.contains(glyph), isFalse,
              reason: 'glyph "$glyph" should be stripped');
        }
      },
    );

    test('missing optional fields default to empty strings', () {
      final a = build();
      final out = a.extractT1ForTest({
        'summary': {
          'gratitude': ['g'],
          'petition': [],
          'intercession': [],
        },
        'scripture': {'reference': 'John 3:16'},
      }, 'en');

      expect(out.scripture.reason, '');
      expect(out.scripture.posture, '');
      expect(out.scripture.keyWordHint, '');
      expect(out.scripture.originalWords, isEmpty);
    });
  });
}
