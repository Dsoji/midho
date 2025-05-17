import 'dart:convert';

import 'bank.dart';

class AcctNameModel {
  String? accountName;
  String? accountNumber;
  Bank? bank;

  AcctNameModel({this.accountName, this.accountNumber, this.bank});

  @override
  String toString() {
    return 'AcctNameModel(accountName: $accountName, accountNumber: $accountNumber, bank: $bank)';
  }

  factory AcctNameModel.fromMap(Map<String, dynamic> data) => AcctNameModel(
        accountName: data['accountName'] as String?,
        accountNumber: data['accountNumber'] as String?,
        bank: data['bank'] == null
            ? null
            : Bank.fromMap(data['bank'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'accountName': accountName,
        'accountNumber': accountNumber,
        'bank': bank?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AcctNameModel].
  factory AcctNameModel.fromJson(String data) {
    return AcctNameModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AcctNameModel] to a JSON string.
  String toJson() => json.encode(toMap());

  AcctNameModel copyWith({
    String? accountName,
    String? accountNumber,
    Bank? bank,
  }) {
    return AcctNameModel(
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
    );
  }
}
