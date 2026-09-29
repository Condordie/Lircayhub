import 'package:flutter/material.dart';

import '../../core/enums/trail_difficulty.dart';
import '../theme/enum_visuals.dart';

class DifficultyChip extends StatelessWidget {
  const DifficultyChip({super.key, required this.difficulty});

  final TrailDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = difficulty.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        difficulty.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
