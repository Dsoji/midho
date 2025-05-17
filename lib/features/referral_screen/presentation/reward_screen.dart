import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/common/utils/date_utils.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../crypto/presentation/crypto_screen.dart';
import '../../transaction/data/controller/transaction_controller.dart';

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
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await ref.read(transactionControllerProvider.notifier).getReferrals();
          await ref.read(transactionControllerProvider.notifier).getRewards();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics:
              const AlwaysScrollableScrollPhysics(), // ensures pull-to-refresh even if content is short
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "View your referral rewards history.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : AppColors.whiteColor.shade100,
                shape: const RoundedRectangleBorder(),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(12),
                  RewardsList(),
                ],
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

class RewardsList extends HookConsumerWidget {
  const RewardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(transactionControllerProvider).rewards;

    return state.when(
      loading: () => state.maybeWhen(
        data: (data) {
          final rewards = data.data;
          return ListView.separated(
            itemCount: rewards!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
                height: 1,
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : Colors.grey.shade300),
            itemBuilder: (context, index) {
              final reward = rewards[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
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
                              const TextSpan(text: "Reward of "),
                              TextSpan(
                                text: '${reward.amount}'.formatAsNaira(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${reward.createdAt?.getFormattedDate()}',
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
        },
        orElse: () {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, __) => const CryptoCardShimmer(),
          );
        },
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_outlined,
                size: 48, color: Colors.red),
            const Gap(12),
            Text('Failed to load crypto rates.',
                style: TextStyle(color: Colors.red[600], fontSize: 16)),
            const Gap(6),
            Text(error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      data: (data) {
        final rewards = data.data;
        if (rewards == null || rewards.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(52),
                const Icon(Icons.info_outline, color: Colors.grey, size: 48),
                const SizedBox(height: 8),
                Text(
                  "No rewards available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: rewards.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
              height: 1,
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade500
                  : Colors.grey.shade300),
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
                            const TextSpan(text: "Reward of "),
                            TextSpan(
                              text: '${reward.amount}'.formatAsNaira(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontFamily: ''),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${reward.createdAt?.getFormattedDate()}',
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
      },
    );
  }
}
