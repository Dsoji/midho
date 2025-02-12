import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/home/presentation/widget/transaction_tile.dart';

import '../../../common/res/app_colors.dart';
import 'widget/quick_action_grid.dart';
import 'widget/wallet_balance_card.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = false; // Get this from ThemeMode in a real app
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: CircleAvatar(
            radius: 19,
            backgroundColor: Colors.grey,
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
        actions: const [
          ReferralButton(),
          Gap(8),
          CustomIconContainer(),
          Gap(24),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const Gap(16),
            WalletBalanceCard(
              isDarkMode: isDarkMode,
              balance: 950000.00,
            ),
            const Gap(16),
            const QuickActionsGrid(),
            const Gap(16),
            const TransactionCard(),
            const Gap(
              100,
            )
          ],
        ),
      ),
    );
  }
}

class ReferralButton extends StatelessWidget {
  const ReferralButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FDFE), // Light background color
        borderRadius: BorderRadius.circular(30), // Rounded corners
        border: Border.all(
          color: AppColors.tertiaryColor.shade500,
          width: 1.5,
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIconContainer extends StatelessWidget {
  const CustomIconContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, // Diameter = 2 * radius
      height: 32,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteColor.shade50,
          border: Border.all(
            color: AppColors.whiteColor.shade600,
          )),
      child: const Center(
        child: Icon(
          IconsaxPlusLinear.notification,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
