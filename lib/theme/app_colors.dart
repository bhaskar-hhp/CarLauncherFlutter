import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base
  static const Color darkBackground = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1A1F35);
  static const Color darkBorder = Color(0x1AFFFFFF);

  // Neon accents
  static const Color neonBlue = Color(0xFF3B82F6);
  static const Color neonCyan = Color(0xFF06B6D4);
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonGreen = Color(0xFF22C55E);
  static const Color neonRed = Color(0xFFEF4444);
  static const Color neonOrange = Color(0xFFF97316);
  static const Color neonPink = Color(0xFFEC4899);

  // Glass
  static const Color glassLight = Color(0x19FFFFFF);
  static const Color glassMedium = Color(0x2DFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0x66F1F5F9);
  static const Color textDim = Color(0xFF475569);

  // Status
  static const Color statusOnline = Color(0xFF4ADE80);
  static const Color statusOffline = Color(0xFF64748B);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);

  // Accent options for settings
  static const Map<String, Color> accentColors = {
    'Neon Blue': neonBlue,
    'Neon Cyan': neonCyan,
    'Neon Purple': neonPurple,
    'Neon Green': neonGreen,
    'Neon Red': neonRed,
    'Neon Orange': neonOrange,
    'Neon Pink': neonPink,
  };
}
