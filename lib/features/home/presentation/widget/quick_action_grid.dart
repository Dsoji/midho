import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../common/res/app_colors.dart';
import '../../../bank_network/presentation/bank_network_screen.dart'; // Add this package in pubspec.yaml

// Define Action Model
class ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // Accepts context for navigation

  ActionItem(this.icon, this.label, {this.onTap});
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
        ActionItem(IconsaxPlusLinear.bitcoin_convert, "Sell Crypto", onTap: () {
          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(2);
        }),
        ActionItem(IconsaxPlusLinear.gift, "Sell Gift Cards"),
        ActionItem(IconsaxPlusLinear.mobile, "Buy Airtime"),
        ActionItem(IconsaxPlusLinear.wifi_square, "Buy Data"),
        ActionItem(Icons.sports_football_outlined, "Betting"),
        ActionItem(IconsaxPlusLinear.lamp_charge, "Buy Electricity"),
        ActionItem(Icons.monitor, "Tv Cable"),
        ActionItem(IconsaxPlusLinear.bank, "Bank network", onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BankNetworkScreen()),
          );
        }),
      ];
    });
    final actions = ref.watch(quickActionsProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      height: 270,
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
            "Quick Actions",
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.secondaryColor.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(16),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 18,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return ActionButton(actions[index]);
              },
            ),
          ),
        ],
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade600
                  : const Color(0xFFFFFBFA),
              border: Border.all(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade400
                    : const Color(0xFFFFFBFA),
              ),
            ),
            child: Icon(action.icon,
                color: AppColors.primaryColor.shade500, size: 15.5),
          ),
          const Gap(2),
          Text(
            action.label,
            style: TextStyle(
              fontSize: 10,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
