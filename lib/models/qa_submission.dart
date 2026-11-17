/// Una evaluación completada por un usuario de prueba.
class QaSubmission {
  const QaSubmission({
    required this.id,
    required this.createdAt,
    required this.profileId,
    required this.profileName,
    required this.answers,
    required this.comment,
  });

  final String id;
  final DateTime createdAt;
  final String profileId;
  final String profileName;

  /// id de pregunta -> estrellas (1 a 5).
  final Map<String, int> answers;
  final String comment;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'profileId': profileId,
        'profileName': profileName,
        'answers': answers,
        'comment': comment,
      };

  factory QaSubmission.fromJson(Map<String, dynamic> json) => QaSubmission(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        profileId: json['profileId'] as String,
        profileName: json['profileName'] as String,
        answers: (json['answers'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as int)),
        comment: json['comment'] as String? ?? '',
      );
}