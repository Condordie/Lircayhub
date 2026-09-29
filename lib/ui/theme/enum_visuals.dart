import 'package:flutter/material.dart';

import '../../core/enums/alert_type.dart';
import '../../core/enums/nav_cue.dart';
import '../../core/enums/trail_difficulty.dart';
import 'app_colors.dart';

/// Íconos y colores de los enums. Se mantienen aquí para que core/ no dependa de Material.
extension TrailDifficultyVisuals on TrailDifficulty {
  Color get color => switch (this) {
        TrailDifficulty.easy => const Color(0xFF3E8E5A),
        TrailDifficulty.moderate => AppColors.sunset,
        TrailDifficulty.hard => AppColors.danger,
      };
}

extension NavCueVisuals on NavCue {
  IconData get icon => switch (this) {
        NavCue.straight => Icons.arrow_upward,
        NavCue.turnLeft => Icons.turn_left,
        NavCue.turnRight => Icons.turn_right,
        NavCue.offTrail => Icons.warning_amber_rounded,
        NavCue.arrived => Icons.flag,
      };
}

extension AlertTypeVisuals on AlertType {
  IconData get icon => switch (this) {
        AlertType.weather => Icons.cloud_outlined,
        AlertType.trailClosure => Icons.block,
        AlertType.returnDeadline => Icons.schedule,
        AlertType.fallDetected => Icons.warning_amber_rounded,
      };

  Color get color => switch (this) {
        AlertType.weather => AppColors.river,
        AlertType.trailClosure => AppColors.danger,
        AlertType.returnDeadline => AppColors.sunset,
        AlertType.fallDetected => AppColors.danger,
      };
}
