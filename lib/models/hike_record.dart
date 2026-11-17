/// Registro de una caminata terminada
class HikeRecord {
  const HikeRecord({
    required this.trailId,
    required this.trailName,
    required this.startedAt,
    required this.elapsedSeconds,
    required this.distanceKm,
    required this.completed,
    required this.sosSent,
  });

  final String trailId;
  final String trailName;
  final DateTime startedAt;
  final int elapsedSeconds;
  final double distanceKm;
  final bool completed;
  final bool sosSent;

  Map<String, dynamic> toJson() => {
        'trailId': trailId,
        'trailName': trailName,
        'startedAt': startedAt.toIso8601String(),
        'elapsedSeconds': elapsedSeconds,
        'distanceKm': distanceKm,
        'completed': completed,
        'sosSent': sosSent,
      };

  factory HikeRecord.fromJson(Map<String, dynamic> json) => HikeRecord(
        trailId: json['trailId'] as String,
        trailName: json['trailName'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
        elapsedSeconds: json['elapsedSeconds'] as int,
        distanceKm: (json['distanceKm'] as num).toDouble(),
        completed: json['completed'] as bool,
        sosSent: json['sosSent'] as bool,
      );
}