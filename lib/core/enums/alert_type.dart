import 'haptic_pattern.dart';

enum AlertType {
  weather('Clima', HapticPattern.alert),
  trailClosure('Cierre de sendero', HapticPattern.alert),
  returnDeadline('Hora límite de regreso', HapticPattern.alert),
  fallDetected('Posible caída', HapticPattern.sos);

  const AlertType(this.label, this.haptic);
  final String label;
  final HapticPattern haptic;
}
