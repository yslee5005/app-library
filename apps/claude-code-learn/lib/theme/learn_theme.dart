import 'package:flutter/material.dart';
import 'package:app_lib_theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

/// Seed color: deep navy suitable for a reading / learning app.
const _seedColor = Color(0xFF1A237E);

/// Theme configuration for Claude Code Learn.
const learnThemeConfig = ThemeConfig(
  seedColor: _seedColor,
  fontFamily: null, // will use Google Fonts below
  borderRadius: 12.0,
);

/// Pre-built [ThemeGenerator] for the app.
final learnThemeGenerator = ThemeGenerator(learnThemeConfig);

/// App-specific color helpers that complement the generated palette.
class LearnColors {
  LearnColors._();

  static const navy = Color(0xFF1A237E);
  static const lightNavy = Color(0xFF3949AB);
  static const surface = Color(0xFFF5F5FA);
  static const surfaceDark = Color(0xFF1C1B2E);
  static const accent = Color(0xFF00BFA5);
  static const codeBackground = Color(0xFF263238);
  static const codeBackgroundLight = Color(0xFFF5F5F5);
  static const progressGreen = Color(0xFF66BB6A);
  static const bookmarkAmber = Color(0xFFFFA726);
  static const muted = Color(0xFF9E9E9E);
}

/// App-specific typography built on top of Google Fonts Noto Sans.
class LearnTypography {
  LearnTypography._();

  static TextStyle get hero => GoogleFonts.notoSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get h1 => GoogleFonts.notoSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get h2 => GoogleFonts.notoSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get bodySmall => GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get label => GoogleFonts.notoSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get caption => GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: LearnColors.muted,
      );
}
