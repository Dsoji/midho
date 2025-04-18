import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/widgets/custom_textfield.dart';
import 'package:mdiho/features/gift_card/data/controller/gift_card_controller.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../data/model/response/gift_card_model/datum.dart';

@RoutePage()
class GiftCardScreen extends HookConsumerWidget {
  const GiftCardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final theme = Theme.of(context);
    final giftCards =
        ref.watch(giftCardControllerProvider).giftCards.valueOrNull?.data;
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(0);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Sell Gift Card",
          showBackButton: false,
          showTitle: true,
          showAction: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose the type of gift card you'd like to sell from our supported list",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(16),
              CustomTextField(
                controller: searchController,
                hintText: "Search Gift Card",
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.white,
                suffixIcon: const Icon(Icons.search),
              ),
              const Gap(16),
              const GiftCardGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class GiftCard {
  final String image;
  final String name;
  final String desc;

  GiftCard({required this.image, required this.name, required this.desc});
}

class GiftCardGrid extends HookConsumerWidget {
  const GiftCardGrid({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final giftCards =
        ref.watch(giftCardControllerProvider).giftCards.valueOrNull?.data;
    print(giftCards);

    return giftCards != null && giftCards.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: giftCards.length,
            itemBuilder: (context, index) {
              final card = giftCards[index];
              return GestureDetector(
                onTap: () {
                  // context.router.push(
                  //   EnterCardDetailsRoute(giftCard: card),
                  // );
                },
                child: GiftCardItem(giftCard: card),
              );
            },
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(52),
                const Icon(Icons.info_outline, color: Colors.grey, size: 48),
                const SizedBox(height: 8),
                Text(
                  "No gift cards available at the moment.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
  }
}

class GiftCardItem extends StatelessWidget {
  final Datum giftCard;

  const GiftCardItem({super.key, required this.giftCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 116, // Fixed width
      height: 112, // Fixed height
      child: Container(
        decoration: ShapeDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade500
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                giftCard.icon ?? 'assets/default_icon.png',
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                giftCard.name ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'Gift Card',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
