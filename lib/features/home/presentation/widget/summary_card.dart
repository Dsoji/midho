import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/res/assets.dart';
import '../../../authentication/data/controller/authentication_controller.dart';

class SummaryCards extends HookConsumerWidget {
  const SummaryCards({super.key});

  // Add this helper function to format numbers with K/M suffixes
  String _formatCompactNumber(num value) {
    if (value >= 1000000) {
      final millions = value / 1000000;
      if (millions % 1 == 0) {
        return '${millions.toInt()}M';
      } else {
        return '${millions.toStringAsFixed(2)}M'
            .replaceAll(RegExp(r'\.?0+$'), '');
      }
    } else if (value >= 1000) {
      final thousands = value / 1000;
      if (thousands % 1 == 0) {
        return '${thousands.toInt()}k';
      } else {
        return '${thousands.toStringAsFixed(2)}k'
            .replaceAll(RegExp(r'\.?0+$'), '');
      }
    } else {
      return value.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;

    // Update line 30 to use the new formatting
    // Extract the number from the string, format it, then add currency
    const inflowValue = 10000000000000000; // or get from userInfo
    final formattedInflow = _formatCompactNumber(inflowValue);

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
            amount:
                "${userInfo?.wallet?.currency ?? ''} ${userInfo?.wallet?.inFlow ?? 0}",
            iconImage: ImageAssets.logo2,
            context: context,
          ),
          const SizedBox(width: 16),
          _buildCard(
              title: "Total Withdrawal",
              amount:
                  "${userInfo?.wallet?.currency ?? ''} ${_formatCompactNumber(userInfo?.wallet?.outFlow ?? 0)}",
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
                // Wrap the amount Text with FittedBox to make it shrink
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
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
