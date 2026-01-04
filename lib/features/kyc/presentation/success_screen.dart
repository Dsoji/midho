import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/widgets/custom_app_bar.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

@RoutePage()
class KycSuccessScreen extends HookConsumerWidget {
  const KycSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(
          showBackButton: false,
          showTitle: false,
          showAction: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Spacer(),
                // Success Icon
                _buildSuccessIcon(theme),
                const Gap(24),
                // Title
                Text(
                  'KYC Successful',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const Gap(16),
                // Description
                Text(
                  'Your identity has been verified successfully.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  'You can now trade crypto without restrictions.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Continue Button
                FullButton(
                  text: 'Continue to Trading',
                  width: double.infinity,
                  height: 50,
                  onPressed: () {
                    // Navigate to crypto/trading screen
                    // Using index 1 which is the crypto tab in the navbar
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    context.router.popUntil(
                        (route) => route.settings.name == HomeShellRoute.name);
                    // If using auto_route, you might want to use:
                    // context.router.pushAndClearStack(const NaviBarRoute());
                  },
                  textColor: Colors.white,
                  color: AppColors.primaryColor,
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(ThemeData theme) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer gradient ring
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE6FCF1), // Light green
                  Color(0xFF33AC71), // Medium green
                ],
              ),
            ),
          ),
          // Inner circle to create the border effect (12px border thickness)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme
                  .scaffoldBackgroundColor, // Background color to create border
            ),
          ),
          // Inner darker green circle
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent, // Darker green inner circle
            ),
            child: Icon(
              HugeIcons.strokeRoundedDocumentValidation,
              color: AppColors.successColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
