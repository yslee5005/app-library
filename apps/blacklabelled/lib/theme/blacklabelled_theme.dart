import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlackLabelledColors {
  // Brand colors — dark-first, monochrome only
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF131313);
  static const surfaceContainer = Color(0xFF1B1B1B);
  static const surfaceContainerHigh = Color(0xFF2A2A2A);
  static const primary = Color(0xFFFFFFFF);
  static const onPrimary = Color(0xFF000000);
  static const secondary = Color(0xFF919191);
  static const textPrimary = Color(0xFFE2E2E2);
  static const textSecondary = Color(0xFFC6C6C6);
  static const textMuted = Color(0xFF737373);
  static const border = Color(0xFF474747);
  static const borderSubtle = Color(0xFF353535);
}

class BlackLabelledSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  static const double contentPadding = 32.0;
  static const double sectionSpacing = 64.0;
}

class BlackLabelledTheme {
  static const double borderRadius = 0.0;
  static const double cardElevation = 0.0;

  static TextTheme _buildTextTheme(TextTheme base) {
    const textColor = BlackLabelledColors.textPrimary;
    return base.copyWith(
      // Display — Montserrat ExtraLight Italic (brand hero)
      displayLarge: GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.w200,
        fontStyle: FontStyle.italic,
        letterSpacing: -1.5,
        color: Colors.white,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 30,
        fontWeight: FontWeight.w200,
        fontStyle: FontStyle.italic,
        letterSpacing: -1.0,
        color: Colors.white,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: textColor,
        height: 1.2,
      ),
      // Headlines — Montserrat Light
      headlineLarge: GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: textColor,
      ),
      // Titles — Montserrat Regular/Medium
      titleLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: textColor,
      ),
      titleSmall: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: textColor,
      ),
      // Body — Noto Sans KR Light (Korean readability)
      bodyLarge: GoogleFonts.notoSansKr(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: textColor,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.notoSansKr(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: textColor,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.notoSansKr(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: BlackLabelledColors.textSecondary,
        height: 1.5,
      ),
      // Labels — Inter for UI precision
      labelLarge: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.0,
        color: textColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: textColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 3.0,
        color: BlackLabelledColors.textMuted,
      ),
    );
  }

  /// Dark theme is the primary theme for BlackLabelled
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: BlackLabelledColors.background,
      colorScheme: const ColorScheme.dark(
        primary: BlackLabelledColors.primary,
        onPrimary: BlackLabelledColors.onPrimary,
        secondary: BlackLabelledColors.secondary,
        onSecondary: BlackLabelledColors.background,
        surface: BlackLabelledColors.surface,
        onSurface: BlackLabelledColors.textPrimary,
        surfaceContainerLow: BlackLabelledColors.surfaceContainer,
        surfaceContainerHigh: BlackLabelledColors.surfaceContainerHigh,
        outline: BlackLabelledColors.border,
        outlineVariant: BlackLabelledColors.borderSubtle,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: BlackLabelledColors.background,
        foregroundColor: BlackLabelledColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.epilogue(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: BlackLabelledColors.background,
        selectedItemColor: Colors.white,
        unselectedItemColor: BlackLabelledColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.epilogue(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        unselectedLabelStyle: GoogleFonts.epilogue(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: BlackLabelledColors.surface,
        elevation: cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: BlackLabelledColors.textMuted,
        indicatorColor: Colors.white,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.0,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: BlackLabelledColors.borderSubtle,
        thickness: 0.5,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: BlackLabelledColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: BlackLabelledColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  /// Light theme kept for compatibility but dark is default
  static ThemeData get lightTheme => darkTheme;
}
