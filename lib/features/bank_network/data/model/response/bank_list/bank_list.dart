import 'dart:convert';

class BanlList {
  String? code;
  String? name;
  num? strength;
  String? status;

  BanlList({this.code, this.name, this.strength, this.status});

  @override
  String toString() {
    return 'BanlList(code: $code, name: $name, strength: $strength, status: $status)';
  }

  factory BanlList.fromMap(Map<String, dynamic> data) => BanlList(
        code: data['code'] as String?,
        name: data['name'] as String?,
        strength: data['strength'] as num?,
        status: data['status'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'name': name,
        'strength': strength,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BanlList].
  factory BanlList.fromJson(String data) {
    return BanlList.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BanlList] to a JSON string.
  String toJson() => json.encode(toMap());

  BanlList copyWith({
    String? code,
    String? name,
    num? strength,
    String? status,
  }) {
    return BanlList(
      code: code ?? this.code,
      name: name ?? this.name,
      strength: strength ?? this.strength,
      status: status ?? this.status,
    );
  }
}
