import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/notification/data/model/response/notifcation_list/notifcation_list.dart';

import '../../../../common/utils/multiple_results.dart';
import '../../../../common/utils/utils.dart';
import '../../../profile/data/Model/response/user_profile_model/user_profile_model.dart';
import '../../../suggestion_box/data/response/upload_response/upload_response.dart';
import '../model/payload/profile_payload.dart';
import '../model/payload/sign_up_payload.dart';
import '../model/response/user_model/user_model.dart';
import '../service/authentication_service.dart';

final authenticationRepositoryProvider = Provider((ref) {
  final authenticationService = ref.watch(authenticationServiceProvider);
  return AuthenticationRepository(
    authenticationService,
  );
});

class AuthenticationRepository {
  AuthenticationRepository(
    this.authService,
  );

  final AuthenticationService authService;

  Future<Result<FailureHandler, UserModel>> authSignIn({
    required String email,
    required String pswrd,
    required bool biometric,
  }) async {
    try {
      final data = await authService.signInUser(
        email: email,
        password: pswrd,
        biometric: biometric,
      );

      if (data.isSuccess) {
        return Success(data.value ?? UserModel());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch products',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch products'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, UserModel>> authSignUp(
      {required SignUpPayload payload}) async {
    try {
      final data = await authService.registerUser(payload: payload);

      if (data.isSuccess) {
        return Success(data.value ?? UserModel());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch products',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch products'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> emailVerify({
    required String email,
    required String? referral,
    required String endpoint,
  }) async {
    try {
      final data = await authService.emailVerification(
        email: email,
        referral: referral,
        endpoint: endpoint,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to verify email',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to verify email'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> emailConfirm({
    required String email,
    required String code,
    required String endpoint,
  }) async {
    try {
      final data = await authService.emailConfirmation(
        email: email,
        code: code,
        endpoint: endpoint,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to confirm email',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to confirm email'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> forgotPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      final data = await authService.forgotPassword(
        email: email,
        code: code,
        password: password,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to rest password',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to rest password'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> updateProfile({
    ProfilePayload? payload,
  }) async {
    try {
      final data = await authService.updateProfile(payload: payload);

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to update profile',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to update profile'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, UserProfileModel>> fetchProfileDetails({
    ProfilePayload? payload,
  }) async {
    try {
      final data = await authService.fetchUserInfo();

      if (data.isSuccess && data.value != null) {
        final profile = data.value!;

        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put('userProfile', profile.toMap());

        return Success(profile);
      } else {
        // Fallback to local cache if fetch failed
        var box = Hive.box('data');
        final cachedMap = box.get('userProfile');

        if (cachedMap != null && cachedMap is Map<String, dynamic>) {
          final cachedProfile = UserProfileModel.fromMap(cachedMap);
          return Success(cachedProfile);
        }

        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch profile',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch profile'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      // Fallback to cache on exception too
      var box = Hive.box('data');
      final cachedMap = box.get('userProfile');

      if (cachedMap != null && cachedMap is Map<String, dynamic>) {
        final cachedProfile = UserProfileModel.fromMap(cachedMap);
        return Success(cachedProfile);
      }

      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> updateUsername({
    required String name,
  }) async {
    try {
      final data = await authService.changeUsername(
        username: name,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to change username',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to change username'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> updateEmail({
    required String email,
    required String code,
  }) async {
    try {
      final data = await authService.changeEmail(
        email: email,
        code: code,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to change email',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to change email'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> updatePswrd({
    required String password,
    required String oldPassword,
  }) async {
    try {
      final data = await authService.changePswrd(
        password: password,
        oldPassword: oldPassword,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to change password',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to change password'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> updatePin({
    required String email,
    required String pin,
    required String code,
  }) async {
    try {
      final data = await authService.changePin(
        email: email,
        pin: pin,
        code: code,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to change password',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to change password'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, UploadResponse>> uploadImage(
      dynamic payload) async {
    try {
      final data = await authService.updateImage(payload);

      if (data.isSuccess) {
        return Success(data.value ?? UploadResponse());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to update image',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to update image'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, NotifcationList>> getNotification() async {
    try {
      final data = await authService.getNotification();

      if (data.isSuccess) {
        return Success(data.value ?? NotifcationList());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch notifications',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch notification'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }
}
