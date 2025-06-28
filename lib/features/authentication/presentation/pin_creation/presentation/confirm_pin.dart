import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/res/app_colors.dart';
import '../../../../../common/toast/toast.dart';
import '../../../../../common/widgets/custom_buttons.dart';
import '../../../../bottomNav/app_router.gr.dart';
import '../../../../profile/data/controller/profile_controller.dart';
import '../../../data/controller/authentication_controller.dart';
import '../../../data/model/payload/profile_payload.dart';

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

final logger = Logger();

@RoutePage()
class ConfirmPinScreen extends HookConsumerWidget {
  const ConfirmPinScreen({
    super.key,
    required this.pin,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.biometric,
  });
  final String pin;
  final String firstname;
  final String lastname;

  final String phone;
  final bool biometric;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = useTextEditingController();
    final pinState = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);
    final theme = Theme.of(context);
    final authService = ref.read(authenticationControllerProvider.notifier);
    final profileService = ref.read(profileControllerProvider.notifier);
    final currentScreen = useState<String>("login");
    final box = Hive.box('data');
    box.put('is_auth', true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF151515)
            : AppColors.whiteColor.shade100,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            IconsaxPlusLinear.arrow_left_1,
            size: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          const Gap(24),
          Container(
            decoration: ShapeDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF151515)
                  : AppColors.whiteColor.shade100,
              shape: const RoundedRectangleBorder(),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Light shadow color
                  blurRadius: 3, // Soft shadow effect
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
                    const Spacer(),
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
                  isLoading: ref
                      .watch(profileControllerProvider)
                      .forgotPassword
                      .isLoading,
                  text: "Next",
                  width: double.infinity,
                  height: 48,
                  onPressed: () async {
                    if (pin == pinController.text) {
                      logger.d(pinController.text);

                      // Create the profile payload directly
                      final profilePayload = ProfilePayload(
                        pin: pinController.text.trim(),
                      );

                      // Update the state with the new profile payload
                      authService.updateProfileDetails(profilePayload);

                      // Use the profile payload directly instead of getting it from state
                      final result =
                          await profileService.updateProfile(profilePayload);

                      if (result == true && context.mounted) {
                        final box = Hive.box('data');
                        await box.put('remember_me', false);
                        currentScreen.value = "app";
                        box.put('is_auth', false);
                        context.router.replace(const NaviBarRoute());
                      }
                    } else {
                      Navigator.pop(context);
                      ToastService().showToast(
                        NotificationType.info,
                        message: 'Pin does not match. Try again',
                      );
                      return;
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
