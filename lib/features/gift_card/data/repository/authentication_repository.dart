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

      if (data.isSuccess) {
        return Success(data.value ?? GiftCardModel());
      } else {
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
      return Error(failure);
    }
  }
}
