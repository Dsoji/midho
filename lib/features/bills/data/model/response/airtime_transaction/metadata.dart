import 'dart:convert';

import 'details.dart';
import 'product.dart';
import 'vendor.dart';

class Metadata {
  String? id;
  String? amount;
  Vendor? vendor;
  String? category;
  Product? product;
  String? debitAccountId;
  dynamic instructions;
  DateTime? initiatedAt;
  DateTime? completedAt;
  dynamic failedAt;
  Details? details;
  String? status;
  dynamic reasonForFailure;
  dynamic clientReference;
  String? transactionReference;
  String? commission;

  Metadata({
    this.id,
    this.amount,
    this.vendor,
    this.category,
    this.product,
    this.debitAccountId,
    this.instructions,
    this.initiatedAt,
    this.completedAt,
    this.failedAt,
    this.details,
    this.status,
    this.reasonForFailure,
    this.clientReference,
    this.transactionReference,
    this.commission,
  });

  @override
  String toString() {
    return 'Metadata(id: $id, amount: $amount, vendor: $vendor, category: $category, product: $product, debitAccountId: $debitAccountId, instructions: $instructions, initiatedAt: $initiatedAt, completedAt: $completedAt, failedAt: $failedAt, details: $details, status: $status, reasonForFailure: $reasonForFailure, clientReference: $clientReference, transactionReference: $transactionReference, commission: $commission)';
  }

  factory Metadata.fromMap(Map<String, dynamic> data) => Metadata(
        id: data['id'] as String?,
        amount: data['amount'] as String?,
        vendor: data['vendor'] == null
            ? null
            : Vendor.fromMap(data['vendor'] as Map<String, dynamic>),
        category: data['category'] as String?,
        product: data['product'] == null
            ? null
            : Product.fromMap(data['product'] as Map<String, dynamic>),
        debitAccountId: data['debitAccountId'] as String?,
        instructions: data['instructions'] as dynamic,
        initiatedAt: data['initiatedAt'] == null
            ? null
            : DateTime.parse(data['initiatedAt'] as String),
        completedAt: data['completedAt'] == null
            ? null
            : DateTime.parse(data['completedAt'] as String),
        failedAt: data['failedAt'] as dynamic,
        details: data['details'] == null
            ? null
            : Details.fromMap(data['details'] as Map<String, dynamic>),
        status: data['status'] as String?,
        reasonForFailure: data['reasonForFailure'] as dynamic,
        clientReference: data['clientReference'] as dynamic,
        transactionReference: data['transactionReference'] as String?,
        commission: data['commission'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'vendor': vendor?.toMap(),
        'category': category,
        'product': product?.toMap(),
        'debitAccountId': debitAccountId,
        'instructions': instructions,
        'initiatedAt': initiatedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'failedAt': failedAt,
        'details': details?.toMap(),
        'status': status,
        'reasonForFailure': reasonForFailure,
        'clientReference': clientReference,
        'transactionReference': transactionReference,
        'commission': commission,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Metadata].
  factory Metadata.fromJson(String data) {
    return Metadata.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Metadata] to a JSON string.
  String toJson() => json.encode(toMap());

  Metadata copyWith({
    String? id,
    String? amount,
    Vendor? vendor,
    String? category,
    Product? product,
    String? debitAccountId,
    dynamic instructions,
    DateTime? initiatedAt,
    DateTime? completedAt,
    dynamic failedAt,
    Details? details,
    String? status,
    dynamic reasonForFailure,
    dynamic clientReference,
    String? transactionReference,
    String? commission,
  }) {
    return Metadata(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      vendor: vendor ?? this.vendor,
      category: category ?? this.category,
      product: product ?? this.product,
      debitAccountId: debitAccountId ?? this.debitAccountId,
      instructions: instructions ?? this.instructions,
      initiatedAt: initiatedAt ?? this.initiatedAt,
      completedAt: completedAt ?? this.completedAt,
      failedAt: failedAt ?? this.failedAt,
      details: details ?? this.details,
      status: status ?? this.status,
      reasonForFailure: reasonForFailure ?? this.reasonForFailure,
      clientReference: clientReference ?? this.clientReference,
      transactionReference: transactionReference ?? this.transactionReference,
      commission: commission ?? this.commission,
    );
  }
}
