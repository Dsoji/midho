import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/transaction/data/model/response/transaction_history/transaction_history.dart';

import '../../../../common/api/api_client.dart';
import '../../../../common/api/api_request_helper.dart';
import '../../../../common/api/dio_api_client.dart';

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

  Future<ResultValue<TransactionHistory>> getTransactions() async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.get(
        'user/tx/txs',
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
        return TransactionHistory.fromMap(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }
}
