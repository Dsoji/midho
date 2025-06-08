import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/referral_screen/data/model/response/rewards_model/rewards_model.dart';
import 'package:mdiho/features/transaction/data/model/response/currencies_model.dart';
import 'package:mdiho/features/transaction/data/model/response/rates_model/rates_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../../../bank_network/data/model/response/acct_name_model/acct_name_model.dart';
import '../../../bills/data/model/response/airtime_transaction/airtime_transaction.dart';
import '../../../gift_card/data/model/response/gift_cart_transaction/gift_cart_transaction.dart';
import '../../../referral_screen/data/model/response/referall_model/referall_model.dart';
import '../repository/transaction_repository.dart';
import '../state/transaction_state.dart';

final logger = Logger();
final transactionControllerProvider =
    StateNotifierProvider<TransactionController, TransactionState>((ref) {
  final authenticationRepository = ref.watch(transactionRepositoryProvider);
  return TransactionController(
    authenticationRepository: authenticationRepository,
    ref: ref,
  );
});

class TransactionController extends StateNotifier<TransactionState> {
  TransactionController({
    required TransactionRepository authenticationRepository,
    required this.ref,
  })  : _authenticationRepository = authenticationRepository,
        super(
          TransactionState.initial(),
        ) {
    // geAuthCredential();
  }

  final TransactionRepository _authenticationRepository;
  final Ref ref;

  Future<bool> getTransactions({
    String? status,
    String? type,
    String? startDate,
    String? endDate,
    String sortKey = 'createdAt',
    String sortOrder = 'DESC',
  }) async {
    state = state.copyWith(transactions: const AsyncValue.loading());

    final result = await _authenticationRepository.getTransactions(
      status: status,
      type: type,
      startDate: startDate,
      endDate: endDate,
      sortKey: sortKey,
      sortOrder: sortOrder,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          transactions:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          transactions:
              AsyncValue.data(result.getSuccess() ?? TransactionHistory()),
        );
        return true;
      },
    );
  }

  Future<bool> fetchTransactions({
    String? status,
    String? type,
    String? startDate,
    String? endDate,
    String sortKey = 'createdAt',
    String sortOrder = 'DESC',
  }) async {
    state = state.copyWith(transactions: const AsyncValue.loading());

    final result = await _authenticationRepository.getTransactions(
      status: status,
      type: type,
      startDate: startDate,
      endDate: endDate,
      sortKey: sortKey,
      sortOrder: sortOrder,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          transactionList:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          transactionList:
              AsyncValue.data(result.getSuccess() ?? TransactionHistory()),
        );
        return true;
      },
    );
  }

  Future<bool> getRates() async {
    final rates = Hive.box('data').get('rates');

    if (rates != null && rates is Map) {
      try {
        // Manually build a properly typed Map<String, dynamic>
        final Map<String, dynamic> fixedMap = {};
        for (var entry in rates.entries) {
          if (entry.key is String) {
            fixedMap[entry.key] = entry.value;
          } else {
            fixedMap[entry.key.toString()] = entry.value;
          }
        }

        final cachedRates = RatesModel.fromMap(fixedMap);
        state = state.copyWith(rates: AsyncValue.data(cachedRates));
        logger.d('✅ Loaded cached rate from normalized map.');
      } catch (e, stack) {
        logger.e('⛔ Failed to parse normalized rate: $e', stackTrace: stack);
        state = state.copyWith(rates: const AsyncValue.loading());
      }
    } else {
      logger.w('No cached rates found.');
      state = state.copyWith(rates: const AsyncValue.loading());
    }

    final result = await _authenticationRepository.getRates();
    return result.when(
      (error) {
        state = state.copyWith(
          rates: AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          rates: AsyncValue.data(result.getSuccess() ?? RatesModel()),
        );
        return true;
      },
    );
  }

  Future<bool> getCurrencies() async {
    state = state.copyWith(currency: const AsyncValue.loading());

    final result = await _authenticationRepository.getCurrency();
    return result.when(
      (error) {
        state = state.copyWith(
          currency:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          currency: AsyncValue.data(result.getSuccess() ?? CurrenciesModel()),
        );
        return true;
      },
    );
  }

  Future<bool> sellCrypto({
    String? id,
    String? name,
    int? amount,
    String? comment,
    List<String>? files,
  }) async {
    state = state.copyWith(sellCrypto: const AsyncValue.loading());

    final result = await _authenticationRepository.sellCrypto(
      id: id,
      name: name,
      amount: amount,
      comment: comment,
      files: files,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          sellCrypto:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          sellCrypto:
              AsyncValue.data(result.getSuccess() ?? GiftCartTransaction()),
        );
        return true;
      },
    );
  }

  Future<bool> sellGiftCards({
    String? id,
    String? name,
    int? amount,
    String? comment,
    List<String>? files,
    bool? ecode,
    String? code,
    String? pin,
  }) async {
    state = state.copyWith(sellGiftCards: const AsyncValue.loading());

    final result = await _authenticationRepository.sellGiftCards(
      id: id,
      name: name,
      amount: amount,
      comment: comment,
      files: files,
      pin: pin,
      ecode: ecode,
      code: code,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          sellGiftCards:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          sellGiftCards:
              AsyncValue.data(result.getSuccess() ?? GiftCartTransaction()),
        );
        return true;
      },
    );
  }

  Future<bool> getRewards() async {
    final rates = Hive.box('data').get('rewards');

    if (rates != null && rates is Map) {
      try {
        // Manually build a properly typed Map<String, dynamic>
        final Map<String, dynamic> fixedMap = {};
        for (var entry in rates.entries) {
          if (entry.key is String) {
            fixedMap[entry.key] = entry.value;
          } else {
            fixedMap[entry.key.toString()] = entry.value;
          }
        }

        final cachedRates = RewardsModel.fromMap(fixedMap);
        state = state.copyWith(rewards: AsyncValue.data(cachedRates));
        logger.d('✅ Loaded cached rewards from normalized map.');
      } catch (e, stack) {
        logger.e('⛔ Failed to parse normalized reward: $e', stackTrace: stack);
        state = state.copyWith(rewards: const AsyncValue.loading());
      }
    } else {
      logger.w('No cached rewards found.');
      state = state.copyWith(rewards: const AsyncValue.loading());
    }

    final result = await _authenticationRepository.getRewards();
    return result.when(
      (error) {
        state = state.copyWith(
          rewards:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          rewards: AsyncValue.data(result.getSuccess() ?? RewardsModel()),
        );
        return true;
      },
    );
  }

  Future<bool> getReferrals() async {
    final rates = Hive.box('data').get('referalls');

    if (rates != null && rates is Map) {
      try {
        // Manually build a properly typed Map<String, dynamic>
        final Map<String, dynamic> fixedMap = {};
        for (var entry in rates.entries) {
          if (entry.key is String) {
            fixedMap[entry.key] = entry.value;
          } else {
            fixedMap[entry.key.toString()] = entry.value;
          }
        }

        final cachedRates = ReferallModel.fromMap(fixedMap);
        state = state.copyWith(referals: AsyncValue.data(cachedRates));
        logger.d('✅ Loaded cached referalls from normalized map.');
      } catch (e, stack) {
        logger.e('⛔ Failed to parse normalized rewferall: $e',
            stackTrace: stack);
        state = state.copyWith(referals: const AsyncValue.loading());
      }
    } else {
      logger.w('No cached referalls found.');
      state = state.copyWith(referals: const AsyncValue.loading());
    }

    final result = await _authenticationRepository.getReferrals();
    return result.when(
      (error) {
        state = state.copyWith(
          referals:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          referals: AsyncValue.data(result.getSuccess() ?? ReferallModel()),
        );
        return true;
      },
    );
  }

  Future<bool> addBanks({
    required String acctName,
    required String acctNo,
    required String bankName,
    required String bankCode,
  }) async {
    state = state.copyWith(addBank: const AsyncValue.loading());

    final result = await _authenticationRepository.addBanks(
      acctName: acctName,
      acctNo: acctNo,
      bankName: bankName,
      bankCode: bankCode,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          addBank:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          addBank: AsyncValue.data(result.getSuccess() ?? ''),
        );
        return true;
      },
    );
  }

  Future<bool> acctName({
    required String acctNo,
    required String bankCode,
  }) async {
    state = state.copyWith(acctName: const AsyncValue.loading());

    final result = await _authenticationRepository.getAcctname(
      acctNo: acctNo,
      bankCode: bankCode,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          acctName:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          acctName: AsyncValue.data(result.getSuccess() ?? AcctNameModel()),
        );
        return true;
      },
    );
  }

  Future<bool> deleteBanks({
    required String acctId,
  }) async {
    state = state.copyWith(addBank: const AsyncValue.loading());

    final result = await _authenticationRepository.deleteAcct(
      acctId: acctId,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          addBank:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          addBank: AsyncValue.data(result.getSuccess() ?? ''),
        );
        return true;
      },
    );
  }

  Future<bool> buyAirtime({
    required String assetId,
    required int amount,
    required String accountNumber,
    required String pin,
  }) async {
    state = state.copyWith(buyAirtime: const AsyncValue.loading());

    final result = await _authenticationRepository.buyAirtime(
      assetId: assetId,
      amount: amount,
      accountNumber: accountNumber,
      pin: pin,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          buyAirtime:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          buyAirtime:
              AsyncValue.data(result.getSuccess() ?? AirtimeTransaction()),
        );
        return true;
      },
    );
  }

  Future<bool> buyData({
    required String assetId,
    required String accountNumber,
    required String pin,
  }) async {
    state = state.copyWith(buyData: const AsyncValue.loading());

    final result = await _authenticationRepository.buyData(
      assetId: assetId,
      accountNumber: accountNumber,
      pin: pin,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          buyData:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          buyData: AsyncValue.data(result.getSuccess() ?? AirtimeTransaction()),
        );
        return true;
      },
    );
  }

  Future<bool> buyElectricity({
    required String assetId,
    required int amount,
    required String accountNumber,
    required String pin,
  }) async {
    state = state.copyWith(buyElectricity: const AsyncValue.loading());

    final result = await _authenticationRepository.buyElectricity(
      assetId: assetId,
      amount: amount,
      accountNumber: accountNumber,
      pin: pin,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          buyElectricity:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          buyElectricity:
              AsyncValue.data(result.getSuccess() ?? AirtimeTransaction()),
        );
        return true;
      },
    );
  }

  Future<bool> buyCableTv({
    required String assetId,
    required String accountNumber,
    required String pin,
  }) async {
    state = state.copyWith(buyCableTv: const AsyncValue.loading());

    final result = await _authenticationRepository.buyCableTv(
      assetId: assetId,
      accountNumber: accountNumber,
      pin: pin,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          buyCableTv:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          buyCableTv:
              AsyncValue.data(result.getSuccess() ?? AirtimeTransaction()),
        );
        return true;
      },
    );
  }

  Future<bool> getDataPlans() async {
    state = state.copyWith(dataPlans: const AsyncValue.loading());

    final result = await _authenticationRepository.getDataPlans();
    return result.when(
      (error) {
        state = state.copyWith(
          dataPlans:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          dataPlans: AsyncValue.data(result.getSuccess() ?? []),
        );
        return true;
      },
    );
  }

  Future<bool> getCableTvPlans() async {
    state = state.copyWith(cableTvPlans: const AsyncValue.loading());

    final result = await _authenticationRepository.getCableTvPlans();
    return result.when(
      (error) {
        state = state.copyWith(
          cableTvPlans:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          cableTvPlans: AsyncValue.data(result.getSuccess() ?? []),
        );
        return true;
      },
    );
  }

  Future<bool> getElectricalPlans() async {
    state = state.copyWith(electricityPlans: const AsyncValue.loading());

    final result = await _authenticationRepository.getElectricalPlans();
    return result.when(
      (error) {
        state = state.copyWith(
          electricityPlans:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          electricityPlans: AsyncValue.data(result.getSuccess() ?? []),
        );
        return true;
      },
    );
  }

  Future<bool> getAirtimePlans() async {
    state = state.copyWith(airtimePlans: const AsyncValue.loading());

    final result = await _authenticationRepository.getAirtimePlans();
    return result.when(
      (error) {
        state = state.copyWith(
          airtimePlans:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          airtimePlans: AsyncValue.data(result.getSuccess() ?? []),
        );
        return true;
      },
    );
  }

  Future<bool> withdraw({
    String? acctNo,
    int? amount,
    bool? referall,
    String? accountName,
    required String pin,
    String? bankName,
    String? bankCode,
  }) async {
    state = state.copyWith(withdrawal: const AsyncValue.loading());

    final result = await _authenticationRepository.withdraw(
      acctNo: acctNo,
      amount: amount,
      referall: referall,
      pin: pin,
      accountName: accountName,
      bankName: bankName,
      bankCode: bankCode,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          withdrawal:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          withdrawal:
              AsyncValue.data(result.getSuccess() ?? AirtimeTransaction()),
        );
        return true;
      },
    );
  }
}
