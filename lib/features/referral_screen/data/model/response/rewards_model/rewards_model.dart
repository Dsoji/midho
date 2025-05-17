import 'dart:convert';

import 'datum.dart';
import 'pagination.dart';

class RewardsModel {
  List<Datum>? data;
  Pagination? pagination;

  RewardsModel({this.data, this.pagination});

  @override
  String toString() => 'RewardsModel(data: $data, pagination: $pagination)';

  factory RewardsModel.fromMap(Map data) {
    final normalizedData = Map<String, dynamic>.from(data);

    return RewardsModel(
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
  /// Parses the string and returns the resulting Json object as [RewardsModel].
  factory RewardsModel.fromJson(String data) {
    return RewardsModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RewardsModel] to a JSON string.
  String toJson() => json.encode(toMap());

  RewardsModel copyWith({
    List<Datum>? data,
    Pagination? pagination,
  }) {
    return RewardsModel(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}
