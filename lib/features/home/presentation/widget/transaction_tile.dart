import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/utils/date_utils.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';

import '../../../../common/res/app_colors.dart';
import '../../../crypto/presentation/crypto_screen.dart';
import '../../../transaction/data/controller/transaction_controller.dart';

class TransactionCard extends HookConsumerWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider).transactions;
    final tabsRouter = AutoTabsRouter.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade600
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade400
              : Colors.white,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions",
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.secondaryColor.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(16),
          state.when(
            loading: () => ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              itemCount: 3,
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (_, __) => const CryptoCardShimmer(),
            ),
            error: (error, _) => const Center(
              child: Text(
                "Failed to load transactions",
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
            data: (data) {
              final transactions = data.data ?? [];
              if (transactions.isEmpty) {
                return Center(
                  child: Text(
                    "No transactions yet.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                );
              }

              final displayTransactions = transactions.length > 5
                  ? transactions.take(5).toList()
                  : transactions;

              return Column(
                children: List.generate(
                  displayTransactions.length * 2 - 1,
                  (index) {
                    if (index.isEven) {
                      final txn = displayTransactions[index ~/ 2];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.dark
                                  ? AppColors.secondaryColor.shade600
                                  : const Color(0xFFF9F9FB),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.brightness == Brightness.dark
                                    ? AppColors.secondaryColor.shade400
                                    : Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            child: const Center(
                              child: Icon(IconsaxPlusLinear.arrow_down_1,
                                  size: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "${txn.type}   ",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${txn.amount}".formatAsNaira(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          fontFamily: '',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  txn.createdAt?.getFormattedDate() ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.brightness == Brightness.dark
                                        ? AppColors.secondaryColor.shade100
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${txn.status}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: txn.status!.toLowerCase() == 'pending'
                                  ? Colors.orange
                                  : txn.status!.toLowerCase() == 'completed'
                                      ? Colors.green
                                      : txn.status!.toLowerCase() == 'failed'
                                          ? Colors.red
                                          : Colors.grey,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Gap(16);
                    }
                  },
                ),
              );
            },
          ),
          const Gap(16),
          FullButton(
            text: "View All Activity",
            width: double.infinity,
            height: 48,
            onPressed: () {
              tabsRouter.setActiveIndex(3);
            },
            textColor: theme.brightness == Brightness.dark
                ? Colors.white
                : AppColors.secondaryColor.shade300,
            color: theme.brightness == Brightness.dark
                ? AppColors.secondaryColor.shade700
                : const Color(0xFFF9F9FB),
            fontSize: 13,
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
