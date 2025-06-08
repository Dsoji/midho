import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/referral_screen/data/model/response/referall_model/referall_model.dart';
import 'package:mdiho/features/referral_screen/data/model/response/rewards_model/rewards_model.dart';
import 'package:mdiho/features/transaction/data/model/response/rates_model/rates_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../../../bank_network/data/model/response/acct_name_model/acct_name_model.dart';
import '../../../bills/data/model/response/airtime_electric_model/airtime_electric_model.dart';
import '../../../bills/data/model/response/airtime_transaction/airtime_transaction.dart';
import '../../../bills/data/model/response/data_tv_model/data_tv_model.dart';
import '../../../gift_card/data/model/response/gift_cart_transaction/gift_cart_transaction.dart';
import '../model/response/currencies_model.dart';

class TransactionState {
  final AsyncValue<TransactionHistory> transactions;
  final AsyncValue<TransactionHistory> transactionList;

  final AsyncValue<GiftCartTransaction> sellCrypto;
  final AsyncValue<GiftCartTransaction> sellGiftCards;
  final AsyncValue<RatesModel> rates;
  final AsyncValue<CurrenciesModel> currency;
  final AsyncValue<RewardsModel> rewards;
  final AsyncValue<ReferallModel> referals;
  final AsyncValue<String> addBank;
  final AsyncValue<AcctNameModel> acctName;
  final AsyncValue<AirtimeTransaction> buyAirtime;
  final AsyncValue<AirtimeTransaction> buyData;
  final AsyncValue<AirtimeTransaction> buyElectricity;
  final AsyncValue<AirtimeTransaction> buyCableTv;
  final AsyncValue<List<DataTvModel>> dataPlans;
  final AsyncValue<List<DataTvModel>> cableTvPlans;
  final AsyncValue<List<AirtimeElectricModel>> airtimePlans;
  final AsyncValue<List<AirtimeElectricModel>> electricityPlans;
  final AsyncValue<AirtimeTransaction> withdrawal;
  const TransactionState({
    required this.transactions,
    required this.sellCrypto,
    required this.sellGiftCards,
    required this.rates,
    required this.currency,
    required this.rewards,
    required this.referals,
    required this.transactionList,
    required this.addBank,
    required this.acctName,
    required this.buyAirtime,
    required this.buyData,
    required this.buyElectricity,
    required this.buyCableTv,
    required this.dataPlans,
    required this.cableTvPlans,
    required this.airtimePlans,
    required this.electricityPlans,
    required this.withdrawal,
  });

  factory TransactionState.initial() {
    return TransactionState(
      transactions: AsyncValue.data(TransactionHistory()),
      sellCrypto: AsyncValue.data(GiftCartTransaction()),
      sellGiftCards: AsyncData(GiftCartTransaction()),
      rates: AsyncData(RatesModel()),
      currency: AsyncData(CurrenciesModel()),
      rewards: AsyncValue.data(RewardsModel()),
      referals: AsyncValue.data(ReferallModel()),
      transactionList: AsyncValue.data(TransactionHistory()),
      addBank: const AsyncValue.data(''),
      acctName: AsyncValue.data(AcctNameModel()),
      buyAirtime: AsyncValue.data(AirtimeTransaction()),
      buyData: AsyncValue.data(AirtimeTransaction()),
      buyElectricity: AsyncValue.data(AirtimeTransaction()),
      buyCableTv: AsyncValue.data(AirtimeTransaction()),
      dataPlans: const AsyncValue.data([]),
      cableTvPlans: const AsyncValue.data([]),
      airtimePlans: const AsyncValue.data([]),
      electricityPlans: const AsyncValue.data([]),
      withdrawal: AsyncValue.data(AirtimeTransaction()),
    );
  }

  TransactionState copyWith({
    AsyncValue<TransactionHistory>? transactions,
    AsyncValue<GiftCartTransaction>? sellCrypto,
    AsyncValue<GiftCartTransaction>? sellGiftCards,
    AsyncValue<RatesModel>? rates,
    AsyncValue<CurrenciesModel>? currency,
    AsyncValue<RewardsModel>? rewards,
    AsyncValue<ReferallModel>? referals,
    AsyncValue<TransactionHistory>? transactionList,
    AsyncValue<String>? addBank,
    AsyncValue<AcctNameModel>? acctName,
    AsyncValue<AirtimeTransaction>? buyAirtime,
    AsyncValue<AirtimeTransaction>? buyData,
    AsyncValue<AirtimeTransaction>? buyElectricity,
    AsyncValue<AirtimeTransaction>? buyCableTv,
    AsyncValue<List<DataTvModel>>? dataPlans,
    AsyncValue<List<DataTvModel>>? cableTvPlans,
    AsyncValue<List<AirtimeElectricModel>>? airtimePlans,
    AsyncValue<List<AirtimeElectricModel>>? electricityPlans,
    AsyncValue<AirtimeTransaction>? withdrawal,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      sellCrypto: sellCrypto ?? this.sellCrypto,
      sellGiftCards: sellGiftCards ?? this.sellGiftCards,
      rates: rates ?? this.rates,
      currency: currency ?? this.currency,
      rewards: rewards ?? this.rewards,
      referals: referals ?? this.referals,
      transactionList: transactionList ?? this.transactionList,
      addBank: addBank ?? this.addBank,
      acctName: acctName ?? this.acctName,
      buyAirtime: buyAirtime ?? this.buyAirtime,
      buyData: buyData ?? this.buyData,
      buyElectricity: buyElectricity ?? this.buyElectricity,
      buyCableTv: buyCableTv ?? this.buyCableTv,
      dataPlans: dataPlans ?? this.dataPlans,
      cableTvPlans: cableTvPlans ?? this.cableTvPlans,
      airtimePlans: airtimePlans ?? this.airtimePlans,
      electricityPlans: electricityPlans ?? this.electricityPlans,
      withdrawal: withdrawal ?? this.withdrawal,
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
        other.referals == referals &&
        other.transactionList == transactionList &&
        other.addBank == addBank &&
        other.acctName == acctName &&
        other.buyAirtime == buyAirtime &&
        other.buyData == buyData &&
        other.buyElectricity == buyElectricity &&
        other.buyCableTv == buyCableTv &&
        other.dataPlans == dataPlans &&
        other.cableTvPlans == cableTvPlans &&
        other.airtimePlans == airtimePlans &&
        other.electricityPlans == electricityPlans &&
        other.withdrawal == withdrawal;
  }

  @override
  int get hashCode {
    return transactions.hashCode ^
        sellCrypto.hashCode ^
        sellGiftCards.hashCode ^
        rates.hashCode ^
        currency.hashCode ^
        rewards.hashCode ^
        referals.hashCode ^
        transactionList.hashCode ^
        addBank.hashCode ^
        acctName.hashCode ^
        buyAirtime.hashCode ^
        buyData.hashCode ^
        buyElectricity.hashCode ^
        buyCableTv.hashCode ^
        dataPlans.hashCode ^
        cableTvPlans.hashCode ^
        airtimePlans.hashCode ^
        electricityPlans.hashCode ^
        withdrawal.hashCode;
  }
}
