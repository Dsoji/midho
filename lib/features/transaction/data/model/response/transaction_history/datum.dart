import 'dart:convert';

import 'asset.dart';
import 'metadata.dart';
import 'origination.dart';
import 'user.dart';

class TransactionData {
  String? id;
  User? user;
  String? type;
  String? status;
  String? baseCurrency;
  String? exchangeCurrency;
  num? fee;
  num? rate;
  num? amount;
  List<dynamic>? files;
  List<dynamic>? proofs;
  bool? ecode;
  String? code;
  String? pin;
  String? comment;
  Asset? asset;
  Origination? origination;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? v;
  String? accountNumber;
  Metadata? metadata;
  String? bankName;
  String? reason;

  TransactionData({
    this.id,
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
    this.ecode,
    this.code,
    this.pin,
    this.comment,
    this.asset,
    this.origination,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.accountNumber,
    this.metadata,
    this.bankName,
    this.reason,
  });

  @override
  String toString() {
    return 'Datum(id: $id, user: $user, type: $type, status: $status, baseCurrency: $baseCurrency, exchangeCurrency: $exchangeCurrency, fee: $fee, rate: $rate, amount: $amount, files: $files, proofs: $proofs, ecode: $ecode, code: $code, pin: $pin, comment: $comment, asset: $asset, origination: $origination, deleted: $deleted, createdAt: $createdAt, updatedAt: $updatedAt, v: $v, accountNumber: $accountNumber, metadata: $metadata, bankName: $bankName, reason: $reason)';
  }

  factory TransactionData.fromMap(Map<String, dynamic> data) => TransactionData(
        id: data['_id'] as String?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
        type: data['type'] as String?,
        status: data['status'] as String?,
        baseCurrency: data['baseCurrency'] as String?,
        exchangeCurrency: data['exchangeCurrency'] as String?,
        fee: data['fee'] as num?,
        rate: data['rate'] as num?,
        amount: data['amount'] as num?,
        files: data['files'] as List<dynamic>?,
        proofs: data['proofs'] as List<dynamic>?,
        ecode: data['ecode'] as bool?,
        code: data['code'] as String?,
        pin: data['pin'] as String?,
        comment: data['comment'] as String?,
        asset: data['asset'] == null
            ? null
            : Asset.fromMap(data['asset'] as Map<String, dynamic>),
        origination: data['origination'] == null
            ? null
            : Origination.fromMap(data['origination'] as Map<String, dynamic>),
        deleted: data['deleted'] as bool?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as num?,
        accountNumber: data['accountNumber'] as String?,
        metadata: data['metadata'] == null
            ? null
            : Metadata.fromMap(data['metadata'] as Map<String, dynamic>),
        bankName: data['bankName'] as String?,
        reason: data['reason'] as String?,
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'user': user?.toMap(),
        'type': type,
        'status': status,
        'baseCurrency': baseCurrency,
        'exchangeCurrency': exchangeCurrency,
        'fee': fee,
        'rate': rate,
        'amount': amount,
        'files': files,
        'proofs': proofs,
        'ecode': ecode,
        'code': code,
        'pin': pin,
        'comment': comment,
        'asset': asset?.toMap(),
        'origination': origination?.toMap(),
        'deleted': deleted,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
        'accountNumber': accountNumber,
        'metadata': metadata?.toMap(),
        'bankName': bankName,
        'reason': reason,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory TransactionData.fromJson(String data) {
    return TransactionData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  TransactionData copyWith({
    String? id,
    User? user,
    String? type,
    String? status,
    String? baseCurrency,
    String? exchangeCurrency,
    num? fee,
    num? rate,
    num? amount,
    List<dynamic>? files,
    List<dynamic>? proofs,
    bool? ecode,
    String? code,
    String? pin,
    String? comment,
    Asset? asset,
    Origination? origination,
    bool? deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
    String? accountNumber,
    Metadata? metadata,
    String? bankName,
    String? reason,
  }) {
    return TransactionData(
      id: id ?? this.id,
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
      ecode: ecode ?? this.ecode,
      code: code ?? this.code,
      pin: pin ?? this.pin,
      comment: comment ?? this.comment,
      asset: asset ?? this.asset,
      origination: origination ?? this.origination,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      accountNumber: accountNumber ?? this.accountNumber,
      metadata: metadata ?? this.metadata,
      bankName: bankName ?? this.bankName,
      reason: reason ?? this.reason,
    );
  }
}
