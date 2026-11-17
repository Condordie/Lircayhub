import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/qa_instrument.dart';
import '../../models/qa_submission.dart';

abstract class QaRepository {
  Future<QaInstrument> loadInstrument();
  Future<List<QaSubmission>> loadSubmissions();
  Future<void> saveSubmission(QaSubmission submission);
}

/// Lee el instrumento desde assets y guarda cada evaluación en el teléfono
/// (comprobante local, además del envío por compartir).
class AssetQaRepository implements QaRepository {
  AssetQaRepository(this._prefs);

  static const String assetPath = 'assets/qa/qa_instrument.json';
  static const String _key = 'qa_submissions_v1';

  final SharedPreferences _prefs;

  @override
  Future<QaInstrument> loadInstrument() async {
    final raw = await rootBundle.loadString(assetPath);
    return QaInstrument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<List<QaSubmission>> loadSubmissions() async {
    final raw = _prefs.getStringList(_key) ?? const <String>[];
    final result = <QaSubmission>[];
    for (final item in raw) {
      try {
        result.add(
          QaSubmission.fromJson(jsonDecode(item) as Map<String, dynamic>),
        );
      } catch (e) {
        debugPrint('QaRepository: evaluación ignorada ($e)');
      }
    }
    return result;
  }

  @override
  Future<void> saveSubmission(QaSubmission submission) async {
    final current = _prefs.getStringList(_key) ?? <String>[];
    await _prefs.setStringList(
      _key,
      [...current, jsonEncode(submission.toJson())],
    );
  }
}