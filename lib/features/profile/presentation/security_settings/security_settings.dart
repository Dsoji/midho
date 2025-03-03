import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/profile/presentation/security_settings/change_password.dart';
import 'package:mdiho/features/profile/presentation/security_settings/change_pin_screen.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_app_bar.dart';

@RoutePage()
class SecurtiySettingsScreen extends HookConsumerWidget {
  const SecurtiySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final twoFactorEnabled = useState(true);
    final biometricEnabled = useState(true);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Security Settings",
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
              "Enhance your account security by updating your password, PIN, or enabling additional authentication.",
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
                    icon: IconsaxPlusLinear.lock_1,
                    title: "Password",
                    actionText: "Change Password",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen()));
                    },
                    context: context,
                  ),
                  _buildSettingsOption(
                    icon: IconsaxPlusLinear.lock,
                    title: "Transaction PIN",
                    actionText: "Reset PIN",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePinScreen()));
                    },
                    context: context,
                  ),
                  _buildSettingsOption(
                    icon: IconsaxPlusLinear.shield_security,
                    title: "Two-Factor Authentication",
                    actionWidget: _buildComingSoonLabel(context),
                    trailing: Switch(
                      value: twoFactorEnabled.value,
                      activeColor: Colors.green.shade700,
                      onChanged: (value) {
                        twoFactorEnabled.value = value;
                      },
                      thumbColor: WidgetStateProperty.all(Colors.white),
                    ),
                    context: context,
                  ),
                  _buildSettingsOption(
                    icon: IconsaxPlusLinear.finger_scan,
                    title: "Biometric Authentication",
                    trailing: Switch(
                      value: biometricEnabled.value,
                      activeColor: Colors.green.shade700,
                      onChanged: (value) {
                        biometricEnabled.value = value;
                      },
                      thumbColor: WidgetStateProperty.all(Colors.white),
                    ),
                    context: context,
                  ),
                ],
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

  Widget _buildComingSoonLabel(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade400
            : const Color(0xFFE7FBFE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "Coming soon",
        style: TextStyle(
          color:
              theme.brightness == Brightness.dark ? Colors.white : Colors.green,
          fontSize: 12,
        ),
      ),
    );
  }
}
