import 'dart:convert';

class PlatformDetails {
  String? id;
  String? iosVersion;
  String? androidVersion;
  bool? forceVersion;
  String? youtube;
  DateTime? createdAt;
  DateTime? updatedAt;

  PlatformDetails({
    this.id,
    this.iosVersion,
    this.androidVersion,
    this.forceVersion,
    this.youtube,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Data(id: $id, iosVersion: $iosVersion, androidVersion: $androidVersion, forceVersion: $forceVersion, youtube: $youtube, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  factory PlatformDetails.fromMap(Map<String, dynamic> data) => PlatformDetails(
        id: data['_id'] as String?,
        iosVersion: data['iosVersion'] as String?,
        androidVersion: data['androidVersion'] as String?,
        forceVersion: data['forceVersion'] as bool?,
        youtube: data['youtube'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'iosVersion': iosVersion,
        'androidVersion': androidVersion,
        'forceVersion': forceVersion,
        'youtube': youtube,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory PlatformDetails.fromJson(String data) {
    return PlatformDetails.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  PlatformDetails copyWith({
    String? id,
    String? iosVersion,
    String? androidVersion,
    bool? forceVersion,
    String? youtube,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlatformDetails(
      id: id ?? this.id,
      iosVersion: iosVersion ?? this.iosVersion,
      androidVersion: androidVersion ?? this.androidVersion,
      forceVersion: forceVersion ?? this.forceVersion,
      youtube: youtube ?? this.youtube,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
