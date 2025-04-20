import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/toast/toast.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../authentication/data/controller/authentication_controller.dart';

class PinState {
  final String pin;
  final bool isPinHidden;

  PinState({this.pin = "", this.isPinHidden = true});

  PinState copyWith({String? pin, bool? isPinHidden}) {
    return PinState(
      pin: pin ?? this.pin,
      isPinHidden: isPinHidden ?? this.isPinHidden,
    );
  }
}

class PinNotifier extends StateNotifier<PinState> {
  PinNotifier() : super(PinState());

  void updatePin(String pin) {
    state = state.copyWith(pin: pin);
  }

  void toggleVisibility() {
    state = state.copyWith(isPinHidden: !state.isPinHidden);
  }
}

final pinProvider = StateNotifierProvider<PinNotifier, PinState>(
  (ref) => PinNotifier(),
);

@RoutePage()
class ChangePinScreen extends HookConsumerWidget {
  const ChangePinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authenticationControllerProvider.notifier).emailVerify(
              userInfo?.email ?? '',
              null,
              'RESETPIN',
            );
      });
      return null;
    }, []);

    final authService = ref.read(authenticationControllerProvider.notifier);

    final theme = Theme.of(context);
    final otpController = useTextEditingController();
    final newPinController = useTextEditingController();

    final confirmPinController = useTextEditingController();
    final isOtpFilled = useState(false);
    final countdown = useState(100);
    final isCounting = useState(true);
    final pinState = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Reset Transaction PIN",
        showBackButton: true,
        showTitle: true,
        showAction: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set a new PIN for secure transactions.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(10),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter the 6-digit code we texted to ${userInfo?.email ?? '...@gmail.com'}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  const Text(
                    "This extra step shows it’s really you trying to reset your transaction pin",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
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
                              child: const Text(
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
                  //New Pin
                  const Text(
                    "New PIN",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 201,
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          controller: confirmPinController,
                          obscureText: pinState.isPinHidden,
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
                            inactiveFillColor:
                                AppColors.secondaryColor.shade400,
                            selectedFillColor:
                                AppColors.secondaryColor.shade400,
                            selectedColor: AppColors.primaryColor,
                            activeColor: AppColors.primaryColor,
                            inactiveColor: Colors.grey,
                          ),
                          onChanged: (value) {
                            pinNotifier.updatePin(value);
                          },
                        ),
                      ),
                      const Gap(20),
                      // Visibility Toggle Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: theme.brightness == Brightness.dark
                                ? [AppColors.secondaryColor.shade400]
                                : [
                                    const Color(0xFFFAFAFA),
                                    const Color(0xFFFFFFFF)
                                  ], // Gradient from FAFAFA to FFFFFF
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          // Light grey border
                        ),
                        child: IconButton(
                          icon: Icon(
                            pinState.isPinHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: pinNotifier.toggleVisibility,
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  const Text(
                    "Confirm New PIN",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 201,
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          controller: newPinController,
                          obscureText: pinState.isPinHidden,
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
                            inactiveFillColor:
                                AppColors.secondaryColor.shade400,
                            selectedFillColor:
                                AppColors.secondaryColor.shade400,
                            selectedColor: AppColors.primaryColor,
                            activeColor: AppColors.primaryColor,
                            inactiveColor: Colors.grey,
                          ),
                          onChanged: (value) {
                            pinNotifier.updatePin(value);
                          },
                        ),
                      ),
                      const Gap(20),
                      // Visibility Toggle Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: theme.brightness == Brightness.dark
                                ? [AppColors.secondaryColor.shade400]
                                : [
                                    const Color(0xFFFAFAFA),
                                    const Color(0xFFFFFFFF)
                                  ], // Gradient from FAFAFA to FFFFFF
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          // Light grey border
                        ),
                        child: IconButton(
                          icon: Icon(
                            pinState.isPinHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: pinNotifier.toggleVisibility,
                        ),
                      )
                    ],
                  ),
                  const Gap(24),
                  // Verify Button
                  FullButton(
                    isLoading: ref
                        .watch(authenticationControllerProvider)
                        .resetPin
                        .isLoading,
                    text: "Verify & Reset",
                    width: double.infinity,
                    height: 48,
                    onPressed: () async {
                      if (otpController.text.isNotEmpty &&
                          newPinController.text.isNotEmpty &&
                          confirmPinController.text.isNotEmpty) {
                        if (newPinController.text ==
                            confirmPinController.text) {
                          final result = await authService.changePin(
                            userInfo?.email ?? '',
                            otpController.text.trim(),
                            newPinController.text.trim(),
                          );
                          if (result == true) {
                            Navigator.pop(context);
                          }
                        } else {
                          ToastService().showToast(
                            NotificationType.info,
                            message: 'New PIN and Confirm PIN do not match',
                          );
                        }
                      } else {
                        ToastService().showToast(
                          NotificationType.info,
                          message: 'Please fill in all fields',
                        );
                      }
                    },
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                ],
              ),
            ),
            const Gap(150),
          ],
        ),
      ),
    );
  }
}
