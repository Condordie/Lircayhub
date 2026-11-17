import 'dart:convert';

import '../../models/qa_instrument.dart';
import '../../models/qa_submission.dart';

/// Arma el reporte que se envía por el selector de compartir:
/// resumen y el mismo contenido en JSON (evidencia auditable).
String buildQaReport({
  required QaInstrument instrument,
  required QaSubmission submission,
}) {
  String two(int n) => n.toString().padLeft(2, '0');
  final d = submission.createdAt;
  final date =
      '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';

  double avg(List<QaQuestion> qs) {
    if (qs.isEmpty) return 0;
    final sum = qs.fold<int>(0, (s, q) => s + (submission.answers[q.id] ?? 0));
    return sum / qs.length;
  }

  final b = StringBuffer()
    ..writeln('EVALUACIÓN BETA · ${instrument.nombre}')
    ..writeln('ID: ${submission.id}')
    ..writeln('Fecha: $date')
    ..writeln('Perfil: ${submission.profileName}')
    ..writeln();

  void section(String title, List<QaQuestion> qs) {
    b.writeln('$title (promedio ${avg(qs).toStringAsFixed(1)}/5)');
    for (final q in qs) {
      b.writeln('- ${q.id}: ${submission.answers[q.id] ?? 0}/5 · ${q.titulo}');
    }
    b.writeln();
  }

  section('CUMPLIMIENTO DE HISTORIAS DE USUARIO', instrument.cumplimientoHu);
  section('USABILIDAD Y EXPERIENCIA', instrument.usabilidad);

  b
    ..writeln('Comentario: '
        '${submission.comment.isEmpty ? '(sin comentario)' : submission.comment}')
    ..writeln()
    ..writeln('--- JSON ---')
    ..writeln(const JsonEncoder.withIndent('  ').convert(submission.toJson()));

  return b.toString();
}