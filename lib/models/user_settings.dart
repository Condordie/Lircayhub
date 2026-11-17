import 'emergency_contact.dart';

/// Foto de los ajustes del usuario (lo que se persiste).
class UserSettings {
  const UserSettings({
    this.hapticEnabled = true,
    this.voiceEnabled = true,
    this.notificationsEnabled = true,
    this.fallDetectionEnabled = true,
    this.notifyIfLate = true,
    this.deadlineHour = 18,
    this.deadlineMinute = 0,
    this.contacts = const [],
  });

  final bool hapticEnabled;
  final bool voiceEnabled;
  final bool notificationsEnabled;
  final bool fallDetectionEnabled;
  final bool notifyIfLate;
  final int deadlineHour;
  final int deadlineMinute;
  final List<EmergencyContact> contacts;

  Map<String, dynamic> toJson() => {
        'hapticEnabled': hapticEnabled,
        'voiceEnabled': voiceEnabled,
        'notificationsEnabled': notificationsEnabled,
        'fallDetectionEnabled': fallDetectionEnabled,
        'notifyIfLate': notifyIfLate,
        'deadlineHour': deadlineHour,
        'deadlineMinute': deadlineMinute,
        'contacts': contacts.map((c) => c.toJson()).toList(),
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        hapticEnabled: json['hapticEnabled'] as bool? ?? true,
        voiceEnabled: json['voiceEnabled'] as bool? ?? true,
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
        fallDetectionEnabled: json['fallDetectionEnabled'] as bool? ?? true,
        notifyIfLate: json['notifyIfLate'] as bool? ?? true,
        deadlineHour: json['deadlineHour'] as int? ?? 18,
        deadlineMinute: json['deadlineMinute'] as int? ?? 0,
        contacts: (json['contacts'] as List<dynamic>? ?? const [])
            .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}