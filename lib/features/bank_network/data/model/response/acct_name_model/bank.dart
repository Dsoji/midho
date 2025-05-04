import 'dart:convert';

class Bank {
  String? code;
  String? name;

  Bank({this.code, this.name});

  @override
  String toString() => 'Bank(code: $code, name: $name)';

  factory Bank.fromMap(Map<String, dynamic> data) => Bank(
        code: data['code'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Bank].
  factory Bank.fromJson(String data) {
    return Bank.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Bank] to a JSON string.
  String toJson() => json.encode(toMap());

  Bank copyWith({
    String? code,
    String? name,
  }) {
    return Bank(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}
