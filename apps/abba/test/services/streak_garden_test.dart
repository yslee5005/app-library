import 'package:flutter_test/flutter_test.dart';
import 'package:abba/widgets/streak_garden.dart';
import 'package:abba/l10n/generated/app_localizations_en.dart';
import 'package:abba/l10n/generated/app_localizations_ko.dart';
import 'package:abba/l10n/generated/app_localizations_ja.dart';

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

    test('returns tree for 60-99 days', () {
      expect(streakGardenIcon(60), '🌳');
      expect(streakGardenIcon(99), '🌳');
    });

    test('returns forest for 100+ days', () {
      expect(streakGardenIcon(100), '🌲🌳🌲');
    });
  });

  group('streakGardenLabel', () {
    final enL10n = AppLocalizationsEn();
    final koL10n = AppLocalizationsKo();
    final jaL10n = AppLocalizationsJa();

    test('English labels for each tier', () {
      expect(streakGardenLabel(0, enL10n), 'A seed of faith');
      expect(streakGardenLabel(8, enL10n), 'Growing sprout');
      expect(streakGardenLabel(15, enL10n), 'Budding flower');
      expect(streakGardenLabel(31, enL10n), 'Full bloom');
      expect(streakGardenLabel(60, enL10n), 'Strong tree');
    });

    test('Korean labels for each tier', () {
      expect(streakGardenLabel(0, koL10n), contains('씨앗'));
      expect(streakGardenLabel(8, koL10n), contains('새싹'));
      expect(streakGardenLabel(15, koL10n), contains('꽃봉오리'));
      expect(streakGardenLabel(31, koL10n), contains('만개'));
      expect(streakGardenLabel(60, koL10n), contains('나무'));
    });

    test('Japanese labels use l10n', () {
      expect(streakGardenLabel(0, jaL10n), '信仰の種');
    });
  });
}
