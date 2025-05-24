import 'dart:convert';

class Product {
  String? id;
  String? name;
  int? amount;

  Product({this.id, this.name, this.amount});

  @override
  String toString() => 'Product(id: $id, name: $name, amount: $amount)';

  factory Product.fromMap(Map<String, dynamic> data) => Product(
        id: data['id'] as String?,
        name: data['name'] as String?,
        amount: data['amount'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'amount': amount,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory Product.fromJson(String data) {
    return Product.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Product] to a JSON string.
  String toJson() => json.encode(toMap());

  Product copyWith({
    String? id,
    String? name,
    int? amount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }
}
