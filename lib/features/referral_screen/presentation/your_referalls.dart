import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

class MyReferallScreen extends HookConsumerWidget {
  const MyReferallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Your Referalls",
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
                "Track all the friends you've referred.",
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
              padding: const EdgeInsets.all(24),
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoWidget(
                      theme: theme,
                      text:
                          'Only users who sign up using your code will appear here.',
                    ),
                    const Gap(24),
                    ReferallList(),
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

class ReferallList extends StatelessWidget {
  final List<RewardItem> rewards = [
    RewardItem(amount: "JohnD****", date: "Jan 15, 2025"),
    RewardItem(amount: "JohnD****", date: "Feb 10, 2025"),
    RewardItem(amount: "JohnD****", date: "Mar 5, 2025"),
  ];

  ReferallList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      itemCount: rewards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
        color: Colors.grey.shade300,
        thickness: 0.3,
      ),
      itemBuilder: (context, index) {
        final reward = rewards[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 16),
                      children: [
                        TextSpan(
                          text: reward.amount,
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
                reward.date,
                style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
