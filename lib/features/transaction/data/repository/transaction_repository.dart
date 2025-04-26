import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/referral_screen/data/model/response/referall_model/referall_model.dart';
import 'package:mdiho/features/referral_screen/data/model/response/rewards_model/rewards_model.dart';
import 'package:mdiho/features/transaction/data/model/response/currencies_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../../../../common/utils/multiple_results.dart';
import '../../../../common/utils/utils.dart';
import '../model/response/rates_model/rates_model.dart';
import '../model/response/transaction_history/datum.dart';
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

  Future<Result<FailureHandler, TransactionHistory>> getTransactions({
    String? status,
    String? type,
    String? startDate,
    String? endDate,
    String sortKey = 'createdAt',
    String sortOrder = 'DESC',
  }) async {
    try {
      final data = await transactionService.getTransactions(
        status: status,
        type: type,
        startDate: startDate,
        endDate: endDate,
        sortKey: sortKey,
        sortOrder: sortOrder,
      );

      if (data.isSuccess) {
        return Success(data.value ?? TransactionHistory());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch transactions',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch transactions'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, RatesModel>> getRates() async {
    try {
      final data = await transactionService.getRates();

      if (data.isSuccess && data.value != null) {
        final rates = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put('rates', rates.toMap());

        return Success(rates);
      } else {
        var box = Hive.box('data');
        final cachedRates = box.get('rates');

        if (cachedRates != null && cachedRates is Map<String, dynamic>) {
          final cachedRate = RatesModel.fromMap(cachedRates);
          return Success(cachedRate);
        }

        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch rates',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch rates'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      var box = Hive.box('data');
      final cachedRates = box.get('rates');

      if (cachedRates != null && cachedRates is Map<String, dynamic>) {
        final cachedRate = RatesModel.fromMap(cachedRates);
        return Success(cachedRate);
      }
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, CurrenciesModel>> getCurrency() async {
    try {
      final data = await transactionService.getCurrencies();

      if (data.isSuccess) {
        return Success(data.value ?? CurrenciesModel());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch currencies',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch currencies'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, TransactionData>> sellCrypto({
    String? id,
    String? name,
    int? amount,
    String? comment,
    List<String>? files,
  }) async {
    try {
      final data = await transactionService.sellCrypto(
        id: id,
        name: name,
        amount: amount,
        comment: comment,
        files: files,
      );

      if (data.isSuccess) {
        return Success(data.value ?? TransactionData());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to carry out transaction',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to carry out transaction'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> sellGiftCards({
    String? id,
    String? name,
    int? amount,
    String? comment,
    List<String>? files,
    bool? ecode,
    String? code,
    String? pin,
  }) async {
    try {
      final data = await transactionService.sellGiftCards(
        id: id,
        name: name,
        amount: amount,
        comment: comment,
        files: files,
        ecode: ecode,
        code: code,
        pin: pin,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to carry out transaction',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to carry out transaction'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, ReferallModel>> getReferrals() async {
    try {
      final data = await transactionService.getReferrals();

      if (data.isSuccess && data.value != null) {
        final referalls = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put('referalls', referalls.toMap());

        return Success(referalls);
      } else {
        var box = Hive.box('data');
        final cachedReferalls = box.get('referalls');

        if (cachedReferalls != null &&
            cachedReferalls is Map<String, dynamic>) {
          final cachedReferall = ReferallModel.fromMap(cachedReferalls);
          return Success(cachedReferall);
        }

        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch rates',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch rates'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      var box = Hive.box('data');
      final cachedReferalls = box.get('referalls');

      if (cachedReferalls != null && cachedReferalls is Map<String, dynamic>) {
        final cachedRate = ReferallModel.fromMap(cachedReferalls);
        return Success(cachedRate);
      }
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, RewardsModel>> getRewards() async {
    try {
      final data = await transactionService.getRewards();
      if (data.isSuccess && data.value != null) {
        final rewards = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put('rewards', rewards.toMap());

        return Success(rewards);
      } else {
        var box = Hive.box('data');
        final cachedRewards = box.get('rewards');

        if (cachedRewards != null && cachedRewards is Map<String, dynamic>) {
          final cachedReward = RewardsModel.fromMap(cachedRewards);
          return Success(cachedReward);
        }

        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch rates',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch rates'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      var box = Hive.box('data');
      final cachedRewards = box.get('rewards');

      if (cachedRewards != null && cachedRewards is Map<String, dynamic>) {
        final cachedReward = RewardsModel.fromMap(cachedRewards);
        return Success(cachedReward);
      }
      return Error(failure);
    }
  }
}
