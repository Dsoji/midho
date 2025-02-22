import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../common/res/app_colors.dart';

class BankInfoCard extends HookConsumerWidget {
  const BankInfoCard({
    super.key,
    required this.image,
    required this.name,
    required this.color,
    required this.status,
    required this.percentage,
    required this.actNumber,
    required this.actName,
    this.showBorder = true,
    this.icon = IconsaxPlusLinear.arrow_right_3,
    this.iconTap,
    this.onTap,
  });

  final String image;
  final String name;
  final Color color;
  final String status;
  final String percentage;
  final String actNumber;
  final String actName;
  final bool showBorder;
  final IconData icon;
  final VoidCallback? iconTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: ShapeDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade500
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: showBorder // Conditionally add border
                ? BorderSide(color: AppColors.greyColor.shade50)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 14,
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const Gap(12),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: color,
                            radius: 3,
                          ),
                          const Gap(4),
                          Text(
                            status,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'at $percentage%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      actNumber,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF707070),
                      ),
                    ),
                    const Gap(12),
                    Text(
                      actName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Icon(
              icon,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
