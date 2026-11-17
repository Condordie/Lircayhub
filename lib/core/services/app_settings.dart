import 'package:flutter/foundation.dart';

import '../../models/emergency_contact.dart';
import '../../models/user_settings.dart';
import '../enums/haptic_pattern.dart';
import '../repositories/settings_repository.dart';
import 'haptic_service.dart';
import 'notification_service.dart';
import 'voice_service.dart';

/// Ajustes y datos de seguridad del usuario. Se hidratan desde el
/// repositorio al iniciar y se guardan tras cada cambio.
class AppSettings extends ChangeNotifier {
  AppSettings({
    required this._haptic,
    required this._voice,
    required this._notifications,
    required this._repository,
  });

  final HapticService _haptic;
  final VoiceService _voice;
  final NotificationService _notifications;
  final SettingsRepository _repository;

  bool _hapticEnabled = true;
  bool _voiceEnabled = true;
  bool _notificationsEnabled = true;
  bool _fallDetectionEnabled = true;
  bool _notifyIfLate = true;
  int _deadlineHour = 18;
  int _deadlineMinute = 0;
  final List<EmergencyContact> _contacts = [];

  bool get hapticEnabled => _hapticEnabled;
  bool get voiceEnabled => _voiceEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get fallDetectionEnabled => _fallDetectionEnabled;
  bool get notifyIfLate => _notifyIfLate;
  int get deadlineHour => _deadlineHour;
  int get deadlineMinute => _deadlineMinute;
  List<EmergencyContact> get contacts => List.unmodifiable(_contacts);

  String get deadlineLabel =>
      '${_deadlineHour.toString().padLeft(2, '0')}:${_deadlineMinute.toString().padLeft(2, '0')}';

  /// Carga lo guardado y lo aplica a los servicios (sin sonidos ni vibración).
  Future<void> load() async {
    try {
      final s = await _repository.load();
      _hapticEnabled = s.hapticEnabled;
      _voiceEnabled = s.voiceEnabled;
      _notificationsEnabled = s.notificationsEnabled;
      _fallDetectionEnabled = s.fallDetectionEnabled;
      _notifyIfLate = s.notifyIfLate;
      _deadlineHour = s.deadlineHour;
      _deadlineMinute = s.deadlineMinute;
      _contacts
        ..clear()
        ..addAll(s.contacts);
      _haptic.enabled = _hapticEnabled;
      _voice.enabled = _voiceEnabled;
      _notifications.enabled = _notificationsEnabled;
    } catch (e) {
      debugPrint('AppSettings.load: $e');
    }
    notifyListeners();
  }

  void _persist() {
    _repository
        .save(
          UserSettings(
            hapticEnabled: _hapticEnabled,
            voiceEnabled: _voiceEnabled,
            notificationsEnabled: _notificationsEnabled,
            fallDetectionEnabled: _fallDetectionEnabled,
            notifyIfLate: _notifyIfLate,
            deadlineHour: _deadlineHour,
            deadlineMinute: _deadlineMinute,
            contacts: List.of(_contacts),
          ),
        )
        .catchError((Object e) => debugPrint('AppSettings.save: $e'));
  }

  void _commit() {
    _persist();
    notifyListeners();
  }

  void setHapticEnabled(bool value) {
    _hapticEnabled = value;
    _haptic.enabled = value;
    if (value) _haptic.play(HapticPattern.straight);
    _commit();
  }

  void setVoiceEnabled(bool value) {
    _voiceEnabled = value;
    _voice.enabled = value;
    if (value) _voice.speak('Guía por voz activada');
    _commit();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _notifications.enabled = value;
    _commit();
  }

  void setFallDetectionEnabled(bool value) {
    _fallDetectionEnabled = value;
    _commit();
  }

  void setNotifyIfLate(bool value) {
    _notifyIfLate = value;
    _commit();
  }

  void setDeadline(int hour, int minute) {
    _deadlineHour = hour;
    _deadlineMinute = minute;
    _commit();
  }

  void addContact(EmergencyContact contact) {
    _contacts.add(contact);
    _commit();
  }

  void removeContact(EmergencyContact contact) {
    _contacts.remove(contact);
    _commit();
  }
}