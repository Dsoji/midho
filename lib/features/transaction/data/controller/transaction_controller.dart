import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/transaction/data/model/response/currencies_model.dart';
import 'package:mdiho/features/transaction/data/model/response/rates_model/rates_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

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

  Future<bool> getTransactions() async {
    state = state.copyWith(transactions: const AsyncValue.loading());

    final result = await _authenticationRepository.getTransactions();
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
          sellCrypto: AsyncValue.data(result.getSuccess() ?? ''),
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
    state = state.copyWith(sellCrypto: const AsyncValue.loading());

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
          sellCrypto:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          sellCrypto: AsyncValue.data(result.getSuccess() ?? ''),
        );
        return true;
      },
    );
  }
}
