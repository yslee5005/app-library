import 'package:abba/models/prayer.dart';
import 'package:abba/services/bible_text_service.dart';
import 'package:abba/services/gemini_cache_manager.dart';
import 'package:abba/services/real/section_analyzers/tier1_analyzer.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBibleTextService implements BibleTextService {
  @override
  Future<String?> lookup(String reference, String locale) async => null;

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _StubCacheManager implements GeminiCacheManager {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
  });

  Tier1Analyzer build() {
    return Tier1Analyzer(
      cache: _StubCacheManager(),
      bible: _FakeBibleTextService(),
      apiKey: 'test-key',
    );
  }

  group('_buildUserPrompt recentReferences block', () {
    test('omits block when list is empty', () {
      final out = build().buildUserPromptForTest(
        transcript: 'a prayer',
        locale: 'en',
        userName: 'Sam',
      );
      expect(out, isNot(contains('Recent scripture references already used')));
      expect(out, isNot(contains('Rotation rule')));
    });

    test('includes block + rotation rule when list is non-empty', () {
      final out = build().buildUserPromptForTest(
        transcript: 'a prayer',
        locale: 'en',
        userName: 'Sam',
        recentReferences: const [
          'Matthew 6:33',
          'Psalm 4:8',
          '1 Corinthians 13:4-7',
        ],
      );
      expect(out, contains('Recent scripture references already used'));
      expect(out, contains('- Matthew 6:33'));
      expect(out, contains('- Psalm 4:8'));
      expect(out, contains('- 1 Corinthians 13:4-7'));
      expect(out, contains('Rotation rule'));
      expect(out, contains('ESCAPE')); // lament escape clause is present
    });

    test('always reminds about English book name + same-chapter range', () {
      final out = build().buildUserPromptForTest(
        transcript: 'a prayer',
        locale: 'ko',
        userName: 'Kim',
      );
      expect(out, contains('English book name'));
      expect(out, contains('same chapter'));
    });
  });

  group('stripPostureQuotes', () {
    test('removes ASCII single+double quotes from posture', () {
      final s = const Scripture(
        reference: 'Matthew 6:33',
        posture: '"주를 의뢰함"으로 평안하실 거예요.',
      );
      final cleaned = build().stripPostureQuotesForTest(s);
      expect(cleaned.posture, '주를 의뢰함으로 평안하실 거예요.');
    });

    test('removes CJK quotation marks', () {
      final s = const Scripture(
        reference: 'Psalm 23:1',
        posture: '오늘 「주는 나의 목자」를 묵상하세요.',
      );
      final cleaned = build().stripPostureQuotesForTest(s);
      expect(cleaned.posture, contains('주는 나의 목자'));
      expect(cleaned.posture, isNot(contains('「')));
      expect(cleaned.posture, isNot(contains('」')));
    });

    test('leaves key_word_hint untouched even when posture is stripped', () {
      final s = const Scripture(
        reference: 'Matthew 6:33',
        posture: 'Quote "this".',
        keyWordHint: "'peace' = Hebrew shalom",
      );
      final cleaned = build().stripPostureQuotesForTest(s);
      expect(cleaned.posture, 'Quote this.');
      expect(cleaned.keyWordHint, "'peace' = Hebrew shalom");
    });

    test('returns same instance when posture has no quotes', () {
      final s = const Scripture(
        reference: 'Romans 8:28',
        posture: 'Read the verse aloud at sunset.',
      );
      final cleaned = build().stripPostureQuotesForTest(s);
      expect(cleaned.posture, 'Read the verse aloud at sunset.');
    });

    test('empty posture passes through', () {
      final s = const Scripture(reference: 'Romans 8:28');
      final cleaned = build().stripPostureQuotesForTest(s);
      expect(cleaned.posture, '');
    });
  });
}
