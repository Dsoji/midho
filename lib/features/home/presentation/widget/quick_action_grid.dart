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
    ActionItem(IconsaxPlusLinear.coin, "Sell Crypto"),
    ActionItem(IconsaxPlusLinear.gift, "Sell Gift Cards"),
    ActionItem(IconsaxPlusLinear.mobile, "Buy Airtime"),
    ActionItem(IconsaxPlusLinear.wifi, "Buy Data"),
    ActionItem(IconsaxPlusLinear.game, "Betting"),
    ActionItem(IconsaxPlusLinear.cloud_lightning, "Buy Electricity"),
    ActionItem(Icons.tv_outlined, "Tv Cable"),
    ActionItem(IconsaxPlusLinear.bank, "Bank network"),
  ];
});

// Quick Actions Widget
class QuickActionsGrid extends HookConsumerWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(quickActionsProvider); // Watch the provider

    return Container(
      padding: const EdgeInsets.all(16),
      height: 270, // Increased height slightly to avoid overflow
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Quick Actions",
            style: TextStyle(
              color: AppColors.secondaryColor.shade200,
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFFBFA), // Light orange background
          ),
          child: Icon(action.icon,
              color: AppColors.primaryColor.shade500, size: 18.5),
        ),
        const SizedBox(height: 8),
        Text(
          action.label,
          style: const TextStyle(fontSize: 10, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
