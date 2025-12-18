import 'dart:convert';

class Wallet {
  String? id;
  String? user;
  double? mainBalance;
  double? referralBalance;
  double? lifetimeReferralBalance;
  String? currency;
  bool? locked;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? inFlow;
  double? outFlow;

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
    this.inFlow,
    this.outFlow,
  });

  @override
  String toString() {
    return 'Wallet(id: $id, user: $user, mainBalance: $mainBalance, referralBalance: $referralBalance, lifetimeReferralBalance: $lifetimeReferralBalance, currency: $currency, locked: $locked, createdAt: $createdAt, updatedAt: $updatedAt, id: $id, inFlow: $inFlow, outFlow: $outFlow )';
  }

  factory Wallet.fromMap(Map<String, dynamic> data) => Wallet(
        id: data['_id'] as String?,
        user: data['user'] as String?,
        mainBalance: (data['mainBalance'] is num)
            ? (data['mainBalance'] as num).toDouble()
            : (data['mainBalance'] is String)
                ? double.tryParse(data['mainBalance'])
                : null,
        referralBalance: (data['referralBalance'] is num)
            ? (data['referralBalance'] as num).toDouble()
            : (data['referralBalance'] is String)
                ? double.tryParse(data['referralBalance'])
                : null,
        lifetimeReferralBalance: (data['lifetimeReferralBalance'] is num)
            ? (data['lifetimeReferralBalance'] as num).toDouble()
            : (data['lifetimeReferralBalance'] is String)
                ? double.tryParse(data['lifetimeReferralBalance'])
                : null,
        currency: data['currency'] as String?,
        locked: data['locked'] as bool?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        inFlow: (data['inflow'] is num)
            ? (data['inflow'] as num).toDouble()
            : (data['inflow'] is String)
                ? double.tryParse(data['inflow'])
                : null,
        outFlow: (data['outflow'] is num)
            ? (data['outflow'] as num).toDouble()
            : (data['outflow'] is String)
                ? double.tryParse(data['outflow'])
                : null,
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
        'id': id,
        'inflow': inFlow,
        'outflow': outFlow,
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
    double? mainBalance,
    double? referralBalance,
    double? lifetimeReferralBalance,
    String? currency,
    bool? locked,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? inFlow,
    double? outFlow,
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
      inFlow: inFlow ?? this.inFlow,
      outFlow: outFlow ?? this.outFlow,
    );
  }
}
