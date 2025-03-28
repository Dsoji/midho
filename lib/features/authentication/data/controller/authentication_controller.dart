import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/data/model/payload/sign_up_payload.dart';
import 'package:mdiho/features/authentication/data/model/response/user_model/user_model.dart';

import '../repository/authentication_repository.dart';
import '../state/authentication_state.dart';

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
  }) async {
    state = state.copyWith(login: const AsyncValue.loading());

    final result = await _authenticationRepository.authSignIn(
      email: email,
      pswrd: password,
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
    String referral,
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
}
