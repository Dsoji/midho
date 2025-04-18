import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../../../../common/utils/multiple_results.dart';
import '../../../../common/utils/utils.dart';
import '../service/transaction_service.dart';

final transactionRepositoryProvider = Provider((ref) {
  final authenticationService = ref.watch(transactionServiceProvider);
  return TransactionRepository(
    authenticationService,
  );
});

class TransactionRepository {
  TransactionRepository(
    this.transactionService,
  );

  final TransactionService transactionService;

  Future<Result<FailureHandler, TransactionHistory>> getTransactions() async {
    try {
      final data = await transactionService.getTransactions();

      if (data.isSuccess) {
        return Success(data.value ?? TransactionHistory());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch categories',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch categories'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }
}
