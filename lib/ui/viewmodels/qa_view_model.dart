import 'package:flutter/foundation.dart';

import '../../core/repositories/qa_repository.dart';
import '../../core/services/share_service.dart';
import '../../core/utils/qa_report.dart';
import '../../models/qa_instrument.dart';
import '../../models/qa_submission.dart';

enum QaSubmitResult { invalid, shared, savedOnly }

class QaViewModel extends ChangeNotifier {
    QaViewModel({
    required this._repository,
    required this._share,
  }) {
    _load();
  }

  final QaRepository _repository;
  final ShareService _share;

  QaInstrument? _instrument;
  List<QaSubmission> _submissions = const [];
  final Map<String, int> _answers = {};
  String? _profileId;
  String _comment = '';
  String? _error;
  bool _loading = true;
  bool _submitting = false;
  bool _disposed = false;

  /// Cambia al limpiar el formulario para reiniciar el campo de comentario.
  int _formVersion = 0;

  QaInstrument? get instrument => _instrument;
  bool get loading => _loading;
  bool get submitting => _submitting;
  String? get error => _error;
  String? get profileId => _profileId;
  int get formVersion => _formVersion;
  int get answeredCount => _answers.length;
  int get totalQuestions => _instrument?.allQuestions.length ?? 0;
  int get submissionsCount => _submissions.length;

  bool get canSubmit =>
      !_submitting &&
      _instrument != null &&
      _profileId != null &&
      totalQuestions > 0 &&
      answeredCount == totalQuestions;

  int answerFor(String questionId) => _answers[questionId] ?? 0;

  int countForProfile(String profileId) =>
      _submissions.where((s) => s.profileId == profileId).length;

  Future<void> _load() async {
    try {
      _instrument = await _repository.loadInstrument();
      _submissions = await _repository.loadSubmissions();
    } catch (e) {
      debugPrint('QaViewModel.load: $e');
      _error = 'No se pudo cargar el instrumento de evaluación.';
    }
    _loading = false;
    _notify();
  }

  void selectProfile(String id) {
    _profileId = id;
    _notify();
  }

  void setAnswer(String questionId, int stars) {
    _answers[questionId] = stars;
    _notify();
  }

  void setComment(String value) => _comment = value;

  /// Guarda el comprobante local y luego abre el selector nativo de compartir.
  Future<QaSubmitResult> submit() async {
    final instrument = _instrument;
    if (!canSubmit || instrument == null) return QaSubmitResult.invalid;

    _submitting = true;
    _notify();

    final profile = instrument.perfiles.firstWhere((p) => p.id == _profileId);
    final now = DateTime.now();
    final submission = QaSubmission(
      id: now.millisecondsSinceEpoch.toString(),
      createdAt: now,
      profileId: profile.id,
      profileName: profile.nombre,
      answers: Map.of(_answers),
      comment: _comment.trim(),
    );

    try {
      await _repository.saveSubmission(submission);
      _submissions = await _repository.loadSubmissions();
    } catch (e) {
      debugPrint('QaViewModel.save: $e');
    }

    final ok = await _share.shareText(
      text: buildQaReport(instrument: instrument, submission: submission),
      subject: 'Evaluación Beta · ${instrument.nombre}',
    );

    _answers.clear();
    _profileId = null;
    _comment = '';
    _formVersion++;
    _submitting = false;
    _notify();
    return ok ? QaSubmitResult.shared : QaSubmitResult.savedOnly;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}