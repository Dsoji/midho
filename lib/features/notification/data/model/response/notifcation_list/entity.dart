import 'dart:convert';

import 'asset.dart';
import 'origination.dart';

class Entity {
  String? user;
  String? type;
  String? status;
  String? baseCurrency;
  String? exchangeCurrency;
  int? fee;
  int? rate;
  int? amount;
  List<String>? files;
  List<String>? proofs;
  bool? ecode;
  dynamic code;
  dynamic pin;
  String? comment;
  Asset? asset;
  Origination? origination;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Entity({
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
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Entity(user: $user, type: $type, status: $status, baseCurrency: $baseCurrency, exchangeCurrency: $exchangeCurrency, fee: $fee, rate: $rate, amount: $amount, files: $files, proofs: $proofs, ecode: $ecode, code: $code, pin: $pin, comment: $comment, asset: $asset, origination: $origination, id: $id, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Entity.fromMap(Map<String, dynamic> data) => Entity(
        user: data['user'] as String?,
        type: data['type'] as String?,
        status: data['status'] as String?,
        baseCurrency: data['baseCurrency'] as String?,
        exchangeCurrency: data['exchangeCurrency'] as String?,
        fee: data['fee'] as int?,
        rate: data['rate'] as int?,
        amount: data['amount'] as int?,
        files: (data['files'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        proofs: (data['proofs'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        ecode: data['ecode'] as bool?,
        code: data['code'],
        pin: data['pin'],
        comment: data['comment'] as String?,
        asset: data['asset'] == null
            ? null
            : Asset.fromMap(data['asset'] as Map<String, dynamic>),
        origination: data['origination'] == null
            ? null
            : Origination.fromMap(data['origination'] as Map<String, dynamic>),
        id: data['_id'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        v: data['__v'] as int?,
      );
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
        '_id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Entity].
  factory Entity.fromJson(String data) {
    return Entity.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Entity] to a JSON string.
  String toJson() => json.encode(toMap());

  Entity copyWith({
    String? user,
    String? type,
    String? status,
    String? baseCurrency,
    String? exchangeCurrency,
    int? fee,
    int? rate,
    int? amount,
    List<String>? files,
    List<String>? proofs,
    bool? ecode,
    dynamic code,
    dynamic pin,
    String? comment,
    Asset? asset,
    Origination? origination,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Entity(
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
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
