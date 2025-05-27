import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/referral_screen/data/model/response/referall_model/referall_model.dart';
import 'package:mdiho/features/referral_screen/data/model/response/rewards_model/rewards_model.dart';
import 'package:mdiho/features/transaction/data/model/response/currencies_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../../../../common/utils/multiple_results.dart';
import '../../../../common/utils/utils.dart';
import '../../../bank_network/data/model/response/acct_name_model/acct_name_model.dart';
import '../../../bills/data/model/response/airtime_electric_model/airtime_electric_model.dart';
import '../../../bills/data/model/response/airtime_transaction/airtime_transaction.dart';
import '../../../bills/data/model/response/data_tv_model/data_tv_model.dart';
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

  Future<Result<FailureHandler, TransactionData>> sellGiftCards({
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

  Future<Result<FailureHandler, String>> addBanks({
    required String acctName,
    required String acctNo,
    required String bankName,
    required String bankCode,
  }) async {
    try {
      final data = await transactionService.addBanks(
        acctName: acctName,
        acctNo: acctNo,
        bankName: bankName,
        bankCode: bankCode,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
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

  Future<Result<FailureHandler, AcctNameModel>> getAcctname({
    required String acctNo,
    required String bankCode,
  }) async {
    try {
      final data = await transactionService.getAcctName(
        acctNo: acctNo,
        bankCode: bankCode,
      );

      if (data.isSuccess) {
        return Success(data.value ?? AcctNameModel());
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

  Future<Result<FailureHandler, String>> deleteAcct({
    required String acctId,
  }) async {
    try {
      final data = await transactionService.deleteAcct(
        acctId: acctId,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
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

  Future<Result<FailureHandler, AirtimeTransaction>> buyAirtime({
    required String assetId,
    required int amount,
    required String accountNumber,
    required String pin,
  }) async {
    try {
      final data = await transactionService.buyAirtime(
        assetId: assetId,
        amount: amount,
        accountNumber: accountNumber,
        pin: pin,
      );

      if (data.isSuccess) {
        return Success(data.value ?? AirtimeTransaction());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to buy airtime',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to buy airtime'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, AirtimeTransaction>> buyData({
    required String assetId,
    required String accountNumber,
    required String pin,
  }) async {
    try {
      final data = await transactionService.buyData(
        assetId: assetId,
        accountNumber: accountNumber,
        pin: pin,
      );

      if (data.isSuccess) {
        return Success(data.value ?? AirtimeTransaction());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to buy data',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to buy data'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, AirtimeTransaction>> buyElectricity({
    required String assetId,
    required int amount,
    required String accountNumber,
    required String pin,
  }) async {
    try {
      final data = await transactionService.buyElectricity(
        assetId: assetId,
        amount: amount,
        accountNumber: accountNumber,
        pin: pin,
      );

      if (data.isSuccess) {
        return Success(data.value ?? AirtimeTransaction());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to buy electricity',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to buy electricity'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, AirtimeTransaction>> buyCableTv({
    required String assetId,
    required String accountNumber,
    required String pin,
  }) async {
    try {
      final data = await transactionService.buyCableTv(
        assetId: assetId,
        accountNumber: accountNumber,
        pin: pin,
      );

      if (data.isSuccess) {
        return Success(data.value ?? AirtimeTransaction());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to buy cable TV',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to buy cable TV'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, List<DataTvModel>>> getDataPlans() async {
    try {
      final data = await transactionService.fetchDataPlans();
      if (data.isSuccess && data.value != null) {
        final dataPlans = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put('dataPlans', dataPlans.map((e) => e.toMap()).toList());

        return Success(dataPlans);
      } else {
        var box = Hive.box('data');
        final cachedDataPlans = box.get('dataPlans');

        if (cachedDataPlans != null &&
            cachedDataPlans is List<Map<String, dynamic>>) {
          final cachedDataPlan =
              cachedDataPlans.map((e) => DataTvModel.fromMap(e)).toList();
          return Success(cachedDataPlan);
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
      final cachedDataPlans = box.get('dataPlans');

      if (cachedDataPlans != null &&
          cachedDataPlans is List<Map<String, dynamic>>) {
        final cachedDataPlan =
            cachedDataPlans.map((e) => DataTvModel.fromMap(e)).toList();
        return Success(cachedDataPlan);
      }
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, List<DataTvModel>>> getCableTvPlans() async {
    try {
      final data = await transactionService.fetchCableTvPlans();
      if (data.isSuccess && data.value != null) {
        final cableTvPlans = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put(
            'cableTvPlans', cableTvPlans.map((e) => e.toMap()).toList());

        return Success(cableTvPlans);
      } else {
        var box = Hive.box('data');
        final cachedCableTvPlans = box.get('cableTvPlans');

        if (cachedCableTvPlans != null &&
            cachedCableTvPlans is List<Map<String, dynamic>>) {
          final cachedCableTvPlan =
              cachedCableTvPlans.map((e) => DataTvModel.fromMap(e)).toList();
          return Success(cachedCableTvPlan);
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
      final cachedCableTvPlans = box.get('cableTvPlans');

      if (cachedCableTvPlans != null &&
          cachedCableTvPlans is List<Map<String, dynamic>>) {
        final cachedCableTvPlan =
            cachedCableTvPlans.map((e) => DataTvModel.fromMap(e)).toList();
        return Success(cachedCableTvPlan);
      }
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, List<AirtimeElectricModel>>>
      getElectricalPlans() async {
    try {
      final data = await transactionService.fetchElectricityPlans();
      if (data.isSuccess && data.value != null) {
        final electricityPlans = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put('electricityPlans',
            electricityPlans.map((e) => e.toMap()).toList());

        return Success(electricityPlans);
      } else {
        var box = Hive.box('data');
        final cachedElectricityPlans = box.get('electricityPlans');

        if (cachedElectricityPlans != null &&
            cachedElectricityPlans is List<Map<String, dynamic>>) {
          final cachedElectricityPlan = cachedElectricityPlans
              .map((e) => AirtimeElectricModel.fromMap(e))
              .toList();
          return Success(cachedElectricityPlan);
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
      final cachedElectricityPlans = box.get('electricityPlans');

      if (cachedElectricityPlans != null &&
          cachedElectricityPlans is List<Map<String, dynamic>>) {
        final cachedElectricityPlan = cachedElectricityPlans
            .map((e) => AirtimeElectricModel.fromMap(e))
            .toList();
        return Success(cachedElectricityPlan);
      }
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, List<AirtimeElectricModel>>>
      getAirtimePlans() async {
    try {
      final data = await transactionService.fetchAirtimePlans();
      if (data.isSuccess && data.value != null) {
        final airtimePlans = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put(
            'airtimePlans', airtimePlans.map((e) => e.toMap()).toList());

        return Success(airtimePlans);
      } else {
        var box = Hive.box('data');
        final cachedAirtimePlans = box.get('airtimePlans');

        if (cachedAirtimePlans != null &&
            cachedAirtimePlans is List<Map<String, dynamic>>) {
          final cachedAirtimePlan = cachedAirtimePlans
              .map((e) => AirtimeElectricModel.fromMap(e))
              .toList();
          return Success(cachedAirtimePlan);
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
      final cachedAirtimePlans = box.get('airtimePlans');

      if (cachedAirtimePlans != null &&
          cachedAirtimePlans is List<Map<String, dynamic>>) {
        final cachedAirtimePlan = cachedAirtimePlans
            .map((e) => AirtimeElectricModel.fromMap(e))
            .toList();
        return Success(cachedAirtimePlan);
      }
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> withdraw({
    String? acctNo,
    int? amount,
    bool? referall,
    String? accountName,
    String? bankName,
    String? bankCode,
    required String pin,
  }) async {
    try {
      final data = await transactionService.withdrawal(
        acctNo: acctNo,
        amount: amount,
        referall: referall,
        pin: pin,
        accountName: accountName,
        bankName: bankName,
        bankCode: bankCode,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to process withdrawal',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to process withdrawal'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }
}
