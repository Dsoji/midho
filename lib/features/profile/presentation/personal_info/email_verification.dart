import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';

@RoutePage()
class EmailVerificationScreen extends HookConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final otpController = useTextEditingController();
    final isOtpFilled = useState(false);
    final countdown = useState(100);
    final isCounting = useState(true);
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Email Verification",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: ShapeDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade500
                    : AppColors.whiteColor.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Light shadow color
                    blurRadius: 8, // Soft shadow effect
                    spreadRadius: 1, // Spread of the shadow
                    offset: const Offset(0, 2), // Moves shadow slightly down
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter the 6-digit code we just sent to your email",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PIN Code Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: theme.brightness == Brightness.dark
                              ? AppColors.whiteColor.shade50
                              : Colors.black),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 45,
                        fieldWidth: 45,
                        activeFillColor: theme.brightness == Brightness.dark
                            ? AppColors.secondaryColor.shade400
                            : const Color(0x0fffff5f),
                        inactiveFillColor: AppColors.secondaryColor.shade400,
                        selectedFillColor: AppColors.secondaryColor.shade400,
                        selectedColor: AppColors.primaryColor,
                        activeColor: AppColors.primaryColor,
                        inactiveColor: Colors.grey,
                      ),
                      onChanged: (value) {
                        isOtpFilled.value = value.trim().length == 6;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Resend Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Didn't receive code "),
                      isCounting.value
                          ? Text(
                              "${countdown.value ~/ 60}:${(countdown.value % 60).toString().padLeft(2, '0')}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : GestureDetector(
                              onTap: () {
                                // Restart countdown
                                isCounting.value = true;
                              },
                              child: Text(
                                "Resend Code",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors
                                      .primaryColor, // Highlight clickable text
                                ),
                              ),
                            ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Verify Button
                  FullButton(
                    text: "Verify Email",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      showEmailUpdateDialog(context);
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEmailUpdateDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade500
              : AppColors.whiteColor.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Email Update Successful",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Your email has been successfully updated to newemail@example.com.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),

              // Info Box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade400
                      : const Color(0xFFEFFBF2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Use your new email to log in next time.",
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Return to Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    context.router.replaceAll([const ProfileRoute()]);

                    Navigator.pop(context);
                  },
                  child: const Text("Return to Profile"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
