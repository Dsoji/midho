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
import '../../authentication/data/controller/authentication_controller.dart';
import '../../home/presentation/widget/wallet_balance_card.dart';
import '../../transaction/data/controller/transaction_controller.dart';

@RoutePage()
class ReferallScreen extends HookConsumerWidget {
  const ReferallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Invite & Earn",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Earn rewards by inviting friends to M-Diho!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(16),
            const ReferralBalanceCard(),
            const Gap(16),
            ReferralCodeCard(
                referralCode: userInfo?.username ?? "DESIGNFATHER"),
            const Gap(16),
            RewardEmptyStateCard(
                referralCode: userInfo?.username ?? "DESIGNFATHER"),
            const Gap(150),
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
                            fontFamily: '',
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
  const ReferralBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceState =
        ref.watch(authenticationControllerProvider).userDetails;
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);
    final theme = Theme.of(context);
    final refCount =
        ref.watch(transactionControllerProvider).referals.valueOrNull?.data;

    final color =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;

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
      child: balanceState.when(
        loading: () => _ReferralLoadingContent(
            theme: theme, isBalanceVisible: isBalanceVisible),
        error: (error, stackTrace) => _ReferralErrorContent(theme: theme),
        data: (userDetails) {
          final balance = userDetails.wallet?.referralBalance ?? 0.0;
          final lifetimeEarnings =
              userDetails.wallet?.lifetimeReferralBalance ?? 0.0;
          final totalReferrals = refCount?.length ?? 0;

          return _ReferralDataContent(
            ref: ref,
            theme: theme,
            balance: balance,
            lifetimeEarnings: lifetimeEarnings,
            totalReferrals: totalReferrals,
            isBalanceVisible: isBalanceVisible,
          );
        },
      ),
    );
  }
}

class _ReferralDataContent extends StatelessWidget {
  final ThemeData theme;
  final num balance;
  final num lifetimeEarnings;
  final int totalReferrals;
  final bool isBalanceVisible;
  final WidgetRef ref;

  const _ReferralDataContent({
    required this.theme,
    required this.balance,
    required this.lifetimeEarnings,
    required this.totalReferrals,
    required this.isBalanceVisible,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Referrals Rewards Balance",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              isBalanceVisible
                  ? balance.toStringAsFixed(2).formatAsNaira()
                  : "••••••••",
              style: TextStyle(
                color: color,
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
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Lifetime Earnings",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    lifetimeEarnings.toStringAsFixed(2).formatAsNaira(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: ''),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Referrals",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: '',
                      )),
                  const SizedBox(height: 4),
                  Text(
                    totalReferrals.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WithdrawReferallScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor.shade500,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon:
                const Icon(IconsaxPlusLinear.send_square, color: Colors.white),
            label: const Text("Withdraw",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
        const Gap(24),
        InfoWidget(
            theme: theme,
            text: 'Withdraw your referral earnings directly to your wallet.'),
      ],
    );
  }
}

class _ReferralLoadingContent extends StatelessWidget {
  final ThemeData theme;
  final bool isBalanceVisible;

  const _ReferralLoadingContent({
    required this.theme,
    required this.isBalanceVisible,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Referrals Rewards Balance",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        const Row(
          children: [
            ShimmerWidget(width: 100, height: 30),
            Gap(8),
            // _VisibilityToggleButton(theme: theme),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lifetime Earnings",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 4),
                  ShimmerWidget(width: 80, height: 20),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Referrals",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 4),
                  ShimmerWidget(width: 40, height: 20),
                ],
              ),
            ),
          ],
        ),
        const Gap(24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor.shade200,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon:
                const Icon(IconsaxPlusLinear.send_square, color: Colors.white),
            label: const Text("Withdraw",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
        const Gap(24),
        InfoWidget(
            theme: theme,
            text: 'Withdraw your referral earnings directly to your wallet.'),
      ],
    );
  }
}

class _ReferralErrorContent extends StatelessWidget {
  final ThemeData theme;

  const _ReferralErrorContent({required this.theme});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Failed to load referral balance',
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
