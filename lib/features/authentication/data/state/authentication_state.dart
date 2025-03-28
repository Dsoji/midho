import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/payload/sign_up_payload.dart';
import '../model/response/user_model/user_model.dart';

enum AuthenticationStatus {
  verifySignUp,
  verificationSuccessful,
  verifyForgotPassword,
  forgotPassword,
  loginSuccessful,
  login,
  idle,
}

class AuthenticationState {
  final AsyncValue<UserModel> login;
  final AuthenticationStatus status;
  final AsyncValue<UserModel> signUp;
  final AsyncValue<SignUpPayload> signUpPayload;
  final AsyncValue<String> emailVerification;
  final AsyncValue<String> emailConfirmation;

  const AuthenticationState({
    required this.login,
    required this.signUp,
    required this.status,
    required this.signUpPayload,
    required this.emailVerification,
    required this.emailConfirmation,
  });

  factory AuthenticationState.initial() {
    return AuthenticationState(
      login: AsyncValue.data(UserModel()),
      status: AuthenticationStatus.idle,
      signUp: AsyncValue.data(UserModel()),
      signUpPayload: AsyncValue.data(SignUpPayload()),
      emailVerification: const AsyncValue.data(''),
      emailConfirmation: const AsyncValue.data(''),
    );
  }

  AuthenticationState copyWith({
    AsyncValue<UserModel>? login,
    AsyncValue<UserModel>? signUp,
    AsyncValue<SignUpPayload>? signUpPayload,
    AuthenticationStatus? status,
    AsyncValue<String>? emailVerification,
    AsyncValue<String>? emailConfirmation,
  }) {
    return AuthenticationState(
      login: login ?? this.login,
      status: status ?? this.status,
      signUp: signUp ?? this.signUp,
      signUpPayload: signUpPayload ?? this.signUpPayload,
      emailVerification: emailVerification ?? this.emailVerification,
      emailConfirmation: emailConfirmation ?? this.emailConfirmation,
    );
  }

  @override
  String toString() {
    return 'AuthenticationState(login: $login, )';
  }

  @override
  bool operator ==(covariant AuthenticationState other) {
    if (identical(this, other)) return true;

    return other.login == login &&
        other.signUp == signUp &&
        other.status == status;
  }

  @override
  int get hashCode {
    return login.hashCode ^ signUp.hashCode ^ status.hashCode;
  }
}
