import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/repositories/hike_history_repository.dart';
import '../../models/hike_record.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel(this._repository) {
    _init();
  }

  final HikeHistoryRepository _repository;
  StreamSubscription<List<HikeRecord>>? _sub;
  List<HikeRecord> _records = const [];
  bool _loading = true;
  bool _disposed = false;

  List<HikeRecord> get records => _records;
  bool get loading => _loading;
  bool get isEmpty => _records.isEmpty;

  int get completedCount => _records.where((r) => r.completed).length;

  double get totalKm =>
      _records.fold<double>(0, (sum, r) => sum + r.distanceKm);

  Future<void> _init() async {
    _sub = _repository.changes.listen((list) {
      _records = list;
      _notify();
    });
    try {
      _records = await _repository.loadAll();
    } catch (e) {
      debugPrint('HistoryViewModel: $e');
    }
    _loading = false;
    _notify();
  }

  Future<void> clear() => _repository.clear();

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _sub?.cancel();
    super.dispose();
  }
}