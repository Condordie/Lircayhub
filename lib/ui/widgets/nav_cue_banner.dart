import 'package:flutter/material.dart';

import '../../core/enums/nav_cue.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/enum_visuals.dart';

/// Indicación grande de navegación; se vuelve roja cuando hay desvío.
class NavCueBanner extends StatelessWidget {
  const NavCueBanner({super.key, required this.cue, this.subtitle});

  final NavCue cue;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final warning = cue == NavCue.offTrail;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: warning ? AppColors.danger : AppColors.forest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(cue.icon, color: Colors.white, size: 52),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cue.label, style: AppTextStyles.cue),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
