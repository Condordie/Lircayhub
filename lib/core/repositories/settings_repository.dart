import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_settings.dart';
import '../data/mock_data.dart';

abstract class SettingsRepository {
  Future<UserSettings> load();
  Future<void> save(UserSettings settings);
}

/// Persistencia clave-valor (JSON en shared_preferences).
class SharedPrefsSettingsRepository implements SettingsRepository {
  SharedPrefsSettingsRepository(this._prefs);

  static const String _key = 'user_settings_v1';
  final SharedPreferences _prefs;

  UserSettings get _defaults =>
      UserSettings(contacts: List.of(MockData.emergencyContacts));

  @override
  Future<UserSettings> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return _defaults; // primera vez que se abre la app
    try {
      return UserSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('SettingsRepository.load: $e');
      return _defaults; // dato corrupto: se parte de cero sin cerrar la app
    }
  }

  @override
  Future<void> save(UserSettings settings) async {
    await _prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}