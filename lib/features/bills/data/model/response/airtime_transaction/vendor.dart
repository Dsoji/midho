import 'dart:convert';

class Vendor {
  String? id;
  String? name;

  Vendor({this.id, this.name});

  @override
  String toString() => 'Vendor(id: $id, name: $name)';

  factory Vendor.fromMap(Map<String, dynamic> data) => Vendor(
        id: data['id'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Vendor].
  factory Vendor.fromJson(String data) {
    return Vendor.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Vendor] to a JSON string.
  String toJson() => json.encode(toMap());

  Vendor copyWith({
    String? id,
    String? name,
  }) {
    return Vendor(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
