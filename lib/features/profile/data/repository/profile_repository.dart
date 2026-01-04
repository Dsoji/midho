import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/utils/multiple_results.dart';
import 'package:mdiho/common/utils/utils.dart';
import 'package:mdiho/features/kyc/data/model/kyc_payload.dart';
import 'package:mdiho/features/leaderboard/model/leader_board_list/leader_board_list.dart';
import 'package:mdiho/features/profile/data/Model/response/platform_details/data.dart';
import 'package:mdiho/features/suggestion_box/data/payload/suggestion_payload.dart';
import 'package:mdiho/features/support_faq/data/model/response/faq_response/faq_response.dart';

import '../../../authentication/data/model/payload/profile_payload.dart';
import '../../../bank_network/data/model/response/bank_list/bank_list.dart';
import '../Model/response/user_profile_model/user_profile_model.dart';
import '../service/profile_service.dart';

final profileRepositoryProvider = Provider((ref) {
  final authenticationService = ref.watch(profileServiceProvider);
  return ProfileRepository(
    authenticationService,
  );
});

class ProfileRepository {
  ProfileRepository(
    this.authService,
  );

  final ProfileeService authService;

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

  Future<Result<FailureHandler, String>> createPin({
    required String pin,
  }) async {
    logger.d("here is pin in repository: $pin");
    try {
      final data = await authService.updatePin(
        pin: pin,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to create PIN',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to create PIN'),
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

      if (data.isSuccess) {
        return Success(data.value ?? UserProfileModel());
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

  Future<Result<FailureHandler, FaqResponse>> fetchFaq() async {
    try {
      final data = await authService.fetchFaq();

      if (data.isSuccess) {
        return Success(data.value ?? FaqResponse());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch your faq ',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch your faq '),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> postFeedBack(
      {required SuggestionPayload payload}) async {
    try {
      final data = await authService.postFeedBack(
        payload: payload,
      );

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to post feedback',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to post feedback'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, List<BanlList>>> fetchBanks() async {
    try {
      final data = await authService.getBankList();

      if (data.isSuccess) {
        return Success(data.value ?? []);
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch banks',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch banks'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, String>> kycVerification({
    required KycPayload payload,
  }) async {
    try {
      final data = await authService.kycVerification(payload: payload);

      if (data.isSuccess) {
        return Success(data.value ?? '');
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to verify KYC',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to verify KYC'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, PlatformDetails>> getPlatform() async {
    try {
      final data = await authService.getPlatform();

      if (data.isSuccess) {
        return Success(data.value ?? PlatformDetails());
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to get platform',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to get platform'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }

  Future<Result<FailureHandler, List<LeaderBoardList>>> getLeaderboard() async {
    try {
      final data = await authService.getLeaderboard();

      if (data.isSuccess) {
        return Success(data.value ?? <LeaderBoardList>[]);
      } else {
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to get leaderboard',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to get leaderboard'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      return Error(failure);
    }
  }
}
