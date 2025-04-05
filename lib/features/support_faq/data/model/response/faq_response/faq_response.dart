import 'dart:convert';

import 'datum.dart';

class FaqResponse {
  List<Datum>? data;

  FaqResponse({this.data});

  @override
  String toString() => 'FaqResponse(data: $data)';

  factory FaqResponse.fromMap(Map<String, dynamic> data) => FaqResponse(
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [FaqResponse].
  factory FaqResponse.fromJson(String data) {
    return FaqResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [FaqResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  FaqResponse copyWith({
    List<Datum>? data,
  }) {
    return FaqResponse(
      data: data ?? this.data,
    );
  }
}
