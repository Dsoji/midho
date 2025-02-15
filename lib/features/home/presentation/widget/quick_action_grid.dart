import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../common/res/app_colors.dart'; // Add this package in pubspec.yaml

// Define Action Model
class ActionItem {
  final IconData icon;
  final String label;

  ActionItem(this.icon, this.label);
}

// Riverpod Provider for Quick Actions List
final quickActionsProvider = Provider<List<ActionItem>>((ref) {
  return [
    ActionItem(IconsaxPlusLinear.bitcoin_convert, "Sell Crypto"),
    ActionItem(IconsaxPlusLinear.gift, "Sell Gift Cards"),
    ActionItem(IconsaxPlusLinear.mobile, "Buy Airtime"),
    ActionItem(IconsaxPlusLinear.wifi_square, "Buy Data"),
    ActionItem(Icons.sports_football_outlined, "Betting"),
    ActionItem(IconsaxPlusLinear.lamp_charge, "Buy Electricity"),
    ActionItem(Icons.monitor, "Tv Cable"),
    ActionItem(IconsaxPlusLinear.bank, "Bank network"),
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
                crossAxisSpacing: 20,
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
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
              color: AppColors.primaryColor.shade500, size: 18.5),
        ),
        const SizedBox(height: 8),
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
    );
  }
}
