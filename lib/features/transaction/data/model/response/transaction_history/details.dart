import 'dart:convert';

class Details {
  String? customerId;
  String? customerName;

  Details({this.customerId, this.customerName});

  @override
  String toString() {
    return 'Details(customerId: $customerId, customerName: $customerName)';
  }

  factory Details.fromMap(Map<String, dynamic> data) => Details(
        customerId: data['customerId'] as String?,
        customerName: data['customerName'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'customerId': customerId,
        'customerName': customerName,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Details].
  factory Details.fromJson(String data) {
    return Details.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Details] to a JSON string.
  String toJson() => json.encode(toMap());

  Details copyWith({
    String? customerId,
    String? customerName,
  }) {
    return Details(
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
    );
  }
}
