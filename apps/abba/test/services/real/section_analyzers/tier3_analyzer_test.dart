import 'package:abba/services/ai_analysis_exception.dart';
import 'package:abba/services/gemini_cache_manager.dart';
import 'package:abba/services/real/section_analyzers/tier3_analyzer.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:flutter_test/flutter_test.dart';

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

  Tier3Analyzer build() =>
      Tier3Analyzer(cache: _StubCacheManager(), apiKey: 'test-key');

  group('Tier3Analyzer.parseJsonForTest', () {
    test('strips code fence + parses', () {
      final a = build();
      final result = a.parseJsonForTest(
        '```json\n{"guidance": {"content": "...", "is_premium": true}}\n```',
      );
      expect(result['guidance'], isA<Map>());
    });

    test('empty throws parseError', () {
      expect(
        () => build().parseJsonForTest(''),
        throwsA(isA<AiAnalysisException>()),
      );
    });
  });

  group('Tier3Analyzer.extractT3ForTest', () {
    test('all three sections present', () {
      final a = build();
      final out = a.extractT3ForTest({
        'guidance': {'content': 'take a small step', 'is_premium': true},
        'ai_prayer': {'text': 'Father...', 'citations': [], 'is_premium': true},
        'historical_story': {
          // Wave B (B4) — sanitizer now requires the FULL whitelist anchor
          // (e.g. "George Müller"), not the standalone "müller" surname,
          // because the standalone form admitted unrelated names.
          'title': 'George Müller',
          'reference': 'Bristol, 1830s',
          'summary': 'George Müller cared for orphans by faith.',
          'lesson': 'l',
          'is_premium': true,
        },
      });

      expect(out.guidance, isNotNull);
      expect(out.aiPrayer, isNotNull);
      expect(out.historicalStory, isNotNull);
      expect(out.historicalStory!.title, 'George Müller');
    });

    test('partial (only guidance) is allowed', () {
      final a = build();
      final out = a.extractT3ForTest({
        'guidance': {'content': 'one thing', 'is_premium': true},
      });

      expect(out.guidance, isNotNull);
      expect(out.aiPrayer, isNull);
      expect(out.historicalStory, isNull);
    });

    test('all three missing throws parseError', () {
      final a = build();
      expect(
        () => a.extractT3ForTest({}),
        throwsA(
          isA<AiAnalysisException>().having(
            (e) => e.kind,
            'kind',
            AiAnalysisFailureKind.parseError,
          ),
        ),
      );
    });

    test('non-map section values are ignored', () {
      final a = build();
      final out = a.extractT3ForTest({
        'guidance': 'this should be a map',
        'ai_prayer': {'text': 'Father...', 'is_premium': true},
      });

      expect(out.guidance, isNull);
      expect(out.aiPrayer, isNotNull);
    });
  });
}
