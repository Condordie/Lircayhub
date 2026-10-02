import 'package:flutter/foundation.dart';

import '../../models/emergency_contact.dart';
import '../data/mock_data.dart';
import '../enums/haptic_pattern.dart';
import 'haptic_service.dart';
import 'notification_service.dart';
import 'voice_service.dart';

/// Ajustes y datos de seguridad del usuario.
class AppSettings extends ChangeNotifier {
  AppSettings({
    required this._haptic,
    required this._voice,
    required this._notifications,
  });

  final HapticService _haptic;
  final VoiceService _voice;
  final NotificationService _notifications;

  bool _hapticEnabled = true;
  bool _voiceEnabled = true;
  bool _notificationsEnabled = true;
  bool _fallDetectionEnabled = true;
  bool _notifyIfLate = true;
  int _deadlineHour = 18;
  int _deadlineMinute = 0;
  final List<EmergencyContact> _contacts = List.of(MockData.emergencyContacts);

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

  void setHapticEnabled(bool value) {
    _hapticEnabled = value;
    _haptic.enabled = value;
    if (value) _haptic.play(HapticPattern.straight);
    notifyListeners();
  }

  void setVoiceEnabled(bool value) {
    _voiceEnabled = value;
    _voice.enabled = value;
    if (value) _voice.speak('Guía por voz activada');
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _notifications.enabled = value;
    notifyListeners();
  }

  void setFallDetectionEnabled(bool value) {
    _fallDetectionEnabled = value;
    notifyListeners();
  }

  void setNotifyIfLate(bool value) {
    _notifyIfLate = value;
    notifyListeners();
  }

  void setDeadline(int hour, int minute) {
    _deadlineHour = hour;
    _deadlineMinute = minute;
    notifyListeners();
  }

  void addContact(EmergencyContact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void removeContact(EmergencyContact contact) {
    _contacts.remove(contact);
    notifyListeners();
  }
}
