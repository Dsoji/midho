import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../common/api/api_client.dart';
import '../../../../common/api/api_request_helper.dart';
import '../../../../common/api/dio_api_client.dart';
import '../../../../common/utils/utils.dart';
import '../../../profile/data/Model/response/user_profile_model/user_profile_model.dart';
import '../../../suggestion_box/data/response/upload_response/upload_response.dart';
import '../model/payload/profile_payload.dart';
import '../model/payload/sign_up_payload.dart';
import '../model/response/user_model/user_model.dart';

final logger = Logger();
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
String? accessToken = box.get('accessToken');

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
        final token = data['token'];
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
        print(data);
        final token = data['token'];
        var box = Hive.box('data');
        box.put('accessToken', token);
        return UserModel.fromMap(data);
      },
      showErrorToast: true,
    );
  }

  Future<ResultValue<String>> emailVerification({
    required String email,
    required String? referral,
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

  Future<ResultValue<String>> updateProfile({
    ProfilePayload? payload,
  }) async {
    final String accessToken = await box.get('accessToken');

    return apiRequestHelper.handleApiRequest(
      () => apiClient.post(
        'user/profile/updateProfile',
        header: {
          'Authorization': 'Bearer $accessToken',
        },
        data: payload,
      ),
      parser: (data) {
        print(data);
        return BaseModel.toRawString(data);
      },
      showErrorToast: true,
      showSuccessToast: true,
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
      // showSuccessToast: true,
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
      showSuccessToast: true,
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
      showSuccessToast: true,
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
      showSuccessToast: true,
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
      showSuccessToast: true,
    );
  }

  Future<ResultValue<UploadResponse>> updateImage(dynamic data) async {
    return await apiRequestHelper.handleApiRequest<UploadResponse>(
      () => apiClient.post(
        'mediaUpload',
        data: data,
        header: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      parser: (data) {
        logger.d(data);
        return UploadResponse.fromMap(data);
      },
      showErrorToast: true,
    );
  }
}
