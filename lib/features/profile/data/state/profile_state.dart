import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/data/model/payload/profile_payload.dart';
import 'package:mdiho/features/profile/data/Model/response/platform_details/data.dart';
import 'package:mdiho/features/suggestion_box/data/payload/suggestion_payload.dart';
import 'package:mdiho/features/support_faq/data/model/response/faq_response/faq_response.dart';

import '../../../bank_network/data/model/response/bank_list/bank_list.dart';
import '../Model/response/user_profile_model/user_profile_model.dart';

class ProfileState {
  final AsyncValue<ProfilePayload> profilePayload;
  final AsyncValue<UserProfileModel> userDetails;
  final AsyncValue<String> userName;
  final AsyncValue<String> emailChange;
  final AsyncValue<String> resetPin;
  final AsyncValue<String> forgotPassword;
  final AsyncValue<FaqResponse> faq;
  final AsyncValue<SuggestionPayload> suggestion;
  final AsyncValue<String> feedBack;
  final AsyncValue<List<BanlList>> banks;
  final AsyncValue<String> kycVerification;
  final AsyncValue<PlatformDetails> platform;

  const ProfileState({
    required this.profilePayload,
    required this.userDetails,
    required this.userName,
    required this.emailChange,
    required this.resetPin,
    required this.forgotPassword,
    required this.faq,
    required this.suggestion,
    required this.feedBack,
    required this.banks,
    required this.kycVerification,
    required this.platform,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profilePayload: AsyncValue.data(ProfilePayload()),
      userDetails: AsyncValue.data(UserProfileModel()),
      userName: const AsyncValue.data(''),
      emailChange: const AsyncValue.data(''),
      resetPin: const AsyncValue.data(''),
      forgotPassword: const AsyncValue.data(''),
      faq: AsyncValue.data(FaqResponse()),
      suggestion: AsyncValue.data(SuggestionPayload()),
      feedBack: const AsyncValue.data(''),
      banks: const AsyncValue.data([]),
      kycVerification: const AsyncValue.data(''),
      platform: AsyncValue.data(PlatformDetails()),
    );
  }

  ProfileState copyWith({
    AsyncValue<ProfilePayload>? profilePayload,
    AsyncValue<String>? emailVerification,
    AsyncValue<String>? emailConfirmation,
    AsyncValue<String>? forgotPassword,
    AsyncValue<UserProfileModel>? userDetails,
    AsyncValue<String>? userName,
    AsyncValue<String>? emailChange,
    AsyncValue<String>? resetPin,
    AsyncValue<FaqResponse>? faq,
    AsyncValue<SuggestionPayload>? suggestion,
    AsyncValue<String>? feedBack,
    AsyncValue<List<BanlList>>? banks,
    AsyncValue<String>? kycVerification,
    AsyncValue<PlatformDetails>? platform,
  }) {
    return ProfileState(
      profilePayload: profilePayload ?? this.profilePayload,
      userDetails: userDetails ?? this.userDetails,
      userName: userName ?? this.userName,
      emailChange: emailChange ?? this.emailChange,
      resetPin: resetPin ?? this.resetPin,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      faq: faq ?? this.faq,
      suggestion: suggestion ?? this.suggestion,
      feedBack: feedBack ?? this.feedBack,
      banks: banks ?? this.banks,
      kycVerification: kycVerification ?? this.kycVerification,
      platform: platform ?? this.platform,
    );
  }
}
