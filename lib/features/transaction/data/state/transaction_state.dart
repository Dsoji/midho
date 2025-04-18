import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

class TransactionState {
  final AsyncValue<TransactionHistory> transactions;

  const TransactionState({
    required this.transactions,
  });

  factory TransactionState.initial() {
    return TransactionState(
      transactions: AsyncValue.data(TransactionHistory()),
    );
  }

  TransactionState copyWith({
    AsyncValue<TransactionHistory>? transactions,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  String toString() {
    return 'TransactionState(login: $transactions, )';
  }

  @override
  bool operator ==(covariant TransactionState other) {
    if (identical(this, other)) return true;

    return other.transactions == transactions;
  }

  @override
  int get hashCode {
    return transactions.hashCode;
  }
}
