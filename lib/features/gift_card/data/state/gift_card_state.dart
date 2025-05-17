import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/response/gift_card_model/gift_card_model.dart';

class GiftCardState {
  final AsyncValue<GiftCardModel> giftCards;

  const GiftCardState({
    required this.giftCards,
  });

  factory GiftCardState.initial() {
    return GiftCardState(
      giftCards: AsyncValue.data(GiftCardModel()),
    );
  }

  GiftCardState copyWith({
    AsyncValue<GiftCardModel>? giftCards,
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
