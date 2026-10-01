import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/enums/alert_type.dart';
import '../../core/enums/haptic_pattern.dart';
import '../../core/enums/hike_status.dart';
import '../../core/enums/nav_cue.dart';
import '../../core/services/app_settings.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/voice_service.dart';
import '../../core/utils/formatters.dart';
import '../../models/emergency_contact.dart';
import '../../models/hike_session.dart';
import '../../models/trail.dart';
import '../../models/trail_alert.dart';
import '../../models/waypoint.dart';

/// Lógica de la caminata activa. El recorrido se simula: cada tramo dura
/// [legSeconds] segundos reales y al llegar a un punto se dispara su indicación.
class ActiveHikeViewModel extends ChangeNotifier {
  ActiveHikeViewModel({
    required Trail trail,
    required this._haptic,
    required this._voice,
    required this._notifications,
    required this._settings,
  })  : _session = HikeSession(trail: trail) {
    _start();
  }

  static const int legSeconds = 8;
  static const int fallSeconds = 10;

  final HapticService _haptic;
  final VoiceService _voice;
  final NotificationService _notifications;
  final AppSettings _settings;

  HikeSession _session;
  NavCue _cue = NavCue.straight;
  NavCue _routeCue = NavCue.straight;
  int _legTick = 0;

  Timer? _ticker;
  Timer? _fallTimer;
  Timer? _bannerTimer;
  Timer? _offTrailTimer;
  Timer? _listenTimer;

  bool _sosSent = false;
  bool _sosNoticeVisible = false;
  bool _fallActive = false;
  bool _isListening = false;
  bool _disposed = false;
  int _fallCountdown = fallSeconds;
  String? _lastMessage;
  String? _lastHeard;
  TrailAlert? _bannerAlert;

  // ---------- Estado expuesto ----------
  Trail get trail => _session.trail;
  HikeStatus get status => _session.status;
  Duration get elapsed => _session.elapsed;
  int get currentIndex => _session.currentWaypointIndex;
  Waypoint get currentWaypoint => _session.currentWaypoint;
  Waypoint? get nextWaypoint =>
      _session.isLastWaypoint ? null : trail.waypoints[currentIndex + 1];
  NavCue get cue => _cue;
  bool get completed => _session.isLastWaypoint;
  bool get sosSent => _sosSent;
  bool get sosNoticeVisible => _sosNoticeVisible;
  bool get fallActive => _fallActive;
  int get fallCountdown => _fallCountdown;
  bool get isListening => _isListening;
  String? get lastMessage => _lastMessage;
  String? get lastHeard => _lastHeard;
  TrailAlert? get bannerAlert => _bannerAlert;
  List<EmergencyContact> get contacts => _settings.contacts;

  double get legFraction =>
      _session.isLastWaypoint ? 0 : _legTick / legSeconds;

  double get distanceCoveredKm {
    final wps = trail.waypoints;
    final start = wps[currentIndex].distanceFromStartKm;
    if (_session.isLastWaypoint) return start;
    final end = wps[currentIndex + 1].distanceFromStartKm;
    return start + (end - start) * legFraction;
  }

  double get progress => trail.distanceKm == 0
      ? 0.0
      : (distanceCoveredKm / trail.distanceKm).clamp(0.0, 1.0).toDouble();

  double get remainingKm =>
      (trail.distanceKm - distanceCoveredKm).clamp(0.0, trail.distanceKm).toDouble();

  int get remainingMinutes => (trail.durationMinutes * (1 - progress)).round();

  // ---------- Ciclo de la caminata ----------
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void _say(String text) {
    _lastMessage = text;
    _voice.speak(text);
    _notify();
  }

