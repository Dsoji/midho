import 'dart:convert';

class AirtimeElectricModel {
  String? name;
  String? logo;
  String? id;
  int? min;
  int? max;

  AirtimeElectricModel({this.name, this.logo, this.id, this.min, this.max});

  @override
  String toString() {
    return 'AirtimeElectricModel(name: $name, logo: $logo, id: $id, min: $min, max: $max)';
  }

  factory AirtimeElectricModel.fromMap(Map<String, dynamic> data) {
    return AirtimeElectricModel(
      name: data['name'] as String?,
      logo: data['logo'] as String?,
      id: data['id'] as String?,
      min: data['min'] as int?,
      max: data['max'] as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'logo': logo,
        'id': id,
        'min': min,
        'max': max,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AirtimeElectricModel].
  factory AirtimeElectricModel.fromJson(String data) {
    return AirtimeElectricModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AirtimeElectricModel] to a JSON string.
  String toJson() => json.encode(toMap());

  AirtimeElectricModel copyWith({
    String? name,
    String? logo,
    String? id,
    int? min,
    int? max,
  }) {
    return AirtimeElectricModel(
      name: name ?? this.name,
      logo: logo ?? this.logo,
      id: id ?? this.id,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}
