import '../core/enums/hike_status.dart';
import 'trail.dart';
import 'waypoint.dart';

class HikeSession {
  const HikeSession({
    required this.trail,
    this.status = HikeStatus.notStarted,
    this.elapsed = Duration.zero,
    this.currentWaypointIndex = 0,
    this.startedAt,
  });

  final Trail trail;
  final HikeStatus status;
  final Duration elapsed;
  final int currentWaypointIndex;
  final DateTime? startedAt;

  Waypoint get currentWaypoint => trail.waypoints[currentWaypointIndex];

  double get distanceCoveredKm => currentWaypoint.distanceFromStartKm;

  double get progress => trail.distanceKm == 0
      ? 0
      : (distanceCoveredKm / trail.distanceKm).clamp(0.0, 1.0);

  bool get isLastWaypoint =>
      currentWaypointIndex >= trail.waypoints.length - 1;

  HikeSession copyWith({
    HikeStatus? status,
    Duration? elapsed,
    int? currentWaypointIndex,
    DateTime? startedAt,
  }) {
    return HikeSession(
      trail: trail,
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      currentWaypointIndex: currentWaypointIndex ?? this.currentWaypointIndex,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}
