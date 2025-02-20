import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/home/presentation/home_screen.dart';

import '../../../../common/res/app_colors.dart';
import '../../../bank_network/presentation/bank_network_screen.dart'; // Add this package in pubspec.yaml

// Define Action Model
class ActionItem {
  final IconData icon;
  final String label;
  final Widget? page;

  ActionItem(this.icon, this.label, this.page);
}

// Riverpod Provider for Quick Actions List
final quickActionsProvider = Provider<List<ActionItem>>((ref) {
  return [
    ActionItem(
        IconsaxPlusLinear.bitcoin_convert, "Sell Crypto", const HomeScreen()),
    ActionItem(IconsaxPlusLinear.gift, "Sell Gift Cards", const HomeScreen()),
    ActionItem(IconsaxPlusLinear.mobile, "Buy Airtime", const HomeScreen()),
    ActionItem(IconsaxPlusLinear.wifi_square, "Buy Data", const HomeScreen()),
    ActionItem(Icons.sports_football_outlined, "Betting", const HomeScreen()),
    ActionItem(
        IconsaxPlusLinear.lamp_charge, "Buy Electricity", const HomeScreen()),
    ActionItem(Icons.monitor, "Tv Cable", const HomeScreen()),
    ActionItem(
        IconsaxPlusLinear.bank, "Bank network", const BankNetworkScreen()),
  ];
});

// Quick Actions Widget
class QuickActionsGrid extends HookConsumerWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(quickActionsProvider); // Watch the provider
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      height: 270, // Increased height slightly to avoid overflow
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
          // Title
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

          // Use Expanded to prevent overflow
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 items per row
                crossAxisSpacing: 18,
                mainAxisSpacing: 20,
                childAspectRatio: 1, // Ensures square layout
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
      onTap: () {
        if (action.page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => action.page!),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade600
                  : const Color(0xFFFFFBFA), // Light orange background
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
