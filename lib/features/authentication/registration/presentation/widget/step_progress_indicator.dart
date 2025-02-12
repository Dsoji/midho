import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/common/res/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    double progress = currentStep / totalSteps;

    return Container(
      color: AppColors.whiteColor.shade100,
      height: 52,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: 12,
        ),
        child: Row(
          children: [
            if (currentStep > 1) // Show back button only on step 2 and 3
              GestureDetector(
                onTap: onBack,
                child: const Icon(
                  IconsaxPlusLinear.arrow_left_1,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            const Gap(33),
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Background
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            AppColors.primaryColor.shade500, // Progress color
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "$currentStep/$totalSteps",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
