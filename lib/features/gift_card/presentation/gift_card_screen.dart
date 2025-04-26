import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/widgets/custom_textfield.dart';
import 'package:mdiho/features/gift_card/data/controller/gift_card_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../bottomNav/app_router.gr.dart';
import '../data/model/response/gift_card_model/datum.dart';

@RoutePage()
class GiftCardScreen extends HookConsumerWidget {
  const GiftCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          final tabsRouter = AutoTabsRouter.of(context);
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
        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(giftCardControllerProvider.notifier).getGiftCards();
            return Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
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
                GiftCardGrid(searchController: searchController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GiftCardGrid extends HookConsumerWidget {
  final TextEditingController searchController;
  const GiftCardGrid({super.key, required this.searchController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(giftCardControllerProvider).giftCards;
    final query = useListenable(searchController).text.toLowerCase();

    return state.when(
      loading: () => state.maybeWhen(
        data: (giftCards) {
          final filteredCards = useMemoized(() {
            if (query.isEmpty) return giftCards.data ?? [];
            return (giftCards.data ?? [])
                .where(
                    (card) => card.name?.toLowerCase().contains(query) == true)
                .toList();
          }, [giftCards, query]);
          //
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: filteredCards.length,
            itemBuilder: (context, index) {
              final card = filteredCards[index];
              return GestureDetector(
                onTap: () {
                  context.router.push(EnterCardDetailsRoute(giftCard: card));
                },
                child: GiftCardItem(giftCard: card),
              );
            },
          );
        },
        orElse: () => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => const GiftCardShimmerItem(),
        ),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_outlined,
                size: 48, color: Colors.red),
            const Gap(12),
            Text(
              'Failed to load gift cards.',
              style: TextStyle(color: Colors.red[600], fontSize: 16),
            ),
            const Gap(6),
            Text(error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      data: (giftCards) {
        final filteredCards = useMemoized(() {
          if (query.isEmpty) return giftCards.data ?? [];
          return (giftCards.data ?? [])
              .where((card) => card.name?.toLowerCase().contains(query) == true)
              .toList();
        }, [giftCards, query]);

        if (filteredCards.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(52),
                const Icon(Icons.info_outline, color: Colors.grey, size: 48),
                const SizedBox(height: 8),
                Text(
                  "No gift cards available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: filteredCards.length,
          itemBuilder: (context, index) {
            final card = filteredCards[index];
            return GestureDetector(
              onTap: () {
                context.router.push(EnterCardDetailsRoute(giftCard: card));
              },
              child: GiftCardItem(giftCard: card),
            );
          },
        );
      },
    );
  }
}

class GiftCardItem extends StatelessWidget {
  final GiftCardData giftCard;

  const GiftCardItem({super.key, required this.giftCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 116,
      height: 112,
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
              CachedNetworkImage(
                imageUrl: giftCard.icon ?? '',
                height: 28,
                fit: BoxFit.contain,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/default_icon.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
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

class GiftCardShimmerItem extends StatelessWidget {
  const GiftCardShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryColor.shade50,
      highlightColor: AppColors.primaryColor.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
