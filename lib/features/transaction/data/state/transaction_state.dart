import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/referral_screen/data/model/response/referall_model/referall_model.dart';
import 'package:mdiho/features/referral_screen/data/model/response/rewards_model/rewards_model.dart';
import 'package:mdiho/features/transaction/data/model/response/rates_model/rates_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../model/response/currencies_model.dart';
import '../model/response/transaction_history/datum.dart';

class TransactionState {
  final AsyncValue<TransactionHistory> transactions;
  final AsyncValue<TransactionData> sellCrypto;
  final AsyncValue<String> sellGiftCards;
  final AsyncValue<RatesModel> rates;
  final AsyncValue<CurrenciesModel> currency;
  final AsyncValue<RewardsModel> rewards;
  final AsyncValue<ReferallModel> referals;

  const TransactionState(
      {required this.transactions,
      required this.sellCrypto,
      required this.sellGiftCards,
      required this.rates,
      required this.currency,
      required this.rewards,
      required this.referals});

  factory TransactionState.initial() {
    return TransactionState(
      transactions: AsyncValue.data(TransactionHistory()),
      sellCrypto: AsyncValue.data(TransactionData()),
      sellGiftCards: const AsyncData(''),
      rates: AsyncData(RatesModel()),
      currency: AsyncData(CurrenciesModel()),
      rewards: AsyncValue.data(RewardsModel()),
      referals: AsyncValue.data(ReferallModel()),
    );
  }

  TransactionState copyWith({
    AsyncValue<TransactionHistory>? transactions,
    AsyncValue<TransactionData>? sellCrypto,
    AsyncValue<String>? sellGiftCards,
    AsyncValue<RatesModel>? rates,
    AsyncValue<CurrenciesModel>? currency,
    AsyncValue<RewardsModel>? rewards,
    AsyncValue<ReferallModel>? referals,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      sellCrypto: sellCrypto ?? this.sellCrypto,
      sellGiftCards: sellGiftCards ?? this.sellGiftCards,
      rates: rates ?? this.rates,
      currency: currency ?? this.currency,
      rewards: rewards ?? this.rewards,
      referals: referals ?? this.referals,
    );
  }

  @override
  String toString() {
    return 'TransactionState(login: $transactions, )';
  }

  @override
  bool operator ==(covariant TransactionState other) {
    if (identical(this, other)) return true;

    return other.transactions == transactions &&
        other.sellCrypto == sellCrypto &&
        other.sellGiftCards == sellGiftCards &&
        other.rates == rates &&
        other.currency == currency &&
        other.rewards == rewards &&
        other.referals == referals;
  }

  @override
  int get hashCode {
    return transactions.hashCode ^
        sellCrypto.hashCode ^
        sellGiftCards.hashCode ^
        rates.hashCode ^
        currency.hashCode ^
        rewards.hashCode ^
        referals.hashCode;
  }
}
