import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/api/api_client.dart';
import '../../../../common/api/api_request_helper.dart';
import '../../../../common/api/dio_api_client.dart';
import '../../../../common/utils/utils.dart';
import '../model/payload/sign_up_payload.dart';
import '../model/response/user_model/user_model.dart';

final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  final dioApiClient = ref.watch(dioApiClientProvider);
  final apiRequestHelper = ref.watch(apiRequestHelperProvider);
  return AuthenticationService(
    apiClient: dioApiClient,
    apiRequestHelper: apiRequestHelper,
  );
});

var box = Hive.box('data');
String? deviceId = box.get('device_id');
String storedToken = box.get('fcm_token');

class AuthenticationService {
  final IApiClient apiClient;
  final ApiRequestHelper apiRequestHelper;

  AuthenticationService({
    required this.apiClient,
    required this.apiRequestHelper,
  });

  Future<ResultValue<UserModel>> signInUser({
    required String email,
    required String password,
  }) async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/auth/signin',
        data: {
          'emailorusername': email,
          'password': password,
          'device': deviceId,
          'fcmToken': storedToken,
        },
      ),
      parser: (data) {
        print(data);
        final token = data['accessToken'];
        var box = Hive.box('data');
        box.put('accessToken', token);
        return UserModel.fromMap(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<UserModel>> registerUser(
      {required SignUpPayload payload}) async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/auth/signup',
        data: payload,
      ),
      parser: (data) {
        return UserModel.fromMap(data);
      },
      showErrorToast: true,
    );
  }

  Future<ResultValue<String>> emailVerification({
    required String email,
    required String referral,
    required String endpoint,
  }) async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'emailVerification',
        data: {
          "email": email,
          "referral": referral,
          "endpoint": endpoint,
        },
      ),
      parser: (data) {
        print(data);
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }

  Future<ResultValue<String>> emailConfirmation({
    required String email,
    required String code,
    required String endpoint,
  }) async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'emailConfirmation',
        data: {
          "email": email,
          "code": code,
          "endpoint": endpoint,
        },
      ),
      parser: (data) {
        print(data);
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
    );
  }

  Future<ResultValue<String>> forgotPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/auth/resetPassword',
        data: {
          "email": email,
          "code": code, // reset code gotten by calling emailVerification
          "password": password, // the new password
          "device": deviceId,
        },
      ),
      parser: (data) {
        print(data);
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
    );
  }
}
