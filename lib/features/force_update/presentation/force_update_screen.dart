import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/profile/data/Model/response/platform_details/data.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ForceUpdateScreen extends HookConsumerWidget {
  final bool isForceUpdate;
  final PlatformDetails platformData;

  const ForceUpdateScreen({
    super.key,
    required this.isForceUpdate,
    required this.platformData,
  });

  Future<void> _openAppStore(BuildContext context) async {
    final String appStoreUrl;

    if (Platform.isIOS) {
      // Replace with your actual App Store URL
      appStoreUrl = 'https://apps.apple.com/ng/app/swiftswap/id6747611208';
    } else {
      // Replace with your actual Play Store URL
      appStoreUrl =
          'https://play.google.com/store/apps/details?id=com.opensaucery.swiftswapp&pcampaignid=web_share';
    }

    final uri = Uri.parse(appStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        Fluttertoast.showToast(
            msg: 'Could not open app store',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !isForceUpdate, // Can pop only if not forced
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Update Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.system_update,
                    size: 64,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Gap(32),

                // Title
                Text(
                  'Update Available',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),

                // Description
                Text(
                  isForceUpdate
                      ? 'A new version of the app is required. Please update to continue using the app.'
                      : 'A new version of the app is available. We recommend updating to get the latest features and improvements.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.5,
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(48),

                // Update Button
                FullButton(
                  text: 'Update Now',
                  width: double.infinity,
                  height: 50,
                  onPressed: () => _openAppStore(context),
                  textColor: Colors.white,
                  color: AppColors.primaryColor,
                  radius: 12,
                ),

                // Skip button (only if not forced)
                if (!isForceUpdate) ...[
                  const Gap(16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
