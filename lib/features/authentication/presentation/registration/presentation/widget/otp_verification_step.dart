import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../../common/res/app_colors.dart';
import '../../../../../../common/toast/toast.dart';
import '../../../../../../common/widgets/custom_buttons.dart';

class OtpVerificationStep extends HookConsumerWidget {
  final VoidCallback onNext;
  final bool isLoading;

  const OtpVerificationStep({
    super.key,
    required this.onNext,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = useTextEditingController();
    final authService = ref.read(authenticationControllerProvider.notifier);
    final isOtpFilled = useState(false);
    final countdown = useState(100);
    final isCounting = useState(true);

    useEffect(() {
      Timer? timer;

      if (isCounting.value) {
        countdown.value = 100; // Reset countdown when starting
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (countdown.value > 0) {
            countdown.value--;
          } else {
            isCounting.value = false; // Stop timer and show "Resend Code"
            timer.cancel();
          }
        });
      }

      return () => timer?.cancel(); // Cleanup the timer on unmount
    }, [isCounting.value]); // Only restart timer when "Resend Code" is tapped

    final theme = Theme.of(context);
    var box = Hive.box('data');
    final String email = box.get('email');

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                  "Verify Your Email",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter the 6-digit code we just sent to $email",
                  style: const TextStyle(
                    fontSize: 14,
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                  isLoading: isLoading,
                  text: "Verify",
                  width: double.infinity,
                  height: 48,
                  onPressed: () async {
                    if (otpController.text.trim().isEmpty ||
                        otpController.text.trim().length < 6) {
                      ToastService().showToast(
                        NotificationType.info,
                        message: 'Please input a valid OTP.',
                      );
                      return;
                    }
                    final result = await authService.emailConfirm(
                      email,
                      otpController.text.trim(),
                      'SIGNUP',
                    );

                    if (result == true) {
                      onNext();
                    }
                  },
                  textColor: Colors.white,
                  color: AppColors.primaryColor.shade500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
