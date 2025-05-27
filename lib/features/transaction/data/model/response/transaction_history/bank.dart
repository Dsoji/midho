import 'dart:convert';

class Bank {
  String? accountNumber;
  String? accountName;
  String? bankName;
  String? bankCode;
  String? id;

  Bank({
    this.accountNumber,
    this.accountName,
    this.bankName,
    this.bankCode,
    this.id,
  });

  @override
  String toString() {
    return 'Bank(accountNumber: $accountNumber, accountName: $accountName, bankName: $bankName, bankCode: $bankCode, id: $id)';
  }

  factory Bank.fromMap(Map<String, dynamic> data) => Bank(
        accountNumber: data['accountNumber'] as String?,
        accountName: data['accountName'] as String?,
        bankName: data['bankName'] as String?,
        bankCode: data['bankCode'] as String?,
        id: data['_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'accountNumber': accountNumber,
        'accountName': accountName,
        'bankName': bankName,
        'bankCode': bankCode,
        '_id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Bank].
  factory Bank.fromJson(String data) {
    return Bank.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Bank] to a JSON string.
  String toJson() => json.encode(toMap());

  Bank copyWith({
    String? accountNumber,
    String? accountName,
    String? bankName,
    String? bankCode,
    String? id,
  }) {
    return Bank(
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      id: id ?? this.id,
    );
  }
}
