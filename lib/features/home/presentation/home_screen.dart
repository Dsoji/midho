import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/home/presentation/widget/transaction_tile.dart';
import 'package:mdiho/features/notification/notification_screen.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../../bottomNav/app_router.gr.dart';
import 'widget/quick_action_grid.dart';
import 'widget/wallet_balance_card.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    int backPressCounter = 0;
    DateTime? lastBackPressTime;
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) async {
        DateTime now = DateTime.now();

        // Reset counter if last press was more than 2 seconds ago
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          backPressCounter = 0;
        }

        lastBackPressTime = now;
        backPressCounter++;

        if (backPressCounter < 2) {
          Fluttertoast.showToast(
            msg: "Swipe back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        } else {
          Navigator.of(context).pop(); // Allow exit on second back swipe
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: InkWell(
              onTap: () {
                final tabsRouter = AutoTabsRouter.of(
                  context,
                );

                tabsRouter.setActiveIndex(4);
              },
              child: const CircleAvatar(
                radius: 19,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(
                  PlaceholderAssets.pfp,
                ),
              ),
            ),
          ),
          centerTitle: false,
          title: const SizedBox(
            width: 141,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome John 👋',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'What are we doing today?',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          actions: [
            const ReferralButton(),
            const Gap(8),
            CustomIconContainer(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
            ),
            const Gap(24),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Gap(16),
              WalletBalanceCard(
                balance: 9500000,
              ),
              Gap(16),
              QuickActionsGrid(),
              Gap(16),
              TransactionCard(),
              Gap(
                100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReferralButton extends StatelessWidget {
  const ReferralButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.router.push(const ReferallRoute());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ReferallScreen(),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? Colors.transparent
              : const Color(0xFFF5FDFE), // Light background color
          borderRadius: BorderRadius.circular(30), // Rounded corners
          border: Border.all(
            color: AppColors.tertiaryColor.shade500,
            width: 0.5,
          ), // Light blue border
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconsaxPlusLinear.award, // Placeholder icon
              color: AppColors.tertiaryColor.shade700,
              size: 17,
            ),
            const SizedBox(width: 6),
            Text(
              "referrals",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.tertiaryColor.shade700,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIconContainer extends StatelessWidget {
  const CustomIconContainer({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32, // Diameter = 2 * radius
        height: 32,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.brightness == Brightness.dark
                ? Colors.transparent
                : AppColors.whiteColor.shade50,
            border: Border.all(
              color: AppColors.whiteColor.shade600,
            )),
        child: const Center(
          child: Icon(
            IconsaxPlusLinear.notification,
            size: 20,
          ),
        ),
      ),
    );
  }
}
