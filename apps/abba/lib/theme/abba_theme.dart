import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AbbaColors {
  AbbaColors._();

  // Primary
  static const sage = Color(0xFF8FBC8F);
  static const cream = Color(0xFFFFF8F0);
  static const warmBrown = Color(0xFF5D4E37);
  static const softGold = Color(0xFFD4A574);

  // Pastels (QT cards)
  static const softPink = Color(0xFFFFB7C5);
  static const softMint = Color(0xFFB2DFDB);
  static const softLavender = Color(0xFFD1C4E9);
  static const softPeach = Color(0xFFFFCCBC);
  static const softSky = Color(0xFFB3E5FC);

  // Functional
  static const premium = Color(0xFFD4A574);
  static const streak = Color(0xFFFF6B35);
  static const muted = Color(0xFF9E9E8E);
  static const error = Color(0xFFE57373);
  static const white = Color(0xFFFFFFFF);
}

class AbbaTypography {
  AbbaTypography._();

  static TextStyle hero = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AbbaColors.warmBrown,
  );

  static TextStyle h1 = GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AbbaColors.warmBrown,
  );

  static TextStyle h2 = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AbbaColors.warmBrown,
  );

  static TextStyle body = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AbbaColors.warmBrown,
  );

  static TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AbbaColors.warmBrown,
  );

  static TextStyle label = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AbbaColors.warmBrown,
  );

  static TextStyle caption = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AbbaColors.muted,
  );
}

class AbbaSpacing {
  AbbaSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AbbaRadius {
  AbbaRadius._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;
}

const double abbaButtonHeight = 56.0;
const double abbaHeroButtonHeight = 80.0;
const double abbaTabBarHeight = 56.0;

ThemeData abbaTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AbbaColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AbbaColors.sage,
      surface: AbbaColors.cream,
      primary: AbbaColors.sage,
      onPrimary: AbbaColors.white,
      secondary: AbbaColors.softGold,
      onSecondary: AbbaColors.warmBrown,
      error: AbbaColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AbbaColors.cream,
      foregroundColor: AbbaColors.warmBrown,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AbbaTypography.h1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AbbaColors.sage,
        foregroundColor: AbbaColors.white,
        minimumSize: const Size(double.infinity, abbaButtonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        textStyle: AbbaTypography.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AbbaColors.white,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AbbaColors.white,
      elevation: 2,
      shadowColor: AbbaColors.warmBrown.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.sm,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AbbaColors.cream,
      selectedColor: AbbaColors.sage,
      labelStyle: AbbaTypography.bodySmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AbbaRadius.xl),
      ),
    ),
  );
}
