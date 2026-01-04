import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart'
    show BvnVerificationRoute, NINVerificationRoute;

@RoutePage()
class VerificationMethodScreen extends HookConsumerWidget {
  const VerificationMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              'Choose Verification Method',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const Gap(8),
            Text(
              'Select how you’d like to verify your identity to start trading crypto.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const Gap(32),
            _VerificationOptionCard(
              title: 'Verify with BVN',
              subtitle:
                  'Fast and widely supported. Uses your Bank Verification Number, Automatically matches your bank records, Secure & encrypted',
              icon: HugeIcons.strokeRoundedBank,
              onTap: () {
                context.router.push(const BvnVerificationRoute());
              },
            ),
            const Gap(16),
            _VerificationOptionCard(
              title: 'Verify with NIN',
              subtitle:
                  'Government-issued ID verification. Uses your National Identification Number, Works without bank linkage, Secure & encrypted',
              icon: HugeIcons.strokeRoundedBank,
              onTap: () {
                context.router.push(const NINVerificationRoute());
              },
            ),
            const Gap(32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade400
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedInformationCircle,
                        size: 20,
                        color: AppColors.primaryColor,
                      ),
                      Gap(8),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    'We only need the following details',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      _buildBulletPoint('Full Name', theme),
                      const Gap(8),
                      _buildBulletPoint('Phone Number', theme),
                      const Gap(8),
                      _buildBulletPoint('Date of birth', theme),
                    ],
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: theme.dividerColor.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9F7FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(child: Text('🔒'))),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your bank login details are never accessed or stored.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Gap(2),
                              Text(
                                'Your information is encrypted and used strictly for verification purposes.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '•',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 14,
            ),
          ),
          const Gap(8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _VerificationOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // The card is blue (primary color) with white text, which typically looks good in both light and dark modes
    // unless the primary color changes significantly. Assuming standard blue card.
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.shade500,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '🇳🇬',
                  ),
                ),
              ],
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
