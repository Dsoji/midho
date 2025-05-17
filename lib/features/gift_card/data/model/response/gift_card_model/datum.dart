import 'dart:convert';

class GiftCardData {
  String? id;
  String? icon;
  String? name;
  bool? active;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GiftCardData({
    this.id,
    this.icon,
    this.name,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Datum(id: $id, icon: $icon, name: $name, active: $active, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory GiftCardData.fromMap(Map<String, dynamic> data) => GiftCardData(
        id: data['_id'] as String?,
        icon: data['icon'] as String?,
        name: data['name'] as String?,
        active: data['active'] as bool?,
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
        'icon': icon,
        'name': name,
        'active': active,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory GiftCardData.fromJson(String data) {
    return GiftCardData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  GiftCardData copyWith({
    String? id,
    String? icon,
    String? name,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return GiftCardData(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
