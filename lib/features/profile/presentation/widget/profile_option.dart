import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/profile/presentation/bank/bank_list.dart';
import 'package:mdiho/features/profile/presentation/personal_info/personal_information.dart';
import 'package:mdiho/features/profile/presentation/preference_scren.dart';
import 'package:mdiho/features/profile/presentation/security_settings/security_settings.dart';
import 'package:mdiho/features/suggestion_box/presentation/suggestion_screen.dart';
import 'package:mdiho/features/support_faq/presentation/support_faq_screen.dart';

import '../../../../common/res/app_colors.dart';

class ProfileOption extends StatelessWidget {
  const ProfileOption({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade500
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        // Disable inner scrolling
        children: [
          buildProfileOption(
            IconsaxPlusLinear.user,
            "Personal Information",
            context,
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonalInfoScreen()));
            },
          ),
          Divider(
            thickness: 0.3,
            color: AppColors.greyColor.shade100,
          ),
          buildProfileOption(
            IconsaxPlusLinear.lock,
            "Security Settings",
            context,
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SecurtiySettingsScreen()));
            },
          ),
          Divider(
            thickness: 0.3,
            color: AppColors.greyColor.shade100,
          ),
          buildProfileOption(
            IconsaxPlusLinear.bank,
            "Linked Bank Accounts",
            context,
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LinkedBanksScreen()));
            },
          ),
          Divider(
            thickness: 0.3,
            color: AppColors.greyColor.shade100,
          ),
          buildProfileOption(
            IconsaxPlusLinear.notification_bing,
            "Preferences & Notifications",
            context,
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PreferenceScreen()));
            },
          ),
          Divider(
            thickness: 0.3,
            color: AppColors.greyColor.shade100,
          ),
          buildProfileOption(
            IconsaxPlusLinear.notification_status,
            "Suggestion Box",
            context,
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SuggestionScreen()));
            },
          ),
          Divider(
            thickness: 0.3,
            color: AppColors.greyColor.shade100,
          ),
          buildProfileOption(
            Icons.help_outline,
            "Support and FAQ",
            context,
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SupportFaqScreen()));
            },
          ),
        ],
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
