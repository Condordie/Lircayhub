import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Nunito';

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.forest,
      primary: AppColors.forest,
      secondary: AppColors.sunset,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: _withVariableWeights(ThemeData.light().textTheme),
      scaffoldBackgroundColor: AppColors.sand,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.forest,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forest,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.moss.withAlpha(90),
      ),
    );
  }

  /// Nunito se incluye como fuente variable: el eje 'wght' sigue al peso de
  /// cada estilo del tema.
  static TextTheme _withVariableWeights(TextTheme t) {
    TextStyle? v(TextStyle? s) {
      if (s == null) return null;
      final weight = (s.fontWeight?.value ?? 400).toDouble();
      return s.copyWith(fontVariations: [FontVariation('wght', weight)]);
    }

    return TextTheme(
      displayLarge: v(t.displayLarge),
      displayMedium: v(t.displayMedium),
      displaySmall: v(t.displaySmall),
      headlineLarge: v(t.headlineLarge),
      headlineMedium: v(t.headlineMedium),
      headlineSmall: v(t.headlineSmall),
      titleLarge: v(t.titleLarge),
      titleMedium: v(t.titleMedium),
      titleSmall: v(t.titleSmall),
      bodyLarge: v(t.bodyLarge),
      bodyMedium: v(t.bodyMedium),
      bodySmall: v(t.bodySmall),
      labelLarge: v(t.labelLarge),
      labelMedium: v(t.labelMedium),
      labelSmall: v(t.labelSmall),
    );
  }
}
