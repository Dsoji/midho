import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../home/presentation/home_screen.dart';
import 'widget/profile_option.dart';

@RoutePage()
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(0);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Profile",
          showBackButton: false,
          showTitle: true,
          showAction: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Manage your personal information, security settings, and linked accounts all in one place.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(10),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "John Doe",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const Text(
                            "john.doe@example.com",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const ReferralButton(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Profile Options List (Fixed: Using SizedBox instead of Expanded)
              // Adjust height as needed
              const ProfileOption(),
              const Gap(20),

              // Sign Out Section in a Separate Container
              Container(
                height: 48,
                padding: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: buildProfileOption(
                  IconsaxPlusLinear.logout,
                  "Sign Out",
                  context,
                  () {},
                  isDestructive: true,
                ),
              ),
              const Gap(150),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileOption(
      IconData icon, String title, BuildContext context, VoidCallback onTap,
      {bool isDestructive = false}) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.primaryColor.shade500,
        size: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color:
              theme.brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
      ),
      trailing: isDestructive
          ? null
          : Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
    );
  }
}
