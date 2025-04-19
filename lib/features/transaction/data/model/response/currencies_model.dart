import 'dart:convert';

class CurrenciesModel {
  List<dynamic>? data;

  CurrenciesModel({this.data});

  @override
  String toString() => 'CurrenciesModel(data: $data)';

  factory CurrenciesModel.fromMap(Map<String, dynamic> data) {
    return CurrenciesModel(
      data: data['data'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'data': data,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CurrenciesModel].
  factory CurrenciesModel.fromJson(String data) {
    return CurrenciesModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CurrenciesModel] to a JSON string.
  String toJson() => json.encode(toMap());

  CurrenciesModel copyWith({
    List<dynamic>? data,
  }) {
    return CurrenciesModel(
      data: data ?? this.data,
    );
  }
}
