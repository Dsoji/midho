import 'dart:convert';

class Amount {
  String? type;
  dynamic fixed;
  String? minimum;
  String? maximum;

  Amount({this.type, this.fixed, this.minimum, this.maximum});

  @override
  String toString() {
    return 'Amount(type: $type, fixed: $fixed, minimum: $minimum, maximum: $maximum)';
  }

  factory Amount.fromMap(Map<String, dynamic> data) => Amount(
        type: data['type'] as String?,
        fixed: data['fixed'] as dynamic,
        minimum: data['minimum'] as String?,
        maximum: data['maximum'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'fixed': fixed,
        'minimum': minimum,
        'maximum': maximum,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Amount].
  factory Amount.fromJson(String data) {
    return Amount.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Amount] to a JSON string.
  String toJson() => json.encode(toMap());

  Amount copyWith({
    String? type,
    dynamic fixed,
    String? minimum,
    String? maximum,
  }) {
    return Amount(
      type: type ?? this.type,
      fixed: fixed ?? this.fixed,
      minimum: minimum ?? this.minimum,
      maximum: maximum ?? this.maximum,
    );
  }
}
