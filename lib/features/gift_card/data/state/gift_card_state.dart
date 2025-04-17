import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/response/user_model/user_model.dart';

class GiftCardState {
  final AsyncValue<UserModel> giftCards;

  const GiftCardState({
    required this.giftCards,
  });

  factory GiftCardState.initial() {
    return GiftCardState(
      giftCards: AsyncValue.data(UserModel()),
    );
  }

  GiftCardState copyWith({
    AsyncValue<UserModel>? giftCards,
  }) {
    return GiftCardState(
      giftCards: giftCards ?? this.giftCards,
    );
  }

  @override
  String toString() {
    return 'GiftCardState(login: $giftCards, )';
  }

  @override
  bool operator ==(covariant GiftCardState other) {
    if (identical(this, other)) return true;

    return other.giftCards == giftCards;
  }

  @override
  int get hashCode {
    return giftCards.hashCode;
  }
}
