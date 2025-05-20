import 'dart:convert';

import 'product.dart';

class DataTvModel {
  String? name;
  String? logo;
  List<Product>? products;

  DataTvModel({this.name, this.logo, this.products});

  @override
  String toString() {
    return 'DataTvModel(name: $name, logo: $logo, products: $products)';
  }

  factory DataTvModel.fromMap(Map<String, dynamic> data) => DataTvModel(
        name: data['name'] as String?,
        logo: data['logo'] as String?,
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => Product.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'logo': logo,
        'products': products?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DataTvModel].
  factory DataTvModel.fromJson(String data) {
    return DataTvModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DataTvModel] to a JSON string.
  String toJson() => json.encode(toMap());

  DataTvModel copyWith({
    String? name,
    String? logo,
    List<Product>? products,
  }) {
    return DataTvModel(
      name: name ?? this.name,
      logo: logo ?? this.logo,
      products: products ?? this.products,
    );
  }
}
