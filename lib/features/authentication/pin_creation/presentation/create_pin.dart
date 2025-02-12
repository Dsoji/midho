import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/authentication/pin_creation/presentation/confirm_pin.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_buttons.dart';

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
class CreatePinScreen extends HookConsumerWidget {
  const CreatePinScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = useTextEditingController();
    final pinState = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Pin",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Set PIN code for your transactions",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // PIN Code Field
                Row(
                  children: [
                    Expanded(
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: pinController,
                        obscureText: pinState.isPinHidden,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          activeFillColor: Colors.white,
                          selectedColor: AppColors.primaryColor,
                          activeColor: AppColors.primaryColor,
                          inactiveColor: Colors.grey,
                        ),
                        onChanged: (value) {
                          pinNotifier.updatePin(value);
                        },
                      ),
                    ),

                    // Visibility Toggle Button
                    IconButton(
                      icon: Icon(
                        pinState.isPinHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: pinNotifier.toggleVisibility,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConfirmPinScreen()));
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
