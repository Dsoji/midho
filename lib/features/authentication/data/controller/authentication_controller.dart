import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/authentication/data/model/payload/profile_payload.dart';
import 'package:mdiho/features/authentication/data/model/payload/sign_up_payload.dart';
import 'package:mdiho/features/authentication/data/model/response/user_model/user_model.dart';

import '../../../profile/data/Model/response/user_profile_model/user_profile_model.dart';
import '../repository/authentication_repository.dart';
import '../state/authentication_state.dart';

final logger = Logger();
final authenticationControllerProvider =
    StateNotifierProvider<AuthenticationController, AuthenticationState>((ref) {
  final authenticationRepository = ref.watch(authenticationRepositoryProvider);
  return AuthenticationController(
    authenticationRepository: authenticationRepository,
    ref: ref,
  );
});

class AuthenticationController extends StateNotifier<AuthenticationState> {
  AuthenticationController({
    required AuthenticationRepository authenticationRepository,
    required this.ref,
  })  : _authenticationRepository = authenticationRepository,
        super(
          AuthenticationState.initial(),
        ) {
    // geAuthCredential();
  }

  final AuthenticationRepository _authenticationRepository;
  final Ref ref;

  void resetAuthStatus() {
    if (state.status != AuthenticationStatus.idle) {
      state = state.copyWith(status: AuthenticationStatus.idle);
    }
  }

  Future<bool> signIn(
    String email,
    String password, {
    bool isLoggingIn = true,
    bool biometric = false,
  }) async {
    state = state.copyWith(login: const AsyncValue.loading());

    final result = await _authenticationRepository.authSignIn(
      email: email,
      pswrd: password,
      biometric: biometric,
    );
    return result.when(
      (error) {
        state = state.copyWith(
          login: AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          login: AsyncValue.data(result.getSuccess() ?? UserModel()),
          status: AuthenticationStatus.loginSuccessful,
        );
        return true;
      },
    );
  }

  void updateSignUpDetails(SignUpPayload newDetails) {
    state = state.copyWith(signUpPayload: AsyncValue.data(newDetails));
  }

  void updateProfileDetails(ProfilePayload newDetails) {
    state = state.copyWith(profilePayload: AsyncValue.data(newDetails));
  }

  Future<bool> signUp(SignUpPayload payload) async {
    state = state.copyWith(signUp: const AsyncValue.loading());

    final result = await _authenticationRepository.authSignUp(
      payload: payload,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          signUp: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          signUp: AsyncValue.data(success),
          status: AuthenticationStatus.verifySignUp,
        );
        return true;
      },
    );
  }

  Future<bool> emailVerify(
    String email,
    String? referral,
    String endpoint,
  ) async {
    state = state.copyWith(emailVerification: const AsyncValue.loading());

    final result = await _authenticationRepository.emailVerify(
      email: email,
      referral: referral,
      endpoint: endpoint,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          emailVerification: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          emailVerification: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> emailConfirm(
    String email,
    String code,
    String endpoint,
  ) async {
    state = state.copyWith(emailConfirmation: const AsyncValue.loading());

    final result = await _authenticationRepository.emailConfirm(
      email: email,
      code: code,
      endpoint: endpoint,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          emailConfirmation: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          emailConfirmation: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> forgotPassword(
    String email,
    String code,
    String password,
  ) async {
    state = state.copyWith(forgotPassword: const AsyncValue.loading());

    final result = await _authenticationRepository.forgotPassword(
      email: email,
      code: code,
      password: password,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          forgotPassword: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          forgotPassword: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> updateProfile(
    ProfilePayload payload,
  ) async {
    state = state.copyWith(forgotPassword: const AsyncValue.loading());

    final result = await _authenticationRepository.updateProfile(
      payload: payload,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          forgotPassword: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          forgotPassword: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> fetchProfile() async {
    final raw = Hive.box('data').get('userProfile');

    if (raw != null && raw is Map) {
      try {
        // Manually build a properly typed Map<String, dynamic>
        final Map<String, dynamic> fixedMap = {};
        for (var entry in raw.entries) {
          if (entry.key is String) {
            fixedMap[entry.key] = entry.value;
          } else {
            fixedMap[entry.key.toString()] = entry.value;
          }
        }

        final cachedProfile = UserProfileModel.fromMap(fixedMap);
        state = state.copyWith(userDetails: AsyncValue.data(cachedProfile));
        logger.d('✅ Loaded cached profile from normalized map.');
      } catch (e, stack) {
        logger.e('⛔ Failed to parse normalized profile: $e', stackTrace: stack);
        state = state.copyWith(userDetails: const AsyncValue.loading());
      }
    } else {
      logger.w('No cached profile found.');
      state = state.copyWith(userDetails: const AsyncValue.loading());
    }
    final result = await _authenticationRepository.fetchProfileDetails();

    return result.when(
      (error) {
        state = state.copyWith(
          userDetails: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          userDetails: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> updateUsername(
    String payload,
  ) async {
    state = state.copyWith(userName: const AsyncValue.loading());

    final result = await _authenticationRepository.updateUsername(
      name: payload,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          userName: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          userName: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> updateEmail(
    String payload,
    String code,
  ) async {
    state = state.copyWith(emailChange: const AsyncValue.loading());

    final result = await _authenticationRepository.updateEmail(
      email: payload,
      code: code,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          emailChange: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          emailChange: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> changePassword(
    String password,
    String oldPassword,
  ) async {
    state = state.copyWith(forgotPassword: const AsyncValue.loading());

    final result = await _authenticationRepository.updatePswrd(
      password: password,
      oldPassword: oldPassword,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          forgotPassword: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          forgotPassword: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> changePin(
    String email,
    String code,
    String pin,
  ) async {
    state = state.copyWith(resetPin: const AsyncValue.loading());

    final result = await _authenticationRepository.updatePin(
      email: email,
      pin: pin,
      code: code,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          resetPin: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          resetPin: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> uploadMultipleFiles(List<File> files) async {
    state = state.copyWith(imageUpload: const AsyncValue.loading());

    final formData = FormData();

    for (var file in files) {
      final fileName = file.path.split('/').last;

      formData.files.add(
        MapEntry(
          "file", // 👈 This must match what the backend expects
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType('image', fileName.split('.').last),
          ),
        ),
      );
    }

    final result = await _authenticationRepository.uploadImage(formData);

    return result.when(
      (error) {
        state = state.copyWith(
          imageUpload: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          imageUpload: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> fetchNotification() async {
    state = state.copyWith(notification: const AsyncValue.loading());

    final result = await _authenticationRepository.getNotification();

    return result.when(
      (error) {
        state = state.copyWith(
          notification: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          notification: AsyncValue.data(success),
        );
        return true;
      },
    );
  }
}
