import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/toast/toast.dart';
import '../../../bank_network/presentation/bank_network_screen.dart';
import '../../../bottomNav/app_router.gr.dart';

// Define Action Model
class ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap; // Accepts context for navigation
  final Color? textColor;
  ActionItem(this.icon, this.label, this.color, {this.onTap, this.textColor});
}

// Riverpod Provider for Quick Actions List

// Quick Actions Widget
class QuickActionsGrid extends ConsumerWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final quickActionsProvider = Provider<List<ActionItem>>((ref) {
      return [
        ActionItem(
          HugeIcons.strokeRoundedBitcoinTransaction,
          "Sell Crypto",
          theme.brightness == Brightness.dark
              ? const Color(0xFFF89F33)
              : AppColors.primaryColor,
          onTap: () {
            final tabsRouter = AutoTabsRouter.of(
              context,
            );

            tabsRouter.setActiveIndex(1);
          },
        ),
        ActionItem(
          HugeIcons.strokeRoundedGiftCard,
          "Sell Gift Cards",
          theme.brightness == Brightness.dark
              ? const Color(0xFF00E18E)
              : AppColors.primaryColor,
          onTap: () {
            final tabsRouter = AutoTabsRouter.of(
              context,
            );

            tabsRouter.setActiveIndex(3);
          },
        ),
        ActionItem(
          HugeIcons.strokeRoundedSmartPhone01,
          "Buy Airtime",
          theme.brightness == Brightness.dark
              ? const Color(0xFF0087E1)
              : AppColors.primaryColor,
          onTap: () {
            context.router.push(const BuyAirtimeRoute());
          },
        ),
        ActionItem(
          HugeIcons.strokeRoundedTabletConnectedWifi,
          "Buy Data",
          theme.brightness == Brightness.dark
              ? const Color(0xFFAC42FC)
              : AppColors.primaryColor,
          onTap: () {
            context.router.push(const BuyDataRoute());
          },
        ),
        ActionItem(
          HugeIcons.strokeRoundedFootball,
          "Betting",
          theme.brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade400,
          textColor: theme.brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade400,
          onTap: () {
            // context.router.push(const BettingRoute());
            ToastService().showToast(
              NotificationType.info,
              message: 'Betting Coming Soon!!',
            );
          },
        ),
        ActionItem(
          HugeIcons.strokeRoundedElectricPlugs,
          "Buy Electricity",
          theme.brightness == Brightness.dark
              ? const Color(0xFFCAE100)
              : AppColors.primaryColor,
          onTap: () {
            context.router.push(const ElectricityBillRoute());
          },
        ),
        ActionItem(
          HugeIcons.strokeRoundedTv01,
          "Tv Cable",
          theme.brightness == Brightness.dark
              ? const Color(0xFF8B9CF4)
              : AppColors.primaryColor,
          onTap: () {
            context.router.push(const CableBillRoute());
          },
        ),
        ActionItem(
          HugeIcons.strokeRoundedSatellite01,
          "Bank Network",
          theme.brightness == Brightness.dark
              ? const Color(0xFFE1AC00)
              : AppColors.primaryColor,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const BankNetworkScreen()),
            );
          },
        ),
      ];
    });
    final actions = ref.watch(quickActionsProvider);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.darkBorder
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return ActionButton(actions[index]);
        },
      ),
    );
  }
}

// Widget for Each Action Button
class ActionButton extends StatelessWidget {
  final ActionItem action;

  const ActionButton(this.action, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        width: 82,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade600
              : const Color(0xFFF6F8FE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            HugeIcon(
              icon: action.icon,
              color: action.color,
              size: 18,
            ),
            const Gap(10),
            Text(
              action.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 1.4, // line-height (140%)
                letterSpacing: -0.2,
                color: action.textColor ??
                    (theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
