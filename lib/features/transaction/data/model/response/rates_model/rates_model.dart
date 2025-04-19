import 'dart:convert';

import 'datum.dart';
import 'pagination.dart';

class RatesModel {
  List<RateData>? data;
  Pagination? pagination;

  RatesModel({this.data, this.pagination});

  @override
  String toString() => 'RatesModel(data: $data, pagination: $pagination)';

  factory RatesModel.fromMap(Map<String, dynamic> data) => RatesModel(
        data: (data['data'] as List<dynamic>?)
            ?.map((e) => RateData.fromMap(e as Map<String, dynamic>))
            .toList(),
        pagination: data['pagination'] == null
            ? null
            : Pagination.fromMap(data['pagination'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
        'pagination': pagination?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RatesModel].
  factory RatesModel.fromJson(String data) {
    return RatesModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RatesModel] to a JSON string.
  String toJson() => json.encode(toMap());

  RatesModel copyWith({
    List<RateData>? data,
    Pagination? pagination,
  }) {
    return RatesModel(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}
