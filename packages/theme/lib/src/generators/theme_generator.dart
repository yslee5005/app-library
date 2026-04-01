import 'package:flutter/material.dart';

import '../config/theme_config.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// Generates [ThemeData] for light and dark modes from a [ThemeConfig].
class ThemeGenerator {
  ThemeGenerator(this.config)
      : colors = AppColors.fromSeed(config.seedColor),
        typography = AppTypography(fontFamily: config.fontFamily);

  /// The configuration used to generate themes.
  final ThemeConfig config;

  /// Color tokens derived from [config.seedColor].
  final AppColors colors;

  /// Typography tokens with [config.fontFamily].
  final AppTypography typography;

  /// Generates a light-mode [ThemeData].
  ThemeData light() => _build(Brightness.light);

  /// Generates a dark-mode [ThemeData].
  ThemeData dark() => _build(Brightness.dark);

  ThemeData _build(Brightness brightness) {
    final colorScheme = colors.scheme(brightness);
    final textTheme = typography.textTheme;
    final radius = config.borderRadius;

    return ThemeData(
      useMaterial3: config.useMaterial3,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        filled: true,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
