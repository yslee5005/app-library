import 'package:flutter/material.dart';

/// Centralized color tokens derived from a seed color.
///
/// Uses Material 3 [ColorScheme.fromSeed] to generate a full palette
/// from a single seed color, ensuring visual consistency.
class AppColors {
  const AppColors._({
    required this.seed,
    required this.light,
    required this.dark,
  });

  /// Creates [AppColors] from a single [seedColor].
  factory AppColors.fromSeed(Color seedColor) {
    return AppColors._(
      seed: seedColor,
      light: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      dark: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
    );
  }

  /// The original seed color used to generate the palette.
  final Color seed;

  /// Light mode color scheme.
  final ColorScheme light;

  /// Dark mode color scheme.
  final ColorScheme dark;

  /// Returns the [ColorScheme] for the given [brightness].
  ColorScheme scheme(Brightness brightness) {
    return brightness == Brightness.light ? light : dark;
  }
}
