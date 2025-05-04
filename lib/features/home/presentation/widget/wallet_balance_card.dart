import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

import '../../../authentication/data/controller/authentication_controller.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade600
            : const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade400
              : Colors.white,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Label
          const Text(
            "Wallet Balance",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // Balance and Eye Icon Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: isBalanceVisible
                    ? TextSpan(
                        children: [
                          TextSpan(
                            text: '${userInfo?.wallet?.currency ?? ''} ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: '',
                            ),
                          ),
                          TextSpan(
                            text: '${userInfo?.wallet?.mainBalance ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              fontWeight: FontWeight.w600,
                              fontFamily: '',
                            ),
                          ),
                        ],
                      )
                    : const TextSpan(
                        text: "••••••••",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                          fontFamily: '',
                        ),
                      ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: () => ref
                    .read(balanceVisibilityProvider.notifier)
                    .toggleVisibility(),
                child: Container(
                  width: 21,
                  height: 21,
                  decoration: ShapeDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade400
                        : AppColors.greyColor.shade500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Icon(
                    isBalanceVisible
                        ? IconsaxPlusLinear.eye
                        : IconsaxPlusLinear.eye_slash,
                    size: 12,
                    color: Colors.white54,
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
              icon: const Icon(IconsaxPlusLinear.send_square,
                  color: Colors.white),
              label: const Text(
                "Withdraw",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
