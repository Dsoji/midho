import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/common/widgets/custom_textfield.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

@RoutePage()
class GiftCardScreen extends HookConsumerWidget {
  const GiftCardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    return Scaffold(
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
            ),
            const Gap(16),
            const GiftCardGrid(),
          ],
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

class GiftCardGrid extends HookWidget {
  const GiftCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the list inside the widget using useState
    final giftCards = useState<List<GiftCard>>([
      GiftCard(
          image: PlaceholderAssets.steam, name: 'STEAM', desc: 'Gift Card'),
      GiftCard(
          image: PlaceholderAssets.amazon, name: 'Amazon', desc: 'Gift Card'),
      GiftCard(
          image: PlaceholderAssets.apple, name: 'iTunes', desc: 'Gift Card'),
      GiftCard(
          image: PlaceholderAssets.google,
          name: 'Google Play',
          desc: 'Gift Card'),
      GiftCard(
          image: PlaceholderAssets.walmart, name: 'Walmart', desc: 'Gift Card'),
      GiftCard(image: PlaceholderAssets.visa, name: 'Visa', desc: 'Gift Card'),
    ]);

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 2 columns
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: giftCards.value.length,
      itemBuilder: (context, index) {
        final card = giftCards.value[index];
        return GiftCardItem(giftCard: card);
      },
    );
  }
}

class GiftCardItem extends StatelessWidget {
  final GiftCard giftCard;

  const GiftCardItem({super.key, required this.giftCard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 116, // Fixed width
      height: 112, // Fixed height
      child: Card(
        elevation: 3,
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade500
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                giftCard.image,
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                giftCard.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                giftCard.desc,
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
