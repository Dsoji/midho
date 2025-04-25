import 'dart:convert';

import 'datum.dart';

class GiftCardModel {
  List<GiftCardData>? data;

  GiftCardModel({this.data});

  @override
  String toString() => 'GiftCardModel(data: $data)';

  factory GiftCardModel.fromMap(Map<String, dynamic> data) => GiftCardModel(
        data: (data['data'] as List?)
            ?.map((e) => GiftCardData.fromMap(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GiftCardModel].
  factory GiftCardModel.fromJson(String data) {
    return GiftCardModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GiftCardModel] to a JSON string.
  String toJson() => json.encode(toMap());

  GiftCardModel copyWith({
    List<GiftCardData>? data,
  }) {
    return GiftCardModel(
      data: data ?? this.data,
    );
  }
}
