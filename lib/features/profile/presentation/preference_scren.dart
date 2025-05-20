import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/profile/data/controller/profile_controller.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/theme_notifier.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import '../../authentication/data/model/payload/profile_payload.dart';

@RoutePage()
class PreferenceScreen extends HookConsumerWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final themeNotifier = ref.watch(themeProvider); // ✅ Watch ThemeNotifier
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;
    final authService = ref.read(authenticationControllerProvider.notifier);
    final profileService = ref.read(profileControllerProvider.notifier);
    final selectedIndex =
        useState(theme.brightness == Brightness.light ? 0 : 1);
    final pushEnabled = useState(userInfo?.pushAlert ?? false);
    final emailEnabled = useState(userInfo?.emailAlert ?? false);
    final themeAlert =
        useState(theme.brightness == Brightness.light ? 'LIGHT' : 'DARK');

    useEffect(() {
      // Set the selected index and theme alert when themeMode changes.
      selectedIndex.value = themeNotifier == ThemeMode.light ? 0 : 1;
      themeAlert.value = themeNotifier == ThemeMode.light ? 'LIGHT' : 'DARK';
      return null;
    }, [themeNotifier]);
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Preferences & Notifications",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Customize your app experience and notification preferences.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(10),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingsOption(
                    icon: IconsaxPlusLinear.notification_status,
                    title: "Push Notifications",
                    trailing: Switch(
                      value: pushEnabled.value ?? false,
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
                        pushEnabled.value = value;
                      },
                    ),
                    context: context,
                  ),
                  Divider(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor
                        : AppColors.whiteColor.shade100,
                  ),
                  _buildSettingsOption(
                    icon: IconsaxPlusLinear.notification_bing,
                    title: "Email Alerts",
                    trailing: Switch(
                      value: emailEnabled.value ?? false,
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
                        emailEnabled.value = value;
                      },
                    ),
                    context: context,
                  ),
                ],
              ),
            ),
            const Gap(16),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "App Theme",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(16),
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : AppColors.whiteColor.shade100,
                shape: const RoundedRectangleBorder(),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Update the selectedIndex and toggle the theme using Riverpod.
                      selectedIndex.value = 0;
                      ref.read(themeProvider.notifier).setLightTheme();

                      themeAlert.value =
                          'LIGHT'; // Optional, if you want to track the theme mode
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
                              ? const BorderSide(
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
                          const Text(
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
                      // Update the selectedIndex and toggle the theme using Riverpod.
                      selectedIndex.value = 1;
                      ref.read(themeProvider.notifier).setDarkTheme();

                      themeAlert.value =
                          'DARK'; // Optional, if you want to track the theme mode
                    },
                    child: Container(
                      height: 118,
                      width: 143,
                      padding: const EdgeInsets.all(11),
                      decoration: ShapeDecoration(
                        color: AppColors.secondaryColor.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: selectedIndex.value == 1
                              ? const BorderSide(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FullButton(
                isLoading: ref
                    .watch(profileControllerProvider)
                    .forgotPassword
                    .isLoading,
                text: "Save Changes",
                width: double.infinity,
                height: 48,
                onPressed: () async {
                  final result =
                      await profileService.updateProfile(ProfilePayload(
                    emailAlert: emailEnabled.value,
                    pushAlert: pushEnabled.value,
                    theme: themeAlert.value,
                  ));
                  if (result == true) {
                    await ref
                        .read(authenticationControllerProvider.notifier)
                        .fetchProfile()
                        .then((_) {
                      Navigator.pop(context);
                    });
                  }
                },
                textColor: Colors.white,
                color: AppColors.primaryColor.shade500,
              ),
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
