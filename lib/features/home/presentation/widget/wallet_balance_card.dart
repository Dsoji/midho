import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/res/app_colors.dart';

import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../bottomNav/app_router.gr.dart';

// StateNotifier for Balance Visibility
class BalanceVisibilityNotifier extends StateNotifier<bool> {
  BalanceVisibilityNotifier() : super(true);

  void toggleVisibility() {
    state = !state; // Toggle visibility
  }
}

// Riverpod Provider for Visibility
final balanceVisibilityProvider =
    StateNotifierProvider<BalanceVisibilityNotifier, bool>(
  (ref) => BalanceVisibilityNotifier(),
);

// Wallet Balance Card Widget
class WalletBalanceCard extends HookConsumerWidget {
  final double balance;

  const WalletBalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(balanceVisibilityProvider);
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.darkBorder
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade600
                  : const Color(0xFFF6F8FE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Wallet Label
                Text(
                  "Wallet Balance",
                  style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor.shade100
                          : AppColors.primaryColor,
                      fontSize: 14),
                ),
                const SizedBox(height: 8),

                // Balance and Eye Icon Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isBalanceVisible
                          ? '${userInfo?.wallet?.mainBalance ?? 0}'
                              .formatAsNaira()
                          : "••••••••",
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.primaryColor,
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
                            : AppColors.greyColor.shade300,
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

                // Withdraw Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.router.push(const WithdrawFundsRoute());
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const WithdrawFundsScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: const Text(
                      "Withdraw",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(6),
          const ReferralsCard(),
          const Gap(2),
        ],
      ),
    );
  }
}

class ReferralsCard extends StatelessWidget {
  const ReferralsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        context.router.push(const ReferallRoute());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade600
              : const Color(0xFFF6F8FE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Referrals',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.primaryColor.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF1B1B1B)
                        : AppColors.blueColor.shade50, // light icon background
                  ),
                  child: Icon(
                    Icons.north_east, // ↗️ arrow
                    size: 14,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.primaryColor.shade700,
                  ),
                ),
              ],
            ),
            Text(
              '₦50,000.00',
              style: TextStyle(
                fontSize: 16,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.primaryColor.shade700,
                fontWeight: FontWeight.bold,
                fontFamily: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
