import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFEC82B0);
  static const Color creamBackground = Color(0xFFFEF8F1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF2D2D2D);
  static const Color lightText = Color(0xFF6B6B6B);
  
  // Dark mode colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCream = Color(0xFF2A1F1A);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryPink,
      scaffoldBackgroundColor: AppColors.creamBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryPink,
        secondary: AppColors.creamBackground,
        surface: AppColors.creamBackground,
        onPrimary: AppColors.white,
        onSecondary: AppColors.darkText,
        onSurface: AppColors.darkText,
      ),
      textTheme: GoogleFonts.rubikTextTheme().copyWith(
        displayLarge: GoogleFonts.rubik(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        displayMedium: GoogleFonts.rubik(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        headlineLarge: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        headlineMedium: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        titleLarge: GoogleFonts.rubik(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.darkText,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          color: AppColors.darkText,
        ),
        bodyMedium: GoogleFonts.rubik(
          fontSize: 14,
          color: AppColors.lightText,
        ),
        labelLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.creamBackground,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryPink,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPink,
        secondary: AppColors.darkCream,
        surface: AppColors.darkBackground,
        onPrimary: AppColors.white,
        onSecondary: AppColors.creamBackground,
        onSurface: AppColors.creamBackground,
      ),
      textTheme: GoogleFonts.rubikTextTheme().copyWith(
        displayLarge: GoogleFonts.rubik(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.creamBackground,
        ),
        displayMedium: GoogleFonts.rubik(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.creamBackground,
        ),
        headlineLarge: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.creamBackground,
        ),
        headlineMedium: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.creamBackground,
        ),
        titleLarge: GoogleFonts.rubik(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.creamBackground,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          color: AppColors.creamBackground,
        ),
        bodyMedium: GoogleFonts.rubik(
          fontSize: 14,
          color: AppColors.creamBackground,
        ),
        labelLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.creamBackground,
        elevation: 0,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.creamBackground,
        ),
      ),
    );
  }
}