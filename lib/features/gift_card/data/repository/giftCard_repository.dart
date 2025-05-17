import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/utils/multiple_results.dart';
import '../../../../common/utils/utils.dart';
import '../model/response/gift_card_model/gift_card_model.dart';
import '../service/gift_card_service.dart';

final giftCardRepositoryProvider = Provider((ref) {
  final authenticationService = ref.watch(giftCardServiceProvider);
  return GiftCardRepository(
    authenticationService,
  );
});

class GiftCardRepository {
  GiftCardRepository(
    this.giftService,
  );

  final GiftCardService giftService;

  Future<Result<FailureHandler, GiftCardModel>> getGiftCardCategories() async {
    try {
      final data = await giftService.getCategories();

      if (data.isSuccess && data.value != null) {
        final giftCard = data.value!;
        // Save profile to Hive as a Map
        var box = Hive.box('data');
        await box.put('giftCard', giftCard.toMap());
        return Success(giftCard);
      } else {
        var box = Hive.box('data');
        final cachedGiftCard = box.get('giftCard');
        if (cachedGiftCard != null && cachedGiftCard is Map<String, dynamic>) {
          final giftCard = GiftCardModel.fromMap(cachedGiftCard);
          return Success(giftCard);
        }
        return Error(
          data.error ??
              FailureHandler(
                message: 'Failed to fetch categories',
                stackTrace: StackTrace.current,
                exception: Exception('Failed to fetch categories'),
              ),
        );
      }
    } on FailureHandler catch (failure) {
      var box = Hive.box('data');
      final cachedGiftCard = box.get('giftCard');
      if (cachedGiftCard != null && cachedGiftCard is Map<String, dynamic>) {
        final giftCard = GiftCardModel.fromMap(cachedGiftCard);
        return Success(giftCard);
      }
      return Error(failure);
    }
  }
}
