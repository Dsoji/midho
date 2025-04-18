import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../repository/transaction_repository.dart';
import '../state/transaction_state.dart';

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
}
