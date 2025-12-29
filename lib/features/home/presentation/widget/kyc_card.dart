import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/app_colors.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:mdiho/features/kyc/presentation/verification_method.dart';

class CompletedKycCard extends HookConsumerWidget {
  const CompletedKycCard({super.key, this.radiues = 16});
  final double radiues;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authenticationControllerProvider).userDetails;
    final kycStatus = userAsync.maybeWhen(
      data: (user) => user.kyc,
      orElse: () => null,
    );
    final enforceKyc = userAsync.maybeWhen(
      data: (user) => user.enforceKyc,
      orElse: () => null,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VerificationMethodScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E3A8A), // Deep blue
              AppColors.primaryColor, // Lighter blue
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radiues),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radiues),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Shield positioned at the left edge
              Positioned(
                left: -40,
                top: -20,
                bottom: -20,
                child: Transform.rotate(
                  angle: 7.88 * 3.14159 / 180,
                  child: Image.asset(
                    ImageAssets.sheild,
                    height: 165.14321982710416,
                    width: 165.14321982710416,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Main content with padding
              Padding(
                padding: const EdgeInsets.only(
                  left: 70,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    const Gap(46),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Complete Your KYC!',
                            style: TextStyle(
                              color: Color(0xFFBFEFFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            enforceKyc == true
                                ? 'You need to complete your kyc to continue trading crypto'
                                : 'You can still continue exchanging but it\'s best to complete your KYC now to get access to new feature coming soon',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(12),
                    // Arrow Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0289C0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        IconsaxPlusLinear.arrow_right,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
