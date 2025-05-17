import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/gift_card/data/model/response/gift_card_model/gift_card_model.dart';

import '../repository/giftCard_repository.dart';
import '../state/gift_card_state.dart';

final logger = Logger();
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
    // Check if the data is already cached
    final giftCard = Hive.box('data').get('giftCard');
    if (giftCard != null && giftCard is Map) {
      try {
        // Manually build a properly typed Map<String, dynamic>
        final Map<String, dynamic> fixedMap = {};
        for (var entry in giftCard.entries) {
          if (entry.key is String) {
            fixedMap[entry.key] = entry.value;
          } else {
            fixedMap[entry.key.toString()] = entry.value;
          }
        }

        final cachedRates = GiftCardModel.fromMap(fixedMap);
        state = state.copyWith(giftCards: AsyncValue.data(cachedRates));
        logger.d('✅ Loaded cached giftcards from normalized map.');
      } catch (e, stack) {
        logger.e('⛔ Failed to parse normalized rate: $e', stackTrace: stack);
        state = state.copyWith(giftCards: const AsyncValue.loading());
      }
    } else {
      logger.w('No cached giftcard found.');
      state = state.copyWith(giftCards: const AsyncValue.loading());
    }

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
        state = state.copyWith(
          giftCards: AsyncValue.data(result.getSuccess() ?? GiftCardModel()),
        );
        return true;
      },
    );
  }
}
