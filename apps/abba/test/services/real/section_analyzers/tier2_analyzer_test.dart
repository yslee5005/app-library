import 'package:abba/services/ai_analysis_exception.dart';
import 'package:abba/services/gemini_cache_manager.dart';
import 'package:abba/services/real/section_analyzers/tier2_analyzer.dart';
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

  Tier2Analyzer build() =>
      Tier2Analyzer(cache: _StubCacheManager(), apiKey: 'test-key');

  group('Tier2Analyzer.parseJsonForTest', () {
    test('valid JSON parses', () {
      final a = build();
      final result = a.parseJsonForTest(
        '{"bible_story": {"title": "t", "summary": "s"}, "testimony": "x"}',
      );
      expect(result['testimony'], 'x');
    });

    test('empty text throws parseError', () {
      final a = build();
      expect(
        () => a.parseJsonForTest(''),
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
      final a = build();
      expect(
        () => a.parseJsonForTest('{not json'),
        throwsA(isA<AiAnalysisException>()),
      );
    });

    test('strips ```json``` fence', () {
      final a = build();
      final result = a.parseJsonForTest(
        '```json\n{"bible_story": {"title": "t", "summary": "s"}, "testimony": "y"}\n```',
      );
      expect(result['testimony'], 'y');
    });
  });
}
