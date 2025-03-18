import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/features/referral_screen/presentation/reward_screen.dart';
import 'package:mdiho/features/referral_screen/presentation/withdrawal/withdraw_balance_screen.dart';
import 'package:mdiho/features/referral_screen/presentation/your_referalls.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../home/presentation/widget/wallet_balance_card.dart';

@RoutePage()
class ReferallScreen extends HookConsumerWidget {
  const ReferallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isBalanceVisible = true;
    final theme = Theme.of(context);
    return const Scaffold(
      appBar: CustomAppBar(
        title: "Invite & Earn",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Earn rewards by inviting friends to M-Diho!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Gap(16),
            ReferralBalanceCard(
              balance: 50000,
            ),
            Gap(16),
            ReferralCodeCard(referralCode: "DESIGNFATHER"),
            Gap(16),
            RewardEmptyStateCard(referralCode: "DESIGNFATHER"),
            Gap(150),
          ],
        ),
      ),
    );
  }
}

class RewardEmptyStateCard extends StatelessWidget {
  final String referralCode;

  const RewardEmptyStateCard({super.key, required this.referralCode});

  void _shareReferralCode() {
    Share.share(
        "Use my referral code: $referralCode to sign up and earn rewards!");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade500
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Rewards",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF565B8A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  print("More options clicked");
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Empty State Icon & Message
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor.shade400
                          : const Color(0xFFF9F9FB),
                    ),
                    child: Icon(Icons.arrow_downward,
                        size: 12,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF2B2B2B)),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 16),
                      children: [
                        TextSpan(
                          text: '1,000'.formatAsNaira(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                'Jan 15, 2025',
                style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RewardScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade400
                      : AppColors.greyColor.shade500,
                  width: theme.brightness == Brightness.dark ? 0.5 : 0.07,
                ),
              ),
              child: Center(
                child: Text(
                  'View All Rewards',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}

class ReferralCodeCard extends StatelessWidget {
  final String referralCode;

  const ReferralCodeCard({super.key, required this.referralCode});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Referral code copied!")),
    );
  }

  void _shareReferralCode() {
    Share.share(
        "Use my referral code: $referralCode to sign up and earn rewards!");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade500
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Your Referral Code",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey),
          ),
          const SizedBox(height: 4),

          // Referral Code & Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                referralCode,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  GradientIconButton(
                    onTap: () => _copyToClipboard(context),
                    icon: IconsaxPlusLinear.copy,
                  ),
                  const Gap(12),
                  GradientIconButton(
                    onTap: _shareReferralCode,
                    icon: IconsaxPlusLinear.share,
                  ),
                ],
              ),
            ],
          ),
          const Gap(24),
          InfoWidget(
              theme: theme,
              text: 'Share your code with friends to earn rewards.'),
          const Gap(12),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyReferallScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade400
                      : AppColors.greyColor.shade500,
                  width: theme.brightness == Brightness.dark ? 0.5 : 0.07,
                ),
              ),
              child: Center(
                child: Text(
                  'View Your Referrals',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReferralBalanceCard extends HookConsumerWidget {
  const ReferralBalanceCard({
    super.key,
    required this.balance,
  });
  final double balance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade500
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "Referrals Rewards Balance",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 4),

          // Balance with Visibility Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                isBalanceVisible
                    ? balance.toStringAsFixed(2).formatAsNaira()
                    : "••••••••",
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 29,
                  fontWeight: FontWeight.w600,
                  fontFamily: '',
                ),
              ),
              const Gap(8),
              Container(
                width: 21,
                height: 21,
                decoration: ShapeDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade400
                      : AppColors.greyColor.shade50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: GestureDetector(
                  onTap: () => ref
                      .read(balanceVisibilityProvider.notifier)
                      .toggleVisibility(),
                  child: Icon(
                    isBalanceVisible
                        ? IconsaxPlusLinear.eye
                        : IconsaxPlusLinear.eye_slash,
                    size: 12,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Lifetime Earnings & Total Referrals
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lifetime Earnings",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "₦120,000.00",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Referrals",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "40",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),

          // Withdraw Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WithdrawReferallScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor.shade500,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(IconsaxPlusLinear.send_square,
                  color: Colors.white),
              label: const Text(
                "Withdraw",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          const Gap(24),
          InfoWidget(
              theme: theme,
              text: 'Withdraw your referral earnings directly to your wallet.')
        ],
      ),
    );
  }
}
