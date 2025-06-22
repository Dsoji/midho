import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/authentication/data/model/payload/profile_payload.dart';
import 'package:mdiho/features/suggestion_box/data/payload/suggestion_payload.dart';

import '../repository/profile_repository.dart';
import '../state/profile_state.dart';

final logger = Logger();
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileController(
    profileRepository: profileRepository,
    ref: ref,
  );
});

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController({
    required ProfileRepository profileRepository,
    required this.ref,
  })  : _authenticationRepository = profileRepository,
        super(
          ProfileState.initial(),
        ) {
    // geAuthCredential();
  }

  final ProfileRepository _authenticationRepository;
  final Ref ref;

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

  Future<bool> createPin({
    required String pin,
  }) async {
    state = state.copyWith(forgotPassword: const AsyncValue.loading());
    logger.d("here is pin in controller: $pin");
    final result = await _authenticationRepository.createPin(
      pin: pin,
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
    state = state.copyWith(userDetails: const AsyncValue.loading());

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

  Future<bool> getFaq() async {
    state = state.copyWith(faq: const AsyncValue.loading());

    final result = await _authenticationRepository.fetchFaq();

    return result.when(
      (error) {
        state = state.copyWith(
          faq: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          faq: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  void updateSuggestedFeedBack(SuggestionPayload newDetails) {
    state = state.copyWith(suggestion: AsyncValue.data(newDetails));
  }

  Future<bool> postFeedBack(
    SuggestionPayload payload,
  ) async {
    state = state.copyWith(feedBack: const AsyncValue.loading());

    final result = await _authenticationRepository.postFeedBack(
      payload: payload,
    );

    return result.when(
      (error) {
        state = state.copyWith(
          feedBack: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          feedBack: AsyncValue.data(success),
        );
        return true;
      },
    );
  }

  Future<bool> getBanks() async {
    state = state.copyWith(banks: const AsyncValue.loading());

    final result = await _authenticationRepository.fetchBanks();

    return result.when(
      (error) {
        state = state.copyWith(
          banks: AsyncValue.error(error, StackTrace.current),
        );
        return false;
      },
      (success) {
        state = state.copyWith(
          banks: AsyncValue.data(success),
        );
        return true;
      },
    );
  }
}
