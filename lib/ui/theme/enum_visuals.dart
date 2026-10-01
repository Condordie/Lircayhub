import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/enums/alert_type.dart';
import '../../core/enums/nav_cue.dart';
import '../../core/enums/trail_difficulty.dart';
import 'app_colors.dart';

/// Íconos (SVG) y colores de los enums. Se mantienen aquí para que core/ no dependa de Material.
extension TrailDifficultyVisuals on TrailDifficulty {
  Color get color => switch (this) {
        TrailDifficulty.easy => const Color(0xFF3E8E5A),
        TrailDifficulty.moderate => AppColors.sunset,
        TrailDifficulty.hard => AppColors.danger,
      };

  String get iconAsset => switch (this) {
        TrailDifficulty.easy => AppAssets.icDificultadFacil,
        TrailDifficulty.moderate => AppAssets.icDificultadFacil,
        TrailDifficulty.hard => AppAssets.icDificultadDificil,
      };
}

extension NavCueVisuals on NavCue {
  String get iconAsset => switch (this) {
        NavCue.straight => AppAssets.icRecto,
        NavCue.turnLeft => AppAssets.icGiroIzquierda,
        NavCue.turnRight => AppAssets.icGiroDerecha,
        NavCue.offTrail => AppAssets.icDesvio,
        NavCue.arrived => AppAssets.icLlegada,
      };
}

extension AlertTypeVisuals on AlertType {
  String get iconAsset => switch (this) {
        AlertType.weather => AppAssets.icClima,
        AlertType.trailClosure => AppAssets.icDesvio,
        AlertType.returnDeadline => AppAssets.icLlegada,
        AlertType.fallDetected => AppAssets.icDesvio,
      };

  Color get color => switch (this) {
        AlertType.weather => AppColors.river,
        AlertType.trailClosure => AppColors.danger,
        AlertType.returnDeadline => AppColors.sunset,
        AlertType.fallDetected => AppColors.danger,
      };
}
