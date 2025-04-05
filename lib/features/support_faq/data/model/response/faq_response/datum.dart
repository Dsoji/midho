import 'dart:convert';

class Datum {
  String? id;
  String? question;
  String? answer;
  List<dynamic>? files;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.question,
    this.answer,
    this.files,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Datum(id: $id, question: $question, answer: $answer, files: $files, deleted: $deleted, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
        id: data['_id'] as String?,
        question: data['question'] as String?,
        answer: data['answer'] as String?,
        files: data['files'] as List<dynamic>?,
        deleted: data['deleted'] as bool?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as int?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'question': question,
        'answer': answer,
        'files': files,
        'deleted': deleted,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  Datum copyWith({
    String? id,
    String? question,
    String? answer,
    List<String>? files,
    bool? deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Datum(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      files: files ?? this.files,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