  void _start() {
    _session = _session.copyWith(
      status: HikeStatus.inProgress,
      startedAt: DateTime.now(),
    );
    _cue = _session.currentWaypoint.cue;
    _routeCue = _cue;
    _haptic.play(HapticPattern.straight);
    _say('Caminata iniciada en ${trail.name}. Te guiaré con vibraciones y voz.');
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_session.status != HikeStatus.inProgress) return;
    _session = _session.copyWith(
      elapsed: _session.elapsed + const Duration(seconds: 1),
    );
    _legTick++;
    if (_legTick >= legSeconds) {
      _legTick = 0;
      _advance();
    }
    _notify();
  }

  void _advance() {
    _session = _session.copyWith(
      currentWaypointIndex: _session.currentWaypointIndex + 1,
    );
    _offTrailTimer?.cancel();
    final reachedEnd = _session.isLastWaypoint;
    final cue = reachedEnd ? NavCue.arrived : _session.currentWaypoint.cue;
    _cue = cue;
    _routeCue = cue;
    _haptic.play(cue.haptic);
    if (reachedEnd) {
      _ticker?.cancel();
      _session = _session.copyWith(status: HikeStatus.finished);
    }
    _say(cue.spokenText);
  }

  void togglePause() {
    if (status == HikeStatus.finished) return;
    final wasPaused = status == HikeStatus.paused;
    _session = _session.copyWith(
      status: wasPaused ? HikeStatus.inProgress : HikeStatus.paused,
    );
    _say(wasPaused ? 'Caminata reanudada' : 'Caminata en pausa');
  }

  void finish() {
    if (status == HikeStatus.finished) return;
    _ticker?.cancel();
    _offTrailTimer?.cancel();
    _session = _session.copyWith(status: HikeStatus.finished);
    _say('Caminata finalizada. Buen trabajo.');
  }

  // ---------- Emergencias ----------
  void triggerSos() {
    _fallTimer?.cancel();
    _fallActive = false;
    _sosSent = true;
    _sosNoticeVisible = true;
    _haptic.play(HapticPattern.sos);
    _say('Alerta de emergencia enviada a tus contactos con tu ubicación.');
  }

  void dismissSosNotice() {
    _sosNoticeVisible = false;
    _notify();
  }

  /// Devuelve false si la detección de caídas está desactivada en Seguridad.
  bool simulateFall() {
    if (!_settings.fallDetectionEnabled) return false;
    if (_fallActive) return true;
    _fallActive = true;
    _fallCountdown = fallSeconds;
    _haptic.play(HapticPattern.sos);
    _say('Detecté una caída. ¿Estás bien? Se enviará una alerta en diez segundos.');
    _fallTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _fallCountdown--;
      if (_fallCountdown <= 0) {
        t.cancel();
        triggerSos();
      } else {
        _haptic.play(HapticPattern.straight);
        _notify();
      }
    });
    return true;
  }

  void confirmOk() {
    _fallTimer?.cancel();
    _fallActive = false;
    _say('Me alegra que estés bien. Continuemos.');
  }

  void sendAlertNow() => triggerSos();

  // ---------- Desvío y avisos (demo) ----------
  void simulateOffTrail() {
    if (status != HikeStatus.inProgress) return;
    _cue = NavCue.offTrail;
    _haptic.play(NavCue.offTrail.haptic);
    _say(NavCue.offTrail.spokenText);
    _offTrailTimer?.cancel();
    _offTrailTimer = Timer(const Duration(seconds: 6), () {
      _cue = _routeCue;
      _say('Volviste al sendero. Sigue adelante.');
    });
  }

  void simulateWeatherAlert() {
    _showAlert(
      TrailAlert(
        id: 'hike${DateTime.now().millisecondsSinceEpoch}',
        type: AlertType.weather,
        title: 'Viento fuerte en la zona alta',
        message: 'Se esperan ráfagas en las próximas horas. Avanza con cuidado.',
        time: DateTime.now(),
      ),
    );
  }

  void simulateReturnDeadline() {
    _showAlert(
      TrailAlert(
        id: 'hike${DateTime.now().millisecondsSinceEpoch}',
        type: AlertType.returnDeadline,
        title: 'Quedan 30 minutos para tu hora límite',
        message: 'Tu hora límite de regreso es ${_settings.deadlineLabel}.',
        time: DateTime.now(),
      ),
    );
  }

  void _showAlert(TrailAlert alert) {
    if (!_notifications.enabled) return;
    _notifications.push(alert);
    _bannerAlert = alert;
    _haptic.play(alert.type.haptic);
    _voice.speak(alert.title);
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 7), () {
      _bannerAlert = null;
      _notify();
    });
    _notify();
  }

  // ---------- Voz ----------
  Future<void> toggleListening() async {
    if (_isListening) {
      await _stopListening();
      return;
    }
    final started = await _voice.startListening((text, isFinal) {
      _lastHeard = text;
      if (isFinal && text.trim().isNotEmpty) {
        _listenTimer?.cancel();
        _isListening = false;
        handleCommand(text);
      }
      _notify();
    });
    if (!started) {
      _lastMessage =
          'No pude activar el micrófono. Usa los comandos de abajo.';
      _notify();
      return;
    }
    _isListening = true;
    _lastHeard = null;
    _listenTimer?.cancel();
    _listenTimer = Timer(const Duration(seconds: 8), _stopListening);
    _notify();
  }

  Future<void> _stopListening() async {
    _listenTimer?.cancel();
    await _voice.stopListening();
    _isListening = false;
    _notify();
  }

  String _norm(String s) => s
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('¿', '')
      .replaceAll('?', '');

  void handleCommand(String raw) {
    final t = _norm(raw);
    if (t.contains('auxilio') ||
        t.contains('emergencia') ||
        t.contains('sos') ||
        t.contains('ayuda')) {
      triggerSos();
    } else if (t.contains('falta')) {
      _say(
        'Te faltan ${formatKm(remainingKm)} kilómetros, unos $remainingMinutes minutos.',
      );
    } else if (t.contains('donde estoy') || t.contains('ubicacion')) {
      final next = nextWaypoint;
      _say(
        next == null
            ? 'Estás en ${currentWaypoint.name}.'
            : 'Vas entre ${currentWaypoint.name} y ${next.name}.',
      );
    } else if (t.contains('repite') ||
        t.contains('repetir') ||
        t.contains('otra vez')) {
      _say(_cue.spokenText);
    } else if (t.contains('pausa') || t.contains('pausar')) {
      if (status == HikeStatus.inProgress) {
        togglePause();
      } else {
        _say('La caminata ya está en pausa.');
      }
    } else if (t.contains('continua') ||
        t.contains('reanuda') ||
        t.contains('seguir')) {
      if (status == HikeStatus.paused) {
        togglePause();
      } else {
        _say('La caminata ya está en curso.');
      }
    } else if (t.contains('termina') || t.contains('finaliza')) {
      finish();
    } else {
      _say(
        'No entendí. Prueba con: cuánto falta, dónde estoy, repite, pausa, continuar o auxilio.',
      );
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    _fallTimer?.cancel();
    _bannerTimer?.cancel();
    _offTrailTimer?.cancel();
    _listenTimer?.cancel();
    _voice.stopListening();
    _voice.stop();
    _haptic.stop();
    super.dispose();
  }
}
