import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/assets.dart';

import '../../../common/app_theme.dart';
import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';

@RoutePage()
class PreferenceScreen extends HookConsumerWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final twoFactorEnabled = useState(true);
    final biometricEnabled = useState(true);
    final selectedIndex = useState(0);
    final themeNotifier =
        ref.watch(themeNotifierProvider); // ✅ Watch ThemeNotifier

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Preferences & Notifications",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customize your app experience and notification preferences.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(10),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingsOption(
                    icon: IconsaxPlusLinear.notification_status,
                    title: "Push Notifications",
                    trailing: Switch(
                      value: twoFactorEnabled.value,
                      activeTrackColor:
                          Colors.green.shade700, // Green track when ON
                      inactiveTrackColor:
                          Colors.grey.shade300, // Gray track when OFF
                      thumbColor: WidgetStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(WidgetState.disabled)) {
                            return Colors.grey; // Thumb color when disabled
                          }
                          return Colors.white; // White thumb in normal state
                        },
                      ),
                      onChanged: (value) {
                        twoFactorEnabled.value = value;
                      },
                    ),
                    context: context,
                  ),
                  _buildSettingsOption(
                    icon: IconsaxPlusLinear.notification_bing,
                    title: "Email Alerts",
                    trailing: Switch(
                      value: biometricEnabled.value,
                      activeTrackColor:
                          Colors.green.shade700, // Green track when ON
                      inactiveTrackColor:
                          Colors.grey.shade300, // Gray track when OFF
                      thumbColor: WidgetStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(WidgetState.disabled)) {
                            return Colors.grey; // Thumb color when disabled
                          }
                          return Colors.white; // White thumb in normal state
                        },
                      ),
                      onChanged: (value) {
                        biometricEnabled.value = value;
                      },
                    ),
                    context: context,
                  ),
                ],
              ),
            ),
            const Gap(16),
            const Text(
              "App Theme",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(16),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectedIndex.value = 0;
                      ref
                          .read(themeNotifierProvider)
                          .toggleTheme(ThemeMode.light);
                    },
                    child: Container(
                      height: 118,
                      width: 143,
                      padding: const EdgeInsets.all(11),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFFBFA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: selectedIndex.value == 0
                              ? BorderSide(
                                  color: AppColors.primaryColor, width: 0.5)
                              : BorderSide.none,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            height: 66, // Fixed height
                            width: 121, // Fixed width
                            PlaceholderAssets.lightmode,
                          ),
                          const Gap(12),
                          Text(
                            'Light Mode',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(26),
                  GestureDetector(
                    onTap: () {
                      selectedIndex.value = 1;
                      ref
                          .read(themeNotifierProvider)
                          .toggleTheme(ThemeMode.dark);
                    },
                    child: Container(
                      height: 11,
                      width: 143,
                      padding: const EdgeInsets.all(11),
                      decoration: ShapeDecoration(
                        color: AppColors.secondaryColor.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: selectedIndex.value == 1
                              ? BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 0.5,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            height: 66, // Fixed height
                            width: 121, // Fixed width
                            PlaceholderAssets.darkmode,
                          ),
                          const Gap(12),
                          const Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            FullButton(
              text: "Save Changes",
              width: double.infinity,
              height: 48,
              onPressed: () {
                Navigator.pop(context);
              },
              textColor: Colors.white,
              color: AppColors.primaryColor.shade500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    String? actionText,
    Widget? actionWidget,
    Widget? trailing,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryColor.shade500,
        size: 16,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          const Gap(6),
          if (actionWidget != null) actionWidget,
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          trailing ??
              TextButton(
                onPressed: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionText ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const Gap(6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
