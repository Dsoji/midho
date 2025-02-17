import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';

import '../../../../common/res/app_colors.dart';
import '../../../transaction/presentation/transaction_history.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40, // Equivalent to radius * 2
                height: 40,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade600
                      : const Color(0xFFF9F9FB),
                  shape: BoxShape.circle, // Ensures circular shape
                  border: Border.all(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor
                            .shade400 // Light border in dark mode
                        : Colors
                            .transparent, // Subtle grey border in light mode
                    width: 0.5, // Border thickness
                  ),
                ),
                child: const Center(
                  child: Icon(
                    IconsaxPlusLinear.arrow_down_1,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sold 0.02 BTC for ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "₦500,000",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: '',
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jan 15, 2025.",
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
              const Text(
                "Completed",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF34C759),
                ),
              ),
            ],
          ),
          const Gap(16),
          FullButton(
            text: "View All Activity",
            width: double.infinity,
            height: 48,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionHistory(),
                ),
              );
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
