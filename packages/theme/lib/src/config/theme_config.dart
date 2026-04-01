import 'package:flutter/material.dart';

/// Configuration input for generating a complete app theme.
///
/// Provide a [seedColor] and optional customizations; pass to
/// [ThemeGenerator] to produce light and dark [ThemeData].
class ThemeConfig {
  const ThemeConfig({
    required this.seedColor,
    this.fontFamily,
    this.borderRadius = 12.0,
    this.useMaterial3 = true,
  });

  /// Primary seed color used to derive the entire color palette.
  final Color seedColor;

  /// Optional font family applied to all text styles.
  final String? fontFamily;

  /// Default border radius used for buttons, cards, inputs, etc.
  final double borderRadius;

  /// Whether to use Material 3 design (default: true).
  final bool useMaterial3;
}
