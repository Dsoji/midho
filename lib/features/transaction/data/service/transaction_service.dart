import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/transaction/data/model/response/currencies_model.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../../../../common/api/api_client.dart';
import '../../../../common/api/api_request_helper.dart';
import '../../../../common/api/dio_api_client.dart';
import '../../../../common/utils/utils.dart';
import '../../../referral_screen/data/model/response/referall_model/referall_model.dart';
import '../../../referral_screen/data/model/response/rewards_model/rewards_model.dart';
import '../model/response/rates_model/rates_model.dart';

final logger = Logger();
final transactionServiceProvider = Provider<TransactionService>((ref) {
  final dioApiClient = ref.watch(dioApiClientProvider);
  final apiRequestHelper = ref.watch(apiRequestHelperProvider);
  return TransactionService(
    apiClient: dioApiClient,
    apiRequestHelper: apiRequestHelper,
  );
});

var box = Hive.box('data');
String? deviceId = box.get('device_id');
String storedToken = box.get('fcm_token');
String? accessToken = box.get('accessToken');

class TransactionService {
  final IApiClient apiClient;
  final ApiRequestHelper apiRequestHelper;

  TransactionService({
    required this.apiClient,
    required this.apiRequestHelper,
  });

  Future<ResultValue<TransactionHistory>> getTransactions({
    String? status,
    String? type,
    String? startDate,
    String? endDate,
    String sortKey = 'createdAt',
    String sortOrder = 'DESC',
  }) async {
    final queryParameters = {
      'paginate': false,
      'page': 1,
      'limit': 500,
      'sortKey': sortKey,
      'sortOrder': sortOrder,
    };

    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }
    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }
    if (startDate != null && startDate.isNotEmpty) {
      queryParameters['startDate'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParameters['endDate'] = endDate;
    }

    return apiRequestHelper.handleApiRequest(
      () => apiClient.get(
        'user/tx/txs',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: queryParameters,
      ),
      parser: (data) => TransactionHistory.fromMap(data),
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<RatesModel>> getRates() async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.get(
        'rates',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          'paginate': false,
          'page': 1,
          'limit': 500,
        },
      ),
      parser: (data) {
        return RatesModel.fromMap(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<CurrenciesModel>> getCurrencies() async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.get(
        'currencies',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      parser: (data) {
        return CurrenciesModel.fromMap(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<String>> sellCrypto({
    String? id,
    String? name,
    int? amount,
    String? comment,
    List<String>? files,
  }) async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/tx/sellCrypto',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "asset": {
            "id": id,
            "name": name,
          },
          "amount": amount,
          "files": files,
          "comment": comment
        },
      ),
      parser: (data) {
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<String>> sellGiftCards({
    String? id,
    String? name,
    int? amount,
    String? comment,
    List<String>? files,
    bool? ecode,
    String? code,
    String? pin,
  }) async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/tx/sellCrypto',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "asset": {
            "id": id,
            "name": name,
          },
          "amount": amount,
          "files": files,
          "ecode": ecode,
          "code": code, // required only when ecode is true
          "pin": pin, // required only when ecode is true
          "comment": comment
        },
      ),
      parser: (data) {
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<ReferallModel>> getReferrals() async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.get(
        'user/reward/referrals',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          'paginate': true,
          'page': 1,
          'limit': 10,
        },
      ),
      parser: (data) {
        return ReferallModel.fromMap(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<RewardsModel>> getRewards() async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.get(
        'user/reward/rewards',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          'paginate': true,
          'page': 1,
          'limit': 10,
        },
      ),
      parser: (data) {
        return RewardsModel.fromMap(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }
}
