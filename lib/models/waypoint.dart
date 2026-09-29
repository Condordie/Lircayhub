import '../core/enums/nav_cue.dart';

class Waypoint {
  const Waypoint({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceFromStartKm,
    this.cue = NavCue.straight,
  });

  final String name;
  final double latitude;
  final double longitude;
  final double distanceFromStartKm;

  /// Indicación que se dispara al llegar a este punto.
  final NavCue cue;
}
