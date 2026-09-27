import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF07080C);
  static const Color surface = Color(0xFF0D1017);
  static const Color surfaceSecondary = Color(0xFF141923);
  static const Color surfaceElevated = Color(0xFF1B2230);
  static const Color border = Color(0xFF212838);
  static const Color borderGlow = Color(0xFF2E3A52);

  static const Color accentGreen = Color(0xFF00FF9D);
  static const Color accentCyan = Color(0xFF00D2FF);
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentPink = Color(0xFFFF2E93);
  static const Color accentYellow = Color(0xFFFFD166);
  static const Color accentRed = Color(0xFFFF3B5C);

  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  static const Color ghEmpty = Color(0xFF161B22);
  static const Color ghLevel1 = Color(0xFF0E4429);
  static const Color ghLevel2 = Color(0xFF006D32);
  static const Color ghLevel3 = Color(0xFF26A641);
  static const Color ghLevel4 = Color(0xFF39D353);

  static Color getContributionColor(int count) {
    if (count <= 0) return ghEmpty;
    if (count == 1) return ghLevel1;
    if (count == 2) return ghLevel2;
    if (count <= 4) return ghLevel3;
    return ghLevel4;
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: accentGreen,
      colorScheme: const ColorScheme.dark(
        primary: accentGreen,
        secondary: accentCyan,
        surface: surface,
        error: accentRed,
        onPrimary: Color(0xFF000000),
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed),
        ),
      ),
    );
  }

  static BoxDecoration sleekGlassDecoration({
    Color? color,
    Color? borderColor,
    double borderRadius = 16,
    bool glowing = false,
  }) {
    return BoxDecoration(
      color: color ?? surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: glowing
            ? (borderColor ?? accentGreen).withValues(alpha: 0.5)
            : (borderColor ?? border),
        width: 1,
      ),
      boxShadow: glowing
          ? [
              BoxShadow(
                color: (borderColor ?? accentGreen).withValues(alpha: 0.15),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ]
          : [
              const BoxShadow(
                color: Color(0x66000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
    );
  }
}
