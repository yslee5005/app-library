import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_lib_theme/theme.dart';

void main() {
  group('AppColors', () {
    test('fromSeed produces light and dark schemes', () {
      final colors = AppColors.fromSeed(Colors.blue);

      expect(colors.seed, Colors.blue);
      expect(colors.light.brightness, Brightness.light);
      expect(colors.dark.brightness, Brightness.dark);
    });

    test('scheme() returns correct scheme for brightness', () {
      final colors = AppColors.fromSeed(Colors.teal);

      expect(colors.scheme(Brightness.light), colors.light);
      expect(colors.scheme(Brightness.dark), colors.dark);
    });
  });

  group('AppSpacing', () {
    test('values follow 4px grid', () {
      expect(AppSpacing.xs, 4.0);
      expect(AppSpacing.sm, 8.0);
      expect(AppSpacing.md, 16.0);
      expect(AppSpacing.lg, 24.0);
      expect(AppSpacing.xl, 32.0);
      expect(AppSpacing.xxl, 48.0);
    });
  });

  group('AppRadius', () {
    test('values are ascending', () {
      expect(AppRadius.sm, lessThan(AppRadius.md));
      expect(AppRadius.md, lessThan(AppRadius.lg));
      expect(AppRadius.lg, lessThan(AppRadius.xl));
    });

    test('BorderRadius helpers have correct values', () {
      expect(AppRadius.smAll, BorderRadius.circular(AppRadius.sm));
      expect(AppRadius.mdAll, BorderRadius.circular(AppRadius.md));
      expect(AppRadius.lgAll, BorderRadius.circular(AppRadius.lg));
      expect(AppRadius.xlAll, BorderRadius.circular(AppRadius.xl));
    });
  });

  group('AppTypography', () {
    test('textTheme contains all Material text styles', () {
      const typography = AppTypography();
      final tt = typography.textTheme;

      expect(tt.displayLarge, isNotNull);
      expect(tt.headlineMedium, isNotNull);
      expect(tt.bodyMedium, isNotNull);
      expect(tt.labelSmall, isNotNull);
    });

    test('custom fontFamily is applied', () {
      const typography = AppTypography(fontFamily: 'Roboto');
      final tt = typography.textTheme;

      expect(tt.bodyMedium?.fontFamily, 'Roboto');
      expect(tt.headlineLarge?.fontFamily, 'Roboto');
    });

    test('null fontFamily uses default', () {
      const typography = AppTypography();
      final tt = typography.textTheme;

      expect(tt.bodyMedium?.fontFamily, isNull);
    });
  });

  group('ThemeConfig', () {
    test('default values', () {
      const config = ThemeConfig(seedColor: Colors.purple);

      expect(config.seedColor, Colors.purple);
      expect(config.fontFamily, isNull);
      expect(config.borderRadius, 12.0);
      expect(config.useMaterial3, isTrue);
    });

    test('custom values', () {
      const config = ThemeConfig(
        seedColor: Colors.orange,
        fontFamily: 'Inter',
        borderRadius: 8.0,
        useMaterial3: false,
      );

      expect(config.seedColor, Colors.orange);
      expect(config.fontFamily, 'Inter');
      expect(config.borderRadius, 8.0);
      expect(config.useMaterial3, isFalse);
    });
  });

  group('ThemeGenerator', () {
    late ThemeGenerator generator;

    setUp(() {
      const config = ThemeConfig(
        seedColor: Colors.indigo,
        fontFamily: 'NotoSans',
        borderRadius: 16.0,
      );
      generator = ThemeGenerator(config);
    });

    test('light() returns a valid ThemeData with light brightness', () {
      final theme = generator.light();

      expect(theme.brightness, Brightness.light);
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('dark() returns a valid ThemeData with dark brightness', () {
      final theme = generator.dark();

      expect(theme.brightness, Brightness.dark);
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('light and dark themes differ', () {
      final light = generator.light();
      final dark = generator.dark();

      expect(light.colorScheme.surface, isNot(dark.colorScheme.surface));
    });

    test('custom borderRadius is applied to card theme', () {
      final theme = generator.light();
      final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;
      final borderRadius = cardShape.borderRadius as BorderRadius;

      expect(borderRadius.topLeft.x, 16.0);
    });

    test('fontFamily is applied to text theme', () {
      final theme = generator.light();

      expect(theme.textTheme.bodyMedium?.fontFamily, 'NotoSans');
    });

    test('different seed colors produce different palettes', () {
      const blueConfig = ThemeConfig(seedColor: Colors.blue);
      const redConfig = ThemeConfig(seedColor: Colors.red);

      final blueTheme = ThemeGenerator(blueConfig).light();
      final redTheme = ThemeGenerator(redConfig).light();

      expect(blueTheme.colorScheme.primary, isNot(redTheme.colorScheme.primary));
    });
  });
}
