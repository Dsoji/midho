import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/res/assets.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.darkBorder
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildCard(
            title: "Total In-Flow",
            amount: "₦50,000.00",
            iconImage: ImageAssets.logo,
            context: context, // use your preferred icon
          ),
          const SizedBox(width: 16),
          _buildCard(
              title: "Total Withdrawal",
              amount: "₦50,000.00",
              icon: HugeIcons.strokeRoundedArrowUp03,
              context: context),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String amount,
    required BuildContext context,
    String? iconImage,
    IconData? icon,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? Colors.black
              : const Color(0xFFF6F8FE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: theme.brightness == Brightness.light
                    ? const Color(0xFF1B1B1B)
                    : AppColors.blueColor.shade50,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: '',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF1B1B1B)
                        : AppColors.blueColor.shade50,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: '',
                  ),
                ),
                iconImage != null
                    ? Image.asset(
                        iconImage,
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0040E1),
                        ),
                        child: Center(
                          child: HugeIcon(
                            icon: icon ?? Icons.help,
                            size: 13, // Smaller than the container
                            color: theme.brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
