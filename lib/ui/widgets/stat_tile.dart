import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

/// Dato con ícono, valor y etiqueta. Acepta un ícono de Material o un SVG de assets.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    this.icon,
    this.svgAsset,
    required this.value,
    required this.label,
  }) : assert(icon != null || svgAsset != null);

  final IconData? icon;
  final String? svgAsset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (svgAsset != null)
          AppIcon(svgAsset!, size: 22, color: AppColors.forest)
        else
          Icon(icon, color: AppColors.forest, size: 22),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bold.copyWith(fontSize: 15)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
