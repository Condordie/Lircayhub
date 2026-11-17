import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/hike_record.dart';

abstract class HikeHistoryRepository {
  /// Más reciente primero.
  Future<List<HikeRecord>> loadAll();
  Future<void> add(HikeRecord record);
  Future<void> clear();

  /// Emite la lista completa cada vez que cambia (para vistas reactivas).
  Stream<List<HikeRecord>> get changes;
}

class SharedPrefsHikeHistoryRepository implements HikeHistoryRepository {
  SharedPrefsHikeHistoryRepository(this._prefs);

  static const String _key = 'hike_history_v1';
  static const int _maxRecords = 50;

  final SharedPreferences _prefs;
  final StreamController<List<HikeRecord>> _controller =
      StreamController<List<HikeRecord>>.broadcast();

  @override
  Stream<List<HikeRecord>> get changes => _controller.stream;

  @override
  Future<List<HikeRecord>> loadAll() async {
    final raw = _prefs.getStringList(_key) ?? const <String>[];
    final records = <HikeRecord>[];
    for (final item in raw) {
      try {
        records.add(
          HikeRecord.fromJson(jsonDecode(item) as Map<String, dynamic>),
        );
      } catch (e) {
        debugPrint('HikeHistoryRepository: registro ignorado ($e)');
      }
    }
    return records;
  }

  @override
  Future<void> add(HikeRecord record) async {
    final records = await loadAll();
    records.insert(0, record);
    if (records.length > _maxRecords) {
      records.removeRange(_maxRecords, records.length);
    }
    await _prefs.setStringList(
      _key,
      records.map((r) => jsonEncode(r.toJson())).toList(),
    );
    _controller.add(List.unmodifiable(records));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_key);
    _controller.add(const []);
  }
}