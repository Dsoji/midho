import 'dart:convert';

import 'asset.dart';
import 'origination.dart';

class GiftCartTransaction {
  String? user;
  String? type;
  String? status;
  String? baseCurrency;
  String? exchangeCurrency;
  double? fee;
  double? rate;
  double? amount;
  List<dynamic>? files;
  List<dynamic>? proofs;
  bool? ecode;
  String? code;
  String? pin;
  String? comment;
  Asset? asset;
  Origination? origination;
  bool? deleted;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  GiftCartTransaction({
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
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'GiftCartTransaction(user: $user, type: $type, status: $status, baseCurrency: $baseCurrency, exchangeCurrency: $exchangeCurrency, fee: $fee, rate: $rate, amount: $amount, files: $files, proofs: $proofs, ecode: $ecode, code: $code, pin: $pin, comment: $comment, asset: $asset, origination: $origination, deleted: $deleted, id: $id, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  factory GiftCartTransaction.fromMap(Map<String, dynamic> data) {
    return GiftCartTransaction(
      user: data['user'] as String?,
      type: data['type'] as String?,
      status: data['status'] as String?,
      baseCurrency: data['baseCurrency'] as String?,
      exchangeCurrency: data['exchangeCurrency'] as String?,
      fee: data['fee'] is num
          ? (data['fee'] as num).toDouble()
          : (data['fee'] is String)
              ? double.tryParse(data['fee'])
              : null,
      rate: data['rate'] is num
          ? (data['rate'] as num).toDouble()
          : (data['rate'] is String)
              ? double.tryParse(data['rate'])
              : null,
      amount: data['amount'] is num
          ? (data['amount'] as num).toDouble()
          : (data['amount'] is String)
              ? double.tryParse(data['amount'])
              : null,
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
      id: data['_id'] as String?,
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
        'ecode': ecode,
        'code': code,
        'pin': pin,
        'comment': comment,
        'asset': asset?.toMap(),
        'origination': origination?.toMap(),
        'deleted': deleted,
        '_id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GiftCartTransaction].
  factory GiftCartTransaction.fromJson(String data) {
    return GiftCartTransaction.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GiftCartTransaction] to a JSON string.
  String toJson() => json.encode(toMap());
  GiftCartTransaction copyWith({
    String? user,
    String? type,
    String? status,
    String? baseCurrency,
    String? exchangeCurrency,
    double? fee,
    double? rate,
    double? amount,
    List<dynamic>? files,
    List<dynamic>? proofs,
    bool? ecode,
    String? code,
    String? pin,
    String? comment,
    Asset? asset,
    Origination? origination,
    bool? deleted,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GiftCartTransaction(
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
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
