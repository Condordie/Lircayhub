import '../core/enums/alert_type.dart';

class TrailAlert {
  const TrailAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.isActive = true,
  });

  final String id;
  final AlertType type;
  final String title;
  final String message;
  final DateTime time;
  final bool isActive;
}
