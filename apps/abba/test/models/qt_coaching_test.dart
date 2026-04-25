import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/qt_meditation_result.dart';

void main() {
  group('QtScores', () {
    test('fromJson parses all 4 axes', () {
      final scores = QtScores.fromJson({
        'comprehension': 4,
        'application': 3,
        'depth': 5,
        'authenticity': 4,
      });
      expect(scores.comprehension, 4);
      expect(scores.application, 3);
      expect(scores.depth, 5);
      expect(scores.authenticity, 4);
    });

    test('fromJson tolerates missing keys with 0 default', () {
      final scores = QtScores.fromJson(const {});
      expect(scores.comprehension, 0);
      expect(scores.application, 0);
      expect(scores.depth, 0);
      expect(scores.authenticity, 0);
      expect(scores.average, 0.0);
    });

    test('average computes 4-axis mean', () {
      const scores = QtScores(
        comprehension: 4,
        application: 3,
        depth: 5,
        authenticity: 4,
      );
      expect(scores.average, (4 + 3 + 5 + 4) / 4.0);
    });

    test('fromJson accepts numeric types (num → int)', () {
      final scores = QtScores.fromJson({
        'comprehension': 3.7,
        'application': 2,
        'depth': 4.0,
        'authenticity': 5,
      });
      expect(scores.comprehension, 3);
      expect(scores.application, 2);
      expect(scores.depth, 4);
      expect(scores.authenticity, 5);
    });
  });

  group('QtCoaching', () {
    test('fromJson — full valid payload', () {
      final coaching = QtCoaching.fromJson({
        'scores': {
          'comprehension': 4,
          'application': 3,
          'depth': 4,
          'authenticity': 4,
        },
        'strengths': ['본문의 핵심을 잘 포착하셨어요.', '일상과 연결한 점이 좋습니다.'],
        'improvements': ['오늘의 작은 행동을 한 가지 더하시면 3P 적용이 완성됩니다.'],
        'overall_feedback_en':
            'Your meditation shows honest reflection and trust.',
        'overall_feedback_ko': '신뢰가 아름답게 드러난 묵상이에요.',
        'expert_level': 'growing',
      });

      expect(coaching.scores.comprehension, 4);
      expect(coaching.scores.average, (4 + 3 + 4 + 4) / 4.0);
      expect(coaching.strengths, hasLength(2));
      expect(coaching.improvements, hasLength(1));
      expect(coaching.overallFeedbackEn, isNotEmpty);
      expect(coaching.overallFeedbackKo, isNotEmpty);
      expect(coaching.expertLevel, 'growing');
      expect(coaching.isPremium, isTrue);
    });

    test('fromJson — legacy / missing fields tolerated', () {
      // Simulate a minimal/corrupt payload — parser must not throw.
      final coaching = QtCoaching.fromJson(const {});
      expect(coaching.scores.comprehension, 0);
      expect(coaching.strengths, isEmpty);
      expect(coaching.improvements, isEmpty);
      expect(coaching.overallFeedbackEn, '');
      expect(coaching.overallFeedbackKo, '');
      expect(coaching.expertLevel, 'growing'); // default
      expect(coaching.isPremium, isTrue); // default
    });

    test('overallFeedback(locale) selects ko vs. en', () {
      const coaching = QtCoaching(
        scores: QtScores(
          comprehension: 4,
          application: 3,
          depth: 4,
          authenticity: 4,
        ),
        strengths: [],
        improvements: [],
        overallFeedbackEn: 'Beautiful reflection.',
        overallFeedbackKo: '아름다운 묵상이에요.',
        expertLevel: 'growing',
      );
      expect(coaching.overallFeedback('en'), 'Beautiful reflection.');
      expect(coaching.overallFeedback('ko'), '아름다운 묵상이에요.');
      // Non-ko locales fall through to English.
      expect(coaching.overallFeedback('ja'), 'Beautiful reflection.');
      expect(coaching.overallFeedback('es'), 'Beautiful reflection.');
    });

    test('placeholder factory returns locked-state defaults', () {
      final placeholder = QtCoaching.placeholder();
      expect(placeholder.scores.comprehension, 0);
      expect(placeholder.scores.application, 0);
      expect(placeholder.scores.depth, 0);
      expect(placeholder.scores.authenticity, 0);
      expect(placeholder.scores.average, 0.0);
      expect(placeholder.strengths, isEmpty);
      expect(placeholder.improvements, isEmpty);
      expect(placeholder.overallFeedbackEn, isNotEmpty);
      expect(placeholder.overallFeedbackKo, isNotEmpty);
      expect(placeholder.expertLevel, 'growing');
      expect(placeholder.isPremium, isTrue);
    });

    test('expertLevel variants all parse', () {
      for (final level in ['beginner', 'growing', 'expert']) {
        final coaching = QtCoaching.fromJson({'expert_level': level});
        expect(coaching.expertLevel, level);
      }
    });
  });
}
