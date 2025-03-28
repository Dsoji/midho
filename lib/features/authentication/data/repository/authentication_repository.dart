import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/utils/multiple_results.dart';
import '../../../../common/utils/utils.dart';
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
  }) async {
    try {
      final data = await authService.signInUser(
        email: email,
        password: pswrd,
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
    required String referral,
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
}
