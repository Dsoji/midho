import 'dart:convert';

import 'asset.dart';
import 'metadata.dart';
import 'origination.dart';

class AirtimeTransaction {
  String? user;
  String? type;
  String? status;
  String? baseCurrency;
  String? exchangeCurrency;
  int? fee;
  int? rate;
  int? amount;
  List<dynamic>? files;
  List<dynamic>? proofs;
  String? accountNumber;
  bool? ecode;
  Metadata? metadata;
  Asset? asset;
  Origination? origination;
  bool? deleted;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  AirtimeTransaction({
    this.user,
    this.type,
    this.status,
    this.baseCurrency,
    this.exchangeCurrency,
    this.fee,
    this.rate,
    this.amount,
    this.files,
    this.proofs,
    this.accountNumber,
    this.ecode,
    this.metadata,
    this.asset,
    this.origination,
    this.deleted,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'AirtimeTransaction(user: $user, type: $type, status: $status, baseCurrency: $baseCurrency, exchangeCurrency: $exchangeCurrency, fee: $fee, rate: $rate, amount: $amount, files: $files, proofs: $proofs, accountNumber: $accountNumber, ecode: $ecode, metadata: $metadata, asset: $asset, origination: $origination, deleted: $deleted, id: $id, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  factory AirtimeTransaction.fromMap(Map<String, dynamic> data) {
    return AirtimeTransaction(
      user: data['user'] as String?,
      type: data['type'] as String?,
      status: data['status'] as String?,
      baseCurrency: data['baseCurrency'] as String?,
      exchangeCurrency: data['exchangeCurrency'] as String?,
      fee: data['fee'] as int?,
      rate: data['rate'] as int?,
      amount: data['amount'] as int?,
      files: data['files'] as List<dynamic>?,
      proofs: data['proofs'] as List<dynamic>?,
      accountNumber: data['accountNumber'] as String?,
      ecode: data['ecode'] as bool?,
      metadata: data['metadata'] == null
          ? null
          : Metadata.fromMap(data['metadata'] as Map<String, dynamic>),
      asset: data['asset'] == null
          ? null
          : Asset.fromMap(data['asset'] as Map<String, dynamic>),
      origination: data['origination'] == null
          ? null
          : Origination.fromMap(data['origination'] as Map<String, dynamic>),
      deleted: data['deleted'] as bool?,
      id: data['id'] as String?,
      createdAt: data['createdAt'] == null
          ? null
          : DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] == null
          ? null
          : DateTime.parse(data['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'user': user,
        'type': type,
        'status': status,
        'baseCurrency': baseCurrency,
        'exchangeCurrency': exchangeCurrency,
        'fee': fee,
        'rate': rate,
        'amount': amount,
        'files': files,
        'proofs': proofs,
        'accountNumber': accountNumber,
        'ecode': ecode,
        'metadata': metadata?.toMap(),
        'asset': asset?.toMap(),
        'origination': origination?.toMap(),
        'deleted': deleted,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'id': id,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AirtimeTransaction].
  factory AirtimeTransaction.fromJson(String data) {
    return AirtimeTransaction.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AirtimeTransaction] to a JSON string.
  String toJson() => json.encode(toMap());

  AirtimeTransaction copyWith({
    String? user,
    String? type,
    String? status,
    String? baseCurrency,
    String? exchangeCurrency,
    int? fee,
    int? rate,
    int? amount,
    List<dynamic>? files,
    List<dynamic>? proofs,
    String? accountNumber,
    bool? ecode,
    Metadata? metadata,
    Asset? asset,
    Origination? origination,
    bool? deleted,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AirtimeTransaction(
      user: user ?? this.user,
      type: type ?? this.type,
      status: status ?? this.status,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      exchangeCurrency: exchangeCurrency ?? this.exchangeCurrency,
      fee: fee ?? this.fee,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
      files: files ?? this.files,
      proofs: proofs ?? this.proofs,
      accountNumber: accountNumber ?? this.accountNumber,
      ecode: ecode ?? this.ecode,
      metadata: metadata ?? this.metadata,
      asset: asset ?? this.asset,
      origination: origination ?? this.origination,
      deleted: deleted ?? this.deleted,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
