import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFEEF9FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFE5E7EB);
  static const footerSurface = Color(0xFFD9EFF2);
  static const accent = Color(0xFF48CAE4);
  static const accentHover = Color(0xFF00B4D8);
  static const accentSoft = Color(0xFFD9EFF2);
  static const textPrimary = Color(0xFF0F172A);
  static const textMuted = Color(0xFF6B7280);
  static const borderSoft = Color(0xFFD9EFF2);
}

ThemeData buildAppTheme() {
  final base = ThemeData.light();

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      primary: AppColors.accent,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
      fontFamily: 'monospace',
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.accent, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    ),
  );
}
