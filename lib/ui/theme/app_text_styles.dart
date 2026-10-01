import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Estilos de texto sobre la fuente variable Nunito. Cada peso se fija con el
/// eje 'wght' para que se vea igual en todas las plataformas.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle semiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle extraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontVariations: [FontVariation('wght', 800)],
  );

  static const TextStyle headline = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    fontVariations: [FontVariation('wght', 700)],
    color: AppColors.ink,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
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
    fontVariations: [FontVariation('wght', 800)],
    color: Colors.white,
  );
}
