import 'dart:convert';

class Wallet {
  String? id;
  String? user;
  int? mainBalance;
  int? referralBalance;
  int? lifetimeReferralBalance;
  String? currency;
  bool? locked;
  DateTime? createdAt;
  DateTime? updatedAt;

  Wallet({
    this.id,
    this.user,
    this.mainBalance,
    this.referralBalance,
    this.lifetimeReferralBalance,
    this.currency,
    this.locked,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Wallet(id: $id, user: $user, mainBalance: $mainBalance, referralBalance: $referralBalance, lifetimeReferralBalance: $lifetimeReferralBalance, currency: $currency, locked: $locked, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  factory Wallet.fromMap(Map<String, dynamic> data) => Wallet(
        id: data['_id'] as String?,
        user: data['user'] as String?,
        mainBalance: data['mainBalance'] as int?,
        referralBalance: data['referralBalance'] as int?,
        lifetimeReferralBalance: data['lifetimeReferralBalance'] as int?,
        currency: data['currency'] as String?,
        locked: data['locked'] as bool?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        '_id': id,
        'user': user,
        'mainBalance': mainBalance,
        'referralBalance': referralBalance,
        'lifetimeReferralBalance': lifetimeReferralBalance,
        'currency': currency,
        'locked': locked,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Wallet].
  factory Wallet.fromJson(String data) {
    return Wallet.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Wallet] to a JSON string.
  String toJson() => json.encode(toMap());

  Wallet copyWith({
    String? id,
    String? user,
    int? mainBalance,
    int? referralBalance,
    int? lifetimeReferralBalance,
    String? currency,
    bool? locked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      id: id ?? this.id,
      user: user ?? this.user,
      mainBalance: mainBalance ?? this.mainBalance,
      referralBalance: referralBalance ?? this.referralBalance,
      lifetimeReferralBalance:
          lifetimeReferralBalance ?? this.lifetimeReferralBalance,
      currency: currency ?? this.currency,
      locked: locked ?? this.locked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
