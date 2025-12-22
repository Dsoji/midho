import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';

class KycDialog extends StatelessWidget {
  final VoidCallback onCompleteKyc;

  const KycDialog({
    super.key,
    required this.onCompleteKyc,
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
                // Shield Icon Placeholder
                // Using a large Icon as placeholder for the 3D shield
                Image.asset(
                  ImageAssets.sheild,
                  height: 48,
                  width: 48,
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
              'Verify Your Identity to Trade Crypto',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const Gap(8),
            Text(
              'To start trading crypto, you need to complete a quick KYC verification.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const Gap(24),
            FullButton(
              text: 'Complete KYC',
              width: double.infinity,
              height: 50,
              onPressed: () {
                Navigator.pop(context);
                onCompleteKyc();
              },
              textColor: Colors.white,
              color: AppColors.primaryColor,
              radius: 12,
            ),
          ],
        ),
      ),
    );
  }
}
