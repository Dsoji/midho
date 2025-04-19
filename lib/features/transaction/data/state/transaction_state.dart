import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/transaction/data/model/response/rates_model/rates_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../model/response/currencies_model.dart';

class TransactionState {
  final AsyncValue<TransactionHistory> transactions;
  final AsyncValue<String> sellCrypto;
  final AsyncValue<String> sellGiftCards;
  final AsyncValue<RatesModel> rates;
  final AsyncValue<CurrenciesModel> currency;

  const TransactionState({
    required this.transactions,
    required this.sellCrypto,
    required this.sellGiftCards,
    required this.rates,
    required this.currency,
  });

  factory TransactionState.initial() {
    return TransactionState(
      transactions: AsyncValue.data(TransactionHistory()),
      sellCrypto: const AsyncValue.data(''),
      sellGiftCards: const AsyncData(''),
      rates: AsyncData(RatesModel()),
      currency: AsyncData(CurrenciesModel()),
    );
  }

  TransactionState copyWith({
    AsyncValue<TransactionHistory>? transactions,
    AsyncValue<String>? sellCrypto,
    AsyncValue<String>? sellGiftCards,
    AsyncValue<RatesModel>? rates,
    AsyncValue<CurrenciesModel>? currency,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      sellCrypto: sellCrypto ?? this.sellCrypto,
      sellGiftCards: sellGiftCards ?? this.sellGiftCards,
      rates: rates ?? this.rates,
      currency: currency ?? this.currency,
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
        other.currency == currency;
  }

  @override
  int get hashCode {
    return transactions.hashCode ^
        sellCrypto.hashCode ^
        sellGiftCards.hashCode ^
        rates.hashCode ^
        currency.hashCode;
  }
}
