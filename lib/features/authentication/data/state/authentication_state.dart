import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/data/model/payload/profile_payload.dart';
import 'package:mdiho/features/notification/data/model/response/notifcation_list/notifcation_list.dart';

import '../../../profile/data/Model/response/user_profile_model/user_profile_model.dart';
import '../../../suggestion_box/data/response/upload_response/upload_response.dart';
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
  final AsyncValue<String> forgotPassword;
  final AsyncValue<ProfilePayload> profilePayload;
  final AsyncValue<UserProfileModel> userDetails;
  final AsyncValue<String> userName;
  final AsyncValue<String> emailChange;
  final AsyncValue<String> resetPin;
  final AsyncValue<UploadResponse> imageUpload;
  final AsyncValue<NotifcationList> notification;

  const AuthenticationState({
    required this.login,
    required this.signUp,
    required this.status,
    required this.signUpPayload,
    required this.emailVerification,
    required this.emailConfirmation,
    required this.forgotPassword,
    required this.profilePayload,
    required this.userDetails,
    required this.userName,
    required this.emailChange,
    required this.resetPin,
    required this.imageUpload,
    required this.notification,
  });

  factory AuthenticationState.initial() {
    return AuthenticationState(
      login: AsyncValue.data(UserModel()),
      status: AuthenticationStatus.idle,
      signUp: AsyncValue.data(UserModel()),
      signUpPayload: AsyncValue.data(SignUpPayload()),
      emailVerification: const AsyncValue.data(''),
      emailConfirmation: const AsyncValue.data(''),
      forgotPassword: const AsyncValue.data(''),
      profilePayload: AsyncValue.data(ProfilePayload()),
      userDetails: AsyncValue.data(UserProfileModel()),
      userName: const AsyncValue.data(''),
      emailChange: const AsyncValue.data(''),
      resetPin: const AsyncValue.data(''),
      imageUpload: AsyncValue.data(UploadResponse()),
      notification: AsyncValue.data(NotifcationList()),
    );
  }

  AuthenticationState copyWith({
    AsyncValue<UserModel>? login,
    AsyncValue<UserModel>? signUp,
    AsyncValue<SignUpPayload>? signUpPayload,
    AsyncValue<ProfilePayload>? profilePayload,
    AuthenticationStatus? status,
    AsyncValue<String>? emailVerification,
    AsyncValue<String>? emailConfirmation,
    AsyncValue<String>? forgotPassword,
    AsyncValue<UserProfileModel>? userDetails,
    AsyncValue<String>? userName,
    AsyncValue<String>? emailChange,
    AsyncValue<String>? resetPin,
    AsyncValue<UploadResponse>? imageUpload,
    AsyncValue<NotifcationList>? notification,
  }) {
    return AuthenticationState(
      login: login ?? this.login,
      status: status ?? this.status,
      signUp: signUp ?? this.signUp,
      signUpPayload: signUpPayload ?? this.signUpPayload,
      emailVerification: emailVerification ?? this.emailVerification,
      emailConfirmation: emailConfirmation ?? this.emailConfirmation,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      profilePayload: profilePayload ?? this.profilePayload,
      userDetails: userDetails ?? this.userDetails,
      userName: userName ?? this.userName,
      emailChange: emailChange ?? this.emailChange,
      resetPin: resetPin ?? this.resetPin,
      imageUpload: imageUpload ?? this.imageUpload,
      notification: notification ?? this.notification,
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
        other.status == status &&
        other.notification == notification;
  }

  @override
  int get hashCode {
    return login.hashCode ^ signUp.hashCode ^ status.hashCode;
  }
}
