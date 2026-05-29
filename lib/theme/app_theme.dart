import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme(Color accent) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accent.withValues(alpha: 0.8),
        surface: AppColors.darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.textPrimary),
        displayMedium: TextStyle(color: AppColors.textPrimary),
        headlineLarge: TextStyle(color: AppColors.textPrimary),
        headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        bodySmall: TextStyle(color: AppColors.textMuted),
        labelLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 0.5),
    );
  }

  static List<BoxShadow> get neonGlow(Color accent) {
    return [
      BoxShadow(color: accent.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: -5),
      BoxShadow(color: accent.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: -10),
    ];
  }

  static BoxDecoration get glassCard {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.glassLight,
          AppColors.glassMedium,
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.glassBorder, width: 0.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 30,
          spreadRadius: -10,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration glassCardColored(Color accent) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accent.withValues(alpha: 0.15),
          accent.withValues(alpha: 0.05),
          AppColors.glassLight,
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: accent.withValues(alpha: 0.2),
        width: 0.5,
      ),
      boxShadow: neonGlow(accent),
    );
  }
}
