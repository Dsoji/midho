import 'dart:convert';

import 'asset.dart';
import 'referee.dart';
import 'referral.dart';

class Datum {
  String? id;
  Referral? referral;
  Referee? referee;
  int? amount;
  String? status;
  Asset? asset;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.referral,
    this.referee,
    this.amount,
    this.status,
    this.asset,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  @override
  String toString() {
    return 'Datum(id: $id, referral: $referral, referee: $referee, amount: $amount, status: $status, asset: $asset, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  factory Datum.fromMap(Map data) {
    final normalizedData = Map<String, dynamic>.from(data);

    return Datum(
      id: normalizedData['_id'] as String?,
      referral: normalizedData['referral'] == null
          ? null
          : Referral.fromMap(
              Map<String, dynamic>.from(normalizedData['referral'] as Map)),
      referee: normalizedData['referee'] == null
          ? null
          : Referee.fromMap(
              Map<String, dynamic>.from(normalizedData['referee'] as Map)),
      amount: (normalizedData['amount'] as num?)?.toInt(),
      status: normalizedData['status'] as String?,
      asset: normalizedData['asset'] == null
          ? null
          : Asset.fromMap(
              Map<String, dynamic>.from(normalizedData['asset'] as Map)),
      createdAt: normalizedData['createdAt'] == null
          ? null
          : DateTime.parse(normalizedData['createdAt'] as String),
      updatedAt: normalizedData['updatedAt'] == null
          ? null
          : DateTime.parse(normalizedData['updatedAt'] as String),
      v: (normalizedData['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        '_id': id,
        'referral': referral?.toMap(),
        'referee': referee?.toMap(),
        'amount': amount,
        'status': status,
        'asset': asset?.toMap(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  Datum copyWith({
    String? id,
    Referral? referral,
    Referee? referee,
    int? amount,
    String? status,
    Asset? asset,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Datum(
      id: id ?? this.id,
      referral: referral ?? this.referral,
      referee: referee ?? this.referee,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      asset: asset ?? this.asset,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
