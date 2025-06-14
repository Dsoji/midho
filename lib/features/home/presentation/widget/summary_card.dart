import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/res/assets.dart';
import '../../../authentication/data/controller/authentication_controller.dart';

class SummaryCards extends HookConsumerWidget {
  const SummaryCards({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;
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
                "${userInfo?.wallet?.currency ?? ''} ${userInfo?.wallet?.inFlow ?? 0}"
                    .commaFormat(),
            iconImage: ImageAssets.logo,
            context: context, // use your preferred icon
          ),
          const SizedBox(width: 16),
          _buildCard(
              title: "Total Withdrawal",
              amount:
                  "${userInfo?.wallet?.currency ?? ''} ${userInfo?.wallet?.outFlow ?? 0}"
                      .commaFormat(),
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
