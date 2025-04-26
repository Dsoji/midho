import 'dart:convert';

class Asset {
  String? id;
  String? type;
  double? rate;
  bool? active;
  String? assetFor;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Asset({
    this.id,
    this.type,
    this.rate,
    this.active,
    this.assetFor,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Asset(id: $id, type: $type, rate: $rate, active: $active, assetFor: $assetFor, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Asset.fromMap(Map<String, dynamic> data) => Asset(
        id: data['_id'] as String?,
        type: data['type'] as String?,
        rate: (data['rate'] as num?)?.toDouble(),
        active: data['active'] as bool?,
        assetFor: data['for'] as String?,
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
        'type': type,
        'rate': rate,
        'active': active,
        'for': assetFor,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Asset].
  factory Asset.fromJson(String data) {
    return Asset.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Asset] to a JSON string.
  String toJson() => json.encode(toMap());

  Asset copyWith({
    String? id,
    String? type,
    double? rate,
    bool? active,
    String? assetFor,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Asset(
      id: id ?? this.id,
      type: type ?? this.type,
      rate: rate ?? this.rate,
      active: active ?? this.active,
      assetFor: assetFor ?? this.assetFor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
