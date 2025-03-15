import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/success_dialogue.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/success_dialog.dart';
import '../bottomNav/app_router.gr.dart';

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
class TransactionPinScreen extends HookConsumerWidget {
  const TransactionPinScreen({
    super.key,
    required this.info,
    this.selectedType,
  });

  final String info;
  final String? selectedType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = useTextEditingController();
    final pinState = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);
    final theme = Theme.of(context);
    void handleDialog() {
      if (selectedType == "Airtime") {
        showSuccessDialog(
          context: context,
          title: "Airtime Purchase Successful!",
          details: [
            {"Network": "Glo"},
            {"Phone Number": "08012345678"},
            {"Amount Sold": "₦500"},
            {"Payment Source": "Wallet"},
          ],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.replaceAll([
              StandAloneTransactionDetailsRoute(
                  type: 'Bill Payment', status: 'Completed'),
            ]);
            Navigator.pop(context);
          },
          onSecondaryAction: () {
            context.router.replaceAll([const BuyAirtimeRoute()]);
          },
          primaryButtonColor: Colors.orange,
          backgroundColor: Colors.blue.shade900,
        );
      } else if (selectedType == "Data") {
        showSuccessDialog(
          context: context,
          title: "Data Purchase Successful!",
          details: [
            {"Network": "MTN"},
            {"Phone Number": "08012345678"},
            {"Plan": "1GB @ ₦500"},
            {"Payment Source": "Wallet"},
          ],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.replaceAll([
              StandAloneTransactionDetailsRoute(
                  type: 'Bill Payment', status: 'Completed'),
            ]);
            Navigator.pop(context);
          },
          onSecondaryAction: () {
            context.router.replaceAll([const BuyDataRoute()]);
          },
          primaryButtonColor: Colors.orange,
          backgroundColor: Colors.blue.shade900,
        );
      } else if (selectedType == "Electricity") {
        showSuccessDialog(
          context: context,
          title: "Transaction Summary",
          details: [
            {"Provider": "Ikeja Electric"},
            {"Meter Number": "12345678901"},
            {"Meter Type": "Prepaid"},
            {"Amount": "₦5,000"},
            {"Payment Source": "Wallet"},
            {"Token": "1234-5678-9012"},
          ],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.replaceAll([
              StandAloneTransactionDetailsRoute(
                  type: 'Bill Payment', status: 'Completed'),
            ]);
            Navigator.pop(context);
          },
          onSecondaryAction: () {
            context.router.replaceAll([const ElectricityBillRoute()]);
          },
          primaryButtonColor: Colors.orange,
          backgroundColor: Colors.blue.shade900,
        );
      } else if (selectedType == "DSTV") {
        showSuccessDialog(
          context: context,
          title: "Subscription Successful!",
          details: [
            {"Provider": "DSTV"},
            {"Smart Card Number": "12345678901"},
            {"Package": "DSTV Compact\n₦8,000/Month"},
            {"Amount": "₦8,000"},
            {"Payment Source": "Wallet"},
            {"Token": "1234-5678-9012"},
          ],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.replaceAll([
              StandAloneTransactionDetailsRoute(
                  type: 'Bill Payment', status: 'Completed'),
            ]);
            Navigator.pop(context);
          },
          onSecondaryAction: () {
            context.router.replaceAll([const CableBillRoute()]);
          },
          primaryButtonColor: Colors.orange,
          backgroundColor: Colors.white,
        );
      } else if (selectedType == "Betting") {
        showSuccessDialog(
          context: context,
          title: "Your deposit of ₦5,000 to SportyBet was successful.",
          details: [],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.replaceAll([
              StandAloneTransactionDetailsRoute(
                  type: 'Bill Payment', status: 'Completed'),
            ]);
            Navigator.pop(context);
          },
          onSecondaryAction: () {
            context.router.replaceAll([const BettingRoute()]);
          },
          primaryButtonColor: Colors.black,
          backgroundColor: Colors.white,
        );
      } else if (selectedType == null) {
        showDialog(
          context: context,
          builder: (context) => const WithdrawalSuccessDialogScreen(
            isHome: null,
          ),
        );
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Enter Your Transaction Pin',
        showAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            Text(
              "For security, please enter your 4-digit PIN.  ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.greyColor.shade400,
              ),
            ),
            const Gap(16),
            Container(
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // PIN Code Field
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 213,
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
                            fieldHeight: 53,
                            fieldWidth: 53,
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
                      const Gap(23),
                      // Visibility Toggle Button
                      GestureDetector(
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
                  const Gap(24),

                  // Next Button
                  FullButton(
                    text: "Confirm",
                    width: double.infinity,
                    height: 48,
                    onPressed: () => handleDialog(),
                    doublePressed: () => showWithdrawalFailedDialog(context),
                    textColor: Colors.white,
                    color: AppColors.primaryColor.shade500,
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Forgot PIN?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade400
                              : Colors.transparent,
                          side: BorderSide(
                            color: theme.brightness == Brightness.dark
                                ? AppColors.secondaryColor.shade300
                                : Colors.grey.shade300,
                          ), // Border color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Matches the image
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        child: Text(
                          "Reset PIN",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                  InfoWidget(
                    theme: theme,
                    text: info,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showWithdrawalFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const WithdrawalFailedDialog(),
    );
  }
}

class WithdrawalFailedDialog extends StatelessWidget {
  const WithdrawalFailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.brightness == Brightness.dark
          ? AppColors.secondaryColor.shade500
          : Colors.white, // Dark theme background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success Icon

          // Title
          const Text(
            "Withdrawal Failed",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          const Text(
            "₦50,000.00 has been refunded to your wallet.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: '',
            ),
          ),

          const Gap(16),

          // Info Banner
          InfoWidget(
            text: " Try again later or use a different bank account.",
            theme: theme,
          ),

          const SizedBox(height: 16),

          // View Transaction Details Button
          FullButton(
            text: "Retry",
            width: double.infinity,
            height: 48,
            onPressed: () {},
            textColor: Colors.white,
            color: AppColors.primaryColor.shade500,
          ),
          const SizedBox(height: 12),

          // Back to Dashboard
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Contact Support",
              style: TextStyle(
                fontSize: 16,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to Create Detail Row
  Widget _buildDetailRow(String title, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: '',
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )),
          Text(value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: '',
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              )),
        ],
      ),
    );
  }
}
