import 'dart:convert';

import 'datum.dart';

class NotifcationList {
  List<Datum>? data;

  NotifcationList({this.data});

  @override
  String toString() => 'NotifcationList(data: $data)';

  factory NotifcationList.fromMap(Map<String, dynamic> data) {
    return NotifcationList(
      data: (data['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NotifcationList].
  factory NotifcationList.fromJson(String data) {
    return NotifcationList.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NotifcationList] to a JSON string.
  String toJson() => json.encode(toMap());

  NotifcationList copyWith({
    List<Datum>? data,
  }) {
    return NotifcationList(
      data: data ?? this.data,
    );
  }
}
