import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showTitle;
  final bool showAction;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final VoidCallback? onActionPressed;
  final IconData actionIcon;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.showTitle = true,
    this.showAction = true,
    this.centerTitle = true,
    this.onBackPressed,
    this.onActionPressed,
    this.actionIcon = Icons.filter_list, // Default action icon
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 2,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                IconsaxPlusLinear.arrow_left_1,
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: showTitle
          ? Text(
              title ?? "",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      actions: showAction
          ? [
              IconButton(
                icon: Icon(
                  actionIcon,
                ),
                onPressed: onActionPressed ?? () {},
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
