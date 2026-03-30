import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const cream = Color(0xFFF8F4EE);
  static const warmWhite = Color(0xFFFDFAF6);
  static const deepBrown = Color(0xFF2C1810);
  static const caramel = Color(0xFFC4813A);
  static const gold = Color(0xFFD4A853);
  static const softGold = Color(0xFFEDD79A);
  static const terracotta = Color(0xFFC0614B);
  static const sage = Color(0xFF7B9E87);
  static const dustyRose = Color(0xFFD4938A);
  static const lightGrey = Color(0xFFEDE8E1);
  static const midGrey = Color(0xFFB5AA9E);
  static const dark = Color(0xFF1A0F08);
  static const shadow = Color(0x1F2C1810);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.caramel,
          background: AppColors.cream,
        ),
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.deepBrown,
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.deepBrown,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.deepBrown,
          ),
          titleLarge: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.deepBrown,
          ),
          bodyLarge: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.deepBrown,
          ),
          bodyMedium: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.midGrey,
          ),
          labelSmall: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        scaffoldBackgroundColor: AppColors.cream,
        useMaterial3: true,
      );
}
