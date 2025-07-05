import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../common/api/api_client.dart';
import '../../../../common/api/api_request_helper.dart';
import '../../../../common/api/dio_api_client.dart';
import '../model/response/gift_card_model/gift_card_model.dart';

final logger = Logger();
final giftCardServiceProvider = Provider<GiftCardService>((ref) {
  final dioApiClient = ref.watch(dioApiClientProvider);
  final apiRequestHelper = ref.watch(apiRequestHelperProvider);
  return GiftCardService(
    apiClient: dioApiClient,
    apiRequestHelper: apiRequestHelper,
  );
});

var box = Hive.box('data');
String? deviceId = box.get('device_id');
String storedToken = box.get('fcm_token');
String? accessToken = box.get('accessToken');

class GiftCardService {
  final IApiClient apiClient;
  final ApiRequestHelper apiRequestHelper;

  GiftCardService({
    required this.apiClient,
    required this.apiRequestHelper,
  });

  Future<ResultValue<GiftCardModel>> getCategories() async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.get(
        'categories',
        queryParameters: {
          'paginate': false,
          'page': 1,
          'limit': 500,
          'active': true,
        },
      ),
      parser: (data) {
        return GiftCardModel.fromMap(data);
      },
      showErrorToast: true,
      // showSuccessToast: true,
    );
  }
}
