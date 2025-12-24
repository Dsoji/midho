import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/bank_network/data/model/response/bank_list/bank_list.dart';
import 'package:mdiho/features/kyc/data/model/kyc_payload.dart';
import 'package:mdiho/features/support_faq/data/model/response/faq_response/faq_response.dart';

import '../../../../common/api/api.dart';
import '../../../../common/api/api_request_helper.dart';
import '../../../../common/utils/utils.dart';
import '../../../authentication/data/model/payload/profile_payload.dart';
import '../../../suggestion_box/data/payload/suggestion_payload.dart';
import '../Model/response/user_profile_model/user_profile_model.dart';

final profileServiceProvider = Provider<ProfileeService>((ref) {
  final dioApiClient = ref.watch(dioApiClientProvider);
  final apiRequestHelper = ref.watch(apiRequestHelperProvider);
  return ProfileeService(
    apiClient: dioApiClient,
    apiRequestHelper: apiRequestHelper,
  );
});

var box = Hive.box('data');
String? deviceId = box.get('device_id');
String storedToken = box.get('fcm_token');
String? accessToken = box.get('accessToken');
final logger = Logger();

class ProfileeService {
  final IApiClient apiClient;
  final ApiRequestHelper apiRequestHelper;

  ProfileeService({
    required this.apiClient,
    required this.apiRequestHelper,
  });

  Future<ResultValue<String>> updateProfile({
    ProfilePayload? payload,
  }) async {
    logger.d("here is   access token: $accessToken");
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/profile/updateProfile',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: payload,
      ),
      parser: (data) {
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<String>> updatePin({
    required String pin,
  }) async {
    logger.d("here is pin in service: $pin");

    logger.d("here is   access token: $accessToken");
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/profile/updateProfile',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "pin": pin,
        },
      ),
      parser: (data) {
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<UserProfileModel>> fetchUserInfo() async {
    final String accessToken = await box.get('accessToken');
    return await apiRequestHelper.handleApiRequest<UserProfileModel>(
      () => apiClient.get(
        'user/profile',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      parser: (data) => UserProfileModel.fromMap(data),
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<String>> changeUsername({required String username}) async {
    final String accessToken = await box.get('accessToken');
    return await apiRequestHelper.handleApiRequest<String>(
      () => apiClient.post(
        'user/profile/changeUsername',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "username": username,
        },
      ),
      parser: (data) => BaseModel.toRawString(data),
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<String>> changeEmail({
    required String email,
    required String code,
  }) async {
    final String accessToken = await box.get('accessToken');
    return await apiRequestHelper.handleApiRequest<String>(
      () => apiClient.post(
        'user/profile/changeEmail',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "email": email,
          "code": code,
          "device": deviceId,
        },
      ),
      parser: (data) => BaseModel.toRawString(data),
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<String>> changePswrd({
    required String password,
    required String oldPassword,
  }) async {
    final String accessToken = await box.get('accessToken');
    return await apiRequestHelper.handleApiRequest<String>(
      () => apiClient.post(
        'user/auth/changePassword',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "pastword": oldPassword, // the previous password
          "password": password,
        },
      ),
      parser: (data) => BaseModel.toRawString(data),
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<String>> changePin({
    required String email,
    required String code,
    required String pin,
  }) async {
    return await apiRequestHelper.handleApiRequest<String>(
      () => apiClient.post(
        'user/auth/resetPin',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          "email": email,
          "code": code, // reset code gotten by calling emailVerification
          "pin": pin, // the new pin
          "device": deviceId
        },
      ),
      parser: (data) => BaseModel.toRawString(data),
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<FaqResponse>> fetchFaq() async {
    return await apiRequestHelper.handleApiRequest<FaqResponse>(
      () => apiClient.get(
        'user/faq/faqs',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        queryParameters: {
          'pagination': false,
        },
      ),
      parser: (data) {
        logger.d(data);
        return FaqResponse.fromMap(data);
      },
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<String>> postFeedBack({
    required SuggestionPayload payload,
  }) async {
    return await apiRequestHelper.handleApiRequest<String>(
      () => apiClient.post(
        'user/feedback',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: payload,
      ),
      parser: (data) {
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<List<BanlList>>> getBankList() async {
    return await apiRequestHelper.handleApiRequest<List<BanlList>>(
      () => apiClient.get(
        'banks',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      parser: (data) {
        // ✅ If `data` is already List<dynamic>
        return (data as List<dynamic>).map((e) => BanlList.fromMap(e)).toList();
      },
      showErrorToast: true,
      showSuccessToast: false,
    );
  }

  Future<ResultValue<String>> kycVerification({
    required KycPayload payload,
  }) async {
    return await apiRequestHelper.handleApiRequest<String>(
      () => apiClient.post(
        'user/kyc/verify',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: payload,
      ),
      parser: (data) {
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }
}
