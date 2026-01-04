import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:restart_app/restart_app.dart';

class PatchUpdateDialog extends StatefulWidget {
  final VoidCallback? onDismiss;

  const PatchUpdateDialog({
    super.key,
    this.onDismiss,
  });

  @override
  State<PatchUpdateDialog> createState() => _PatchUpdateDialogState();
}

class _PatchUpdateDialogState extends State<PatchUpdateDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: PopScope(
        canPop: true,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.system_update,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onDismiss?.call();
                    },
                    child: Icon(
                      Icons.close,
                      color: theme.iconTheme.color,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Text(
                'Patch Update in Progress',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const Gap(8),
              Text(
                'A patch update is being downloaded in the background. You can continue using the app while the update downloads.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    'Downloading update...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog shown when patch update is completed
class PatchUpdateCompleteDialog extends StatelessWidget {
  const PatchUpdateCompleteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.successColor,
                    size: 32,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: theme.iconTheme.color,
                    size: 24,
                  ),
                ),
              ],
            ),
            const Gap(16),
            Text(
              'Update Downloaded',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const Gap(8),
            Row(
              children: [
                Text(
                  'The patch update has been downloaded successfully. \nYou can restart the app to apply the update.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const Gap(12),
                FullButton(
                    text: 'Restart',
                    width: 100,
                    height: 40,
                    onPressed: () {
                      Restart.restartApp(
                        /// In Web Platform, Fill webOrigin only when your new origin is different than the app's origin
                        // webOrigin: 'http://example.com',

                        // Customizing the restart notification message (only needed on iOS)
                        notificationTitle: 'Restarting App',
                        notificationBody:
                            'Please tap here to open the app again.',
                      );
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor)
              ],
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
