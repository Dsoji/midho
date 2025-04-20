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
    final theme = Theme.of(context);

    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      height: 52,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Show back button only on step 2 and 3
            InkWell(
              onTap: onBack,
              child: const Icon(
                IconsaxPlusLinear.arrow_left_1,
                size: 20,
              ),
            ),
            const Gap(12),
            SizedBox(
              width: 234,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // First Container (Step 1)
                  Container(
                    height: 6,
                    width: 74, // Adjust width as needed
                    decoration: BoxDecoration(
                      color: currentStep >= 1
                          ? AppColors.primaryColor.shade500 // Filled color
                          : theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade400
                              : Colors.grey[300], // Unfilled color
                      borderRadius: BorderRadius.circular(
                          40), // Rectangular shape with rounded corners
                    ),
                  ),
                  const Gap(6),
                  // Second Container (Step 2)
                  Container(
                    height: 6,
                    width: 74, // Adjust width as needed
                    decoration: BoxDecoration(
                      color: currentStep >= 2
                          ? AppColors.primaryColor.shade500 // Filled color
                          : theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade400
                              : Colors.grey[300], // Unfilled color
                      borderRadius: BorderRadius.circular(
                          40), // Rectangular shape with rounded corners
                    ),
                  ),
                  const Gap(6),
                  // Third Container (Step 3)
                  Container(
                    height: 6,
                    width: 74, // Adjust width as needed
                    decoration: BoxDecoration(
                      color: currentStep >= 3
                          ? AppColors.primaryColor.shade500 // Filled color
                          : theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade400
                              : Colors.grey[300], // Unfilled color
                      borderRadius: BorderRadius.circular(
                          40), // Rectangular shape with rounded corners
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            RichText(
              text: TextSpan(
                text: "$currentStep",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "/$totalSteps",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
