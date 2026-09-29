import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    height: 1.4,
    color: AppColors.ink,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    color: AppColors.inkSoft,
  );

  /// Indicación grande de navegación durante la caminata.
  static const TextStyle cue = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
}
