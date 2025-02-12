import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';

import '../../../../common/res/app_colors.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions",
            style: TextStyle(
              color: AppColors.secondaryColor.shade200,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFF9F9FB),
                radius: 20,
                child: Icon(Icons.arrow_downward, color: Colors.black54),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sold 0.02 BTC for ",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: "₦500,000",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Jan 15, 2025.",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
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
            onPressed: () {},
            textColor: AppColors.secondaryColor.shade300,
            color: const Color(0xFFF9F9FB),
            fontSize: 13,
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
