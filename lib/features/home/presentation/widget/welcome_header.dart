import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/assets.dart';

import '../../../../common/res/app_colors.dart';
import '../../../authentication/data/controller/authentication_controller.dart';
import '../../../bottomNav/app_router.gr.dart';

class WelcomeHeader extends HookConsumerWidget {
  const WelcomeHeader({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF151515)
            : Colors.white, // light background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Avatar + Texts
          Row(
            children: [
              // Avatar
              Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1EEFF), // light blue bg
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    PlaceholderAssets.pfp, // <- replace with your asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Welcome + Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${userInfo?.firstname} ${userInfo?.lastname}',
                    style: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.primaryColor.shade700, // deep navy
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Right: Bell Icon
          GestureDetector(
            onTap: () {
              context.navigateTo(const NotificationRoute());
            },
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade400
                    : const Color(0xFFF6F8FE), // light icon background
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_none,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF001E91),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
