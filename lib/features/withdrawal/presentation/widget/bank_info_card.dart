import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../common/res/app_colors.dart';
import '../../../bottomNav/app_router.gr.dart';

class BankInfoCard extends HookConsumerWidget {
  BankInfoCard({
    super.key,
    this.image,
    required this.name,
    this.status,
    this.percentage,
    required this.actNumber,
    required this.actName,
    this.showBorder = true,
    this.icon = IconsaxPlusLinear.arrow_right_3,
    this.iconTap,
    this.onTap,
    this.showStrength = true,
    this.isAddBank = false,
    this.radius = 0,
    this.delete,
  });

  final bool isAddBank;
  final String? image;
  final String name;
  String? status;
  String? percentage;
  final String actNumber;
  final String actName;
  final bool showBorder;
  final IconData icon;
  final VoidCallback? iconTap;
  final VoidCallback? onTap;
  final bool? showStrength;
  final double? radius;
  final VoidCallback? delete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final int parsedPercentage =
        int.tryParse(percentage?.replaceAll('%', '') ?? '') ?? 0;
    final Color color = parsedPercentage <= 33
        ? Colors.red
        : parsedPercentage <= 66
            ? Colors.amber
            : Colors.green;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: ShapeDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.darkBorder
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!),
            side: showBorder
                ? BorderSide(
                    width: 0.5,
                    color: theme.brightness == Brightness.light
                        ? AppColors.greyColor.shade50
                        : AppColors.secondaryColor.shade400,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: theme.brightness == Brightness.dark
                  ? AppColors.customBlue
                  : const Color(0xFFE6ECFC),
              radius: 14,
              child: Icon(
                IconsaxPlusLinear.bank,
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFFE6ECFC)
                    : AppColors.customBlue,
                size: 16,
              ),
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                if (showStrength == true &&
                    status != null &&
                    percentage != null) ...[
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
                          status!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'at $percentage',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (!isAddBank) ...[
                  const Gap(12),
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
              ],
            ),
            const Spacer(),
            icon == Icons.more_horiz
                ? PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          context.router.push(
                            AddNewBankRoute(isverif: true),
                          );
                        },
                        value: 1,
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Colors.blue),
                            SizedBox(width: 10),
                            Text("Edit"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        onTap: delete,
                        child: const Row(
                          children: [
                            Icon(IconsaxPlusLinear.trash, color: Colors.red),
                            SizedBox(width: 10),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ],
                    offset: const Offset(0, 40),
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade400
                        : Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onSelected: (value) {
                      if (value == 1) {
                        // handle edit
                      } else if (value == 2) {
                        // handle delete
                      }
                    },
                  )
                : Icon(icon, size: 16),
          ],
        ),
      ),
    );
  }
}

class BankInfoCard2 extends HookConsumerWidget {
  const BankInfoCard2({
    super.key,
    required this.name,
    required this.status,
    required this.percentage,
    this.showBorder = true,
    this.iconTap,
    this.onTap,
    this.showStrength = true,
  });

  final String name;

  final String status;
  final String percentage;
  final bool showBorder;
  final VoidCallback? iconTap;
  final VoidCallback? onTap;
  final bool? showStrength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = int.parse(percentage.replaceAll('%', '')) <= 33
        ? Colors.red
        : int.parse(percentage.replaceAll('%', '')) <= 66
            ? Colors.amber
            : Colors.green;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'at $percentage',
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
          ],
        ),
      ),
    );
  }
}
