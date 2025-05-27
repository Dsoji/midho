import 'dart:convert';

import 'amount.dart';
import 'vendor.dart';

class Product {
  String? id;
  String? name;
  Vendor? vendor;
  Amount? amount;
  String? category;
  String? customerIdLabel;
  String? commissionPercentage;

  Product({
    this.id,
    this.name,
    this.vendor,
    this.amount,
    this.category,
    this.customerIdLabel,
    this.commissionPercentage,
  });

  @override
  String toString() {
    return 'Product(id: $id, name: $name, vendor: $vendor, amount: $amount, category: $category, customerIdLabel: $customerIdLabel, commissionPercentage: $commissionPercentage)';
  }

  factory Product.fromMap(Map<String, dynamic> data) => Product(
        id: data['id'] as String?,
        name: data['name'] as String?,
        vendor: data['vendor'] == null
            ? null
            : Vendor.fromMap(data['vendor'] as Map<String, dynamic>),
        amount: data['amount'] == null
            ? null
            : Amount.fromMap(data['amount'] as Map<String, dynamic>),
        category: data['category'] as String?,
        customerIdLabel: data['customerIdLabel'] as String?,
        commissionPercentage: data['commissionPercentage'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'vendor': vendor?.toMap(),
        'amount': amount?.toMap(),
        'category': category,
        'customerIdLabel': customerIdLabel,
        'commissionPercentage': commissionPercentage,
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
    Vendor? vendor,
    Amount? amount,
    String? category,
    String? customerIdLabel,
    String? commissionPercentage,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      vendor: vendor ?? this.vendor,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      customerIdLabel: customerIdLabel ?? this.customerIdLabel,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
    );
  }
}
