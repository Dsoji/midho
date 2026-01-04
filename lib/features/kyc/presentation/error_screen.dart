import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/widgets/custom_app_bar.dart';
import 'package:mdiho/common/widgets/custom_buttons.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/support_faq/presentation/support_faq_screen.dart';

@RoutePage()
class KycErrorScreen extends HookConsumerWidget {
  const KycErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: true,
        showTitle: false,
        showAction: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(),
              // Error Icon
              _buildErrorIcon(theme),
              const Gap(24),
              // Title
              Text(
                'KYC Failed',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const Gap(16),
              // Description
              Text(
                'We couldn\'t verify your details. Please check your information and try again, or switch between NIN and BVN.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Buttons Row
              Row(
                children: [
                  // Try Again Button
                  Expanded(
                    child: FullButton(
                      text: 'Try Again',
                      width: double.infinity,
                      height: 50,
                      onPressed: () {
                        context.router.popUntil((route) =>
                            route.settings.name ==
                            VerificationMethodRoute.name);
                      },
                      textColor: theme.brightness == Brightness.dark
                          ? Colors.white
                          : (theme.textTheme.bodyLarge?.color ?? Colors.black),
                      color: theme.brightness == Brightness.dark
                          ? AppColors.greyColor.shade800
                          : AppColors.greyColor.shade50,
                    ),
                  ),
                  const Gap(16),
                  // Contact Support Button
                  Expanded(
                    child: FullButton(
                      text: 'Contact Support',
                      width: double.infinity,
                      height: 50,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportFaqScreen(),
                          ),
                        );
                      },
                      textColor: Colors.white,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon(ThemeData theme) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer light red ring with glow effect
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC63C34), // Red
                  Color(0xFFFFFFFF), // White
                ],
              ),
            ),
          ),
          // Inner darker red circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.brightness == Brightness.dark
                  ? Colors.black
                  : const Color(0xFFFDF7F7),
            ),
            child: Icon(
              Icons.close,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
