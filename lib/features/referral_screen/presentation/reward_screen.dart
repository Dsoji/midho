import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

class RewardScreen extends HookConsumerWidget {
  const RewardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Your Rewards",
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
                "View your referral rewards history.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(16),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(12),
                    RewardsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardItem {
  final String amount;
  final String date;

  RewardItem({required this.amount, required this.date});
}

class RewardsList extends StatelessWidget {
  final List<RewardItem> rewards = [
    RewardItem(amount: "1,000", date: "Jan 15, 2025"),
    RewardItem(amount: "2,500", date: "Feb 10, 2025"),
    RewardItem(amount: "5,000", date: "Mar 5, 2025"),
  ];

  RewardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: rewards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final reward = rewards[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF9F9FB),
                    ),
                    child: const Icon(Icons.arrow_downward,
                        size: 12, color: Color(0xFF2B2B2B)),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 16),
                      children: [
                        const TextSpan(text: "Reward of "),
                        TextSpan(
                          text: reward.amount.formatAsNaira(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                reward.date,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
