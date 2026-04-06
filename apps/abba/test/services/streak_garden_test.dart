import 'package:flutter_test/flutter_test.dart';
import 'package:abba/widgets/streak_garden.dart';

void main() {
  group('streakGardenIcon', () {
    test('returns seed for 0-7 days', () {
      expect(streakGardenIcon(0), '🌱');
      expect(streakGardenIcon(7), '🌱');
    });

    test('returns sprout for 8-14 days', () {
      expect(streakGardenIcon(8), '🌿');
      expect(streakGardenIcon(14), '🌿');
    });

    test('returns bud for 15-30 days', () {
      expect(streakGardenIcon(15), '🌷');
      expect(streakGardenIcon(30), '🌷');
    });

    test('returns bloom for 31-59 days', () {
      expect(streakGardenIcon(31), '🌸');
      expect(streakGardenIcon(59), '🌸');
    });

    test('returns tree for 60+ days', () {
      expect(streakGardenIcon(60), '🌳');
      expect(streakGardenIcon(100), '🌳');
    });
  });

  group('streakGardenLabel', () {
    test('English labels for each tier', () {
      expect(streakGardenLabel(0, 'en'), 'A seed is planted');
      expect(streakGardenLabel(8, 'en'), 'A sprout is growing');
      expect(streakGardenLabel(15, 'en'), 'A bud is forming');
      expect(streakGardenLabel(31, 'en'), 'In full bloom');
      expect(streakGardenLabel(60, 'en'), 'A mighty tree');
    });

    test('Korean labels for each tier', () {
      expect(streakGardenLabel(0, 'ko'), contains('씨앗'));
      expect(streakGardenLabel(8, 'ko'), contains('새싹'));
      expect(streakGardenLabel(15, 'ko'), contains('꽃봉오리'));
      expect(streakGardenLabel(31, 'ko'), contains('만개'));
      expect(streakGardenLabel(60, 'ko'), contains('나무'));
    });

    test('non-ko locale falls back to English', () {
      expect(streakGardenLabel(0, 'ja'), 'A seed is planted');
    });
  });
}
