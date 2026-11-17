class QaQuestion {
  const QaQuestion({
    required this.id,
    required this.titulo,
    required this.min,
    required this.max,
  });

  final String id;
  final String titulo;
  final String min;
  final String max;

  factory QaQuestion.fromJson(Map<String, dynamic> json) => QaQuestion(
        id: json['id'] as String,
        titulo: json['titulo'] as String,
        min: json['min'] as String,
        max: json['max'] as String,
      );
}

class QaProfile {
  const QaProfile({required this.id, required this.nombre});

  final String id;
  final String nombre;

  factory QaProfile.fromJson(Map<String, dynamic> json) => QaProfile(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
      );
}

/// Instrumento de evaluación leído desde assets/qa/qa_instrument.json.
class QaInstrument {
  const QaInstrument({
    required this.nombre,
    required this.perfiles,
    required this.cumplimientoHu,
    required this.usabilidad,
  });

  final String nombre;
  final List<QaProfile> perfiles;
  final List<QaQuestion> cumplimientoHu;
  final List<QaQuestion> usabilidad;

  List<QaQuestion> get allQuestions => [...cumplimientoHu, ...usabilidad];

  factory QaInstrument.fromJson(Map<String, dynamic> json) {
    List<QaQuestion> questions(String key) => (json[key] as List<dynamic>)
        .map((e) => QaQuestion.fromJson(e as Map<String, dynamic>))
        .toList();

    return QaInstrument(
      nombre: json['instrumento'] as String,
      perfiles: (json['perfiles'] as List<dynamic>)
          .map((e) => QaProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      cumplimientoHu: questions('cumplimiento_hu'),
      usabilidad: questions('usabilidad'),
    );
  }
}