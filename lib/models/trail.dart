import '../core/enums/trail_difficulty.dart';
import 'waypoint.dart';

class Trail {
  const Trail({
    required this.id,
    required this.name,
    required this.zone,
    required this.description,
    required this.difficulty,
    required this.distanceKm,
    required this.elevationGainM,
    required this.durationMinutes,
    required this.imageAsset,
    required this.waypoints,
    this.highlights = const [],
  });

  final String id;
  final String name;
  final String zone;
  final String description;
  final TrailDifficulty difficulty;
  final double distanceKm;
  final int elevationGainM;
  final int durationMinutes;

  /// Ruta del asset de la foto (ver AppAssets).
  final String imageAsset;
  final List<Waypoint> waypoints;
  final List<String> highlights;

  String get durationLabel {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    if (h == 0) return '$m min';
    if (m == 0) return '$h h';
    return '$h h $m min';
  }
}
