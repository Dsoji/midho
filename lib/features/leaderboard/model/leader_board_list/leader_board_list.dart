import 'dart:convert';

import 'user.dart';

class LeaderBoardList {
  num? totalTradingValue;
  num? cryptoTradingValue;
  num? giftCardTradingValue;
  User? user;

  LeaderBoardList({
    this.totalTradingValue,
    this.cryptoTradingValue,
    this.giftCardTradingValue,
    this.user,
  });

  @override
  String toString() {
    return 'LeaderBoardList(totalTradingValue: $totalTradingValue, cryptoTradingValue: $cryptoTradingValue, giftCardTradingValue: $giftCardTradingValue, user: $user)';
  }

  factory LeaderBoardList.fromMap(Map<String, dynamic> data) {
    return LeaderBoardList(
      totalTradingValue: data['totalTradingValue'] as num?,
      cryptoTradingValue: data['cryptoTradingValue'] as num?,
      giftCardTradingValue: data['giftCardTradingValue'] as num?,
      user: data['user'] == null
          ? null
          : User.fromMap(data['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'totalTradingValue': totalTradingValue,
        'cryptoTradingValue': cryptoTradingValue,
        'giftCardTradingValue': giftCardTradingValue,
        'user': user?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LeaderBoardList].
  factory LeaderBoardList.fromJson(String data) {
    return LeaderBoardList.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LeaderBoardList] to a JSON string.
  String toJson() => json.encode(toMap());

  LeaderBoardList copyWith({
    num? totalTradingValue,
    num? cryptoTradingValue,
    num? giftCardTradingValue,
    User? user,
  }) {
    return LeaderBoardList(
      totalTradingValue: totalTradingValue ?? this.totalTradingValue,
      cryptoTradingValue: cryptoTradingValue ?? this.cryptoTradingValue,
      giftCardTradingValue: giftCardTradingValue ?? this.giftCardTradingValue,
      user: user ?? this.user,
    );
  }
}
