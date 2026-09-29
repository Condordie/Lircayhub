import 'package:flutter/foundation.dart';

import '../../models/trail_alert.dart';
import '../data/mock_data.dart';
import '../enums/alert_type.dart';

/// Avisos dentro de la app (simulados). Las notificaciones del sistema
/// operativo se conectan en la fase 3.
class NotificationService extends ChangeNotifier {
  final List<TrailAlert> _alerts = List.of(MockData.alerts);
  int _counter = 0;
  bool enabled = true;

  List<TrailAlert> get alerts => List.unmodifiable(_alerts);

  void push(TrailAlert alert) {
    if (!enabled) return;
    _alerts.insert(0, alert);
    notifyListeners();
  }

  void dismiss(String id) {
    _alerts.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  /// Simula la llegada de un aviso de clima cerca de la ruta.
  void simulateWeatherAlert() {
    _counter++;
    push(
      TrailAlert(
        id: 'sim$_counter',
        type: AlertType.weather,
        title: 'Cambio de clima cerca de tu ruta',
        message:
            'Se aproxima nubosidad densa. Considera adelantar tu regreso.',
        time: DateTime.now(),
      ),
    );
  }
}
