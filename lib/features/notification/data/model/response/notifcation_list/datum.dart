import 'dart:convert';

import 'entity.dart';

class Datum {
  String? id;
  String? user;
  String? title;
  String? description;
  bool? newl;
  String? type;
  Entity? entity;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.user,
    this.title,
    this.description,
    this.newl,
    this.type,
    this.entity,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Datum(id: $id, user: $user, title: $title, description: $description, new: $newl, type: $type, entity: $entity, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
        id: data['_id'] as String?,
        user: data['user'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        newl: data['new'] as bool?,
        type: data['type'] as String?,
        entity: data['entity'] == null
            ? null
            : Entity.fromMap(data['entity'] as Map<String, dynamic>),
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
        'user': user,
        'title': title,
        'description': description,
        'new': newl,
        'type': type,
        'entity': entity?.toMap(),
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
    String? user,
    String? title,
    String? description,
    bool? newl,
    String? type,
    Entity? entity,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Datum(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      description: description ?? this.description,
      newl: newl ?? this.newl,
      type: type ?? this.type,
      entity: entity ?? this.entity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
