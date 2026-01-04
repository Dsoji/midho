import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/features/crypto/presentation/crypto_screen.dart';
import 'package:mdiho/features/profile/data/controller/profile_controller.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';

@RoutePage()
class LeaderboardScreen extends HookConsumerWidget {
  const LeaderboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Fetch leaderboard data when screen is first mounted
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(profileControllerProvider.notifier).getLeaderboard();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Leaderboard",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await ref.read(profileControllerProvider.notifier).getLeaderboard();
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
                  "Compete for the top position, trade more this month and win cash rewards",
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

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 22), // Space for icon alignment
              const Gap(8),
              Text(
                'Username',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            'Monthly traded value',
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(
      profileControllerProvider.select((state) => state.leaderboard),
    );

    return state.when(
      loading: () => state.maybeWhen(
        data: (data) {
          final leaderboard = data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, theme),
              Divider(
                height: 1,
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : Colors.grey.shade300,
              ),
              ListView.separated(
                itemCount: leaderboard.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade500
                        : Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final leaderboardItem = leaderboard[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        const Gap(8),
                        Text(
                          '${leaderboardItem.user?.username}',
                          style: TextStyle(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: '${leaderboardItem.totalTradingValue}'
                                        .formatAsNaira(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: ''),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
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
            Text('Failed to load leaderboard.',
                style: TextStyle(color: Colors.red[600], fontSize: 16)),
            const Gap(6),
            Text(error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      data: (data) {
        final leaderboard = data;
        if (leaderboard.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(52),
                const Icon(Icons.info_outline, color: Colors.grey, size: 48),
                const SizedBox(height: 8),
                Text(
                  "No leaderboard available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, theme),
            Divider(
              height: 1,
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade500
                  : Colors.grey.shade300,
            ),
            ListView.separated(
              itemCount: leaderboard.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.grey.shade300),
              itemBuilder: (context, index) {
                final leaderboardItem = leaderboard[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade400
                              : const Color(0xFFF9F9FB),
                        ),
                        child: Icon(Icons.arrow_upward,
                            size: 12,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF2B2B2B)),
                      ),
                      const Gap(8),
                      Text(
                        '${leaderboardItem.user?.username}',
                        style: TextStyle(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        '${leaderboardItem.totalTradingValue}'.formatAsNaira(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          fontFamily: '',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
