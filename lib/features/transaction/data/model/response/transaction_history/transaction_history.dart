import 'dart:convert';

import 'datum.dart';
import 'pagination.dart';

class TransactionHistory {
  List<Datum>? data;
  Pagination? pagination;

  TransactionHistory({this.data, this.pagination});

  @override
  String toString() {
    return 'TransactionHistory(data: $data, pagination: $pagination)';
  }

  factory TransactionHistory.fromMap(Map<String, dynamic> data) {
    return TransactionHistory(
      data: (data['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
          .toList(),
      pagination: data['pagination'] == null
          ? null
          : Pagination.fromMap(data['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
        'pagination': pagination?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TransactionHistory].
  factory TransactionHistory.fromJson(String data) {
    return TransactionHistory.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TransactionHistory] to a JSON string.
  String toJson() => json.encode(toMap());

  TransactionHistory copyWith({
    List<Datum>? data,
    Pagination? pagination,
  }) {
    return TransactionHistory(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}
