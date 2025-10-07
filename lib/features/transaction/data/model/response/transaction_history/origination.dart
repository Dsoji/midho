import 'dart:convert';

class Origination {
  num? rate;
  num? amount;

  Origination({this.rate, this.amount});

  @override
  String toString() => 'Origination(rate: $rate, amount: $amount)';

  factory Origination.fromMap(Map<String, dynamic> data) => Origination(
        rate: data['rate'] as int?,
        amount: data['amount'] as num?,
      );

  Map<String, dynamic> toMap() => {
        'rate': rate,
        'amount': amount,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Origination].
  factory Origination.fromJson(String data) {
    return Origination.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Origination] to a JSON string.
  String toJson() => json.encode(toMap());

  Origination copyWith({
    int? rate,
    num? amount,
  }) {
    return Origination(
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
    );
  }
}
