import 'package:flutter/material.dart';

import '../../core/enums/trail_difficulty.dart';
import '../theme/app_text_styles.dart';
import '../theme/enum_visuals.dart';
import 'app_icon.dart';

class DifficultyChip extends StatelessWidget {
  const DifficultyChip({super.key, required this.difficulty});

  final TrailDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = difficulty.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color.alphaBlend(color.withAlpha(35), Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(difficulty.iconAsset, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            difficulty.label,
            style: AppTextStyles.semiBold.copyWith(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
