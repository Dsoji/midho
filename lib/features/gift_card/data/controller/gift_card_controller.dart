import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repository/authentication_repository.dart';
import '../state/gift_card_state.dart';

final giftCardControllerProvider =
    StateNotifierProvider<GiftCardController, GiftCardState>((ref) {
  final authenticationRepository = ref.watch(giftCardRepositoryProvider);
  return GiftCardController(
    authenticationRepository: authenticationRepository,
    ref: ref,
  );
});

class GiftCardController extends StateNotifier<GiftCardState> {
  GiftCardController({
    required GiftCardRepository authenticationRepository,
    required this.ref,
  })  : _authenticationRepository = authenticationRepository,
        super(
          GiftCardState.initial(),
        ) {
    // geAuthCredential();
  }

  final GiftCardRepository _authenticationRepository;
  final Ref ref;

  Future<bool> getGiftCards() async {
    state = state.copyWith(giftCards: const AsyncValue.loading());

    final result = await _authenticationRepository.getGiftCardCategories();
    return result.when(
      (error) {
        state = state.copyWith(
          giftCards:
              AsyncValue.error(result.getError() ?? '', StackTrace.current),
        );
        return false;
      },
      (success) {
        // state = state.copyWith(
        //   login: AsyncValue.data(result.getSuccess() ?? UserModel()),
        //   status: AuthenticationStatus.loginSuccessful,
        // );
        return true;
      },
    );
  }
}
