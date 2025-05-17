import 'dart:convert';

import 'datum.dart';
import 'pagination.dart';

class ReferallModel {
  List<Datum>? data;
  Pagination? pagination;

  ReferallModel({this.data, this.pagination});

  @override
  String toString() => 'ReferallModel(data: $data, pagination: $pagination)';

  factory ReferallModel.fromMap(Map data) {
    final normalizedData = Map<String, dynamic>.from(data);

    return ReferallModel(
      data: (normalizedData['data'] as List?)
          ?.map((e) => Datum.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      pagination: normalizedData['pagination'] == null
          ? null
          : Pagination.fromMap(
              Map<String, dynamic>.from(normalizedData['pagination'] as Map)),
    );
  }

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
        'pagination': pagination?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ReferallModel].
  factory ReferallModel.fromJson(String data) {
    return ReferallModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ReferallModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ReferallModel copyWith({
    List<Datum>? data,
    Pagination? pagination,
  }) {
    return ReferallModel(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}
