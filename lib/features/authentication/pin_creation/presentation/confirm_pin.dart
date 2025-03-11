import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../login/presentation/login_screen.dart';

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
class ConfirmPinScreen extends HookConsumerWidget {
  const ConfirmPinScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = useTextEditingController();
    final pinState = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            IconsaxPlusLinear.arrow_left_1,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade500
                  : AppColors.whiteColor.shade100,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Light shadow color
                  blurRadius: 8, // Soft shadow effect
                  spreadRadius: 1, // Spread of the shadow
                  offset: const Offset(0, 2), // Moves shadow slightly down
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Confirm Pin",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Type your PIN code again to confirm",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // PIN Code Field
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 201,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: pinController,
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
                          inactiveFillColor: AppColors.secondaryColor.shade400,
                          selectedFillColor: AppColors.secondaryColor.shade400,
                          selectedColor: AppColors.primaryColor,
                          activeColor: AppColors.primaryColor,
                          inactiveColor: Colors.grey,
                        ),
                        onChanged: (value) {
                          pinNotifier.updatePin(value);
                        },
                      ),
                    ),
                    const Gap(8),
                    // Visibility Toggle Button
                    InkWell(
                      onTap: pinNotifier.toggleVisibility,
                      child: Container(
                        width: 53,
                        height: 53,
                        decoration: ShapeDecoration(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade300
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Center(
                          child: Icon(
                            pinState.isPinHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Next Button
                FullButton(
                  text: "Next",
                  width: double.infinity,
                  height: 48,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
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
