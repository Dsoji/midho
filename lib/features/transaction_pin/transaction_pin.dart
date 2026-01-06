import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../common/res/app_colors.dart';
import '../../../../common/utils/checksum_helper.dart';
import '../../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/success_dialog.dart';
import '../authentication/data/controller/authentication_controller.dart';
import '../bills/data/model/response/airtime_transaction/airtime_transaction.dart';
import '../bottomNav/app_router.gr.dart';
import '../profile/presentation/security_settings/change_pin_screen.dart';
import '../transaction/data/controller/transaction_controller.dart';

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
    this.assetId,
    this.amount,
    this.accountNumber,
  });

  final String info;
  final String? selectedType;
  final String? assetId;
  final String? amount;
  final String? accountNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinController = useTextEditingController();
    final pinState = ref.watch(pinProvider);
    final pinNotifier = ref.read(pinProvider.notifier);
    final theme = Theme.of(context);
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;
    final biometricEnabled = userInfo?.biometrics ?? false;

    // Generate a fixed time window for the duration of this screen's lifecycle
    final timeWindow =
        useMemoized(() => ChecksumHelper.get10SecondTimeWindow());

    void handleDialog() async {
      if (selectedType == "Airtime") {
        // Generate checksum with current 30-second window
        final checksum = ChecksumHelper.generateBillChecksum(
          assetId: assetId,
          amount: amount,
          accountNumber: accountNumber,
          transactionType: 'Airtime',
          timeWindow: timeWindow,
        );

        final result =
            await ref.read(transactionControllerProvider.notifier).buyAirtime(
                  assetId: assetId ?? '',
                  amount: amount != null ? int.parse(amount!) : 0,
                  accountNumber: accountNumber ?? '',
                  pin: biometricEnabled ? "biometrics" : pinController.text,
                  checksum: checksum,
                );

        if (result == true) {
          final airtimeTransactions =
              ref.watch(transactionControllerProvider).buyAirtime.valueOrNull;
          final airtimeDetails = airtimeTransactions?.metadata;
          showSuccessDialog(
            context: context,
            title: "Airtime Purchase Successful!",
            details: [
              {"Network": airtimeDetails?.vendor?.name ?? ''},
              {"Phone Number": airtimeTransactions?.accountNumber ?? ''},
              {
                "Amount Sold":
                    "${airtimeTransactions?.baseCurrency} ${airtimeDetails?.amount}"
              },
              {"Payment Source": "Wallet"},
            ],
            buttonText: "View Details",
            onButtonPressed: () {
              context.router.push(
                BillTransactionDetailsRoute(
                    type: airtimeTransactions?.type ?? '',
                    status: airtimeTransactions?.status ?? '',
                    transaction: airtimeTransactions ?? AirtimeTransaction()),
              );
            },
            onSecondaryAction: () {
              context.router.popUntil(
                  (route) => route.settings.name == BuyAirtimeRoute.name);
            },
            primaryButtonColor: Colors.orange,
            backgroundColor: Colors.blue.shade900,
            secondaryButtonText: 'Buy More Airtime',
          );
        }
      } else if (selectedType == "Data") {
        final checksum = ChecksumHelper.generateBillChecksum(
          assetId: assetId,
          amount: null,
          accountNumber: accountNumber,
          transactionType: 'Data',
          timeWindow: timeWindow,
        );

        final result =
            await ref.read(transactionControllerProvider.notifier).buyData(
                  assetId: assetId ?? '',
                  accountNumber: accountNumber ?? '',
                  pin: biometricEnabled ? "biometrics" : pinController.text,
                  checksum: checksum,
                );
        final airtimeTransactions =
            ref.watch(transactionControllerProvider).buyData.valueOrNull;
        final airtimeDetails = airtimeTransactions?.metadata;
        if (result == true) {
          showSuccessDialog(
            context: context,
            title: "Data Purchase Successful!",
            details: [
              {"Network": airtimeDetails?.vendor?.name ?? ''},
              {"Phone Number": airtimeTransactions?.accountNumber ?? ''},
              {
                "Amount Sold":
                    "${airtimeTransactions?.baseCurrency} ${airtimeDetails?.amount}"
              },
              {"Payment Source": "Wallet"},
            ],
            buttonText: "View Details",
            onButtonPressed: () {
              ref
                  .read(transactionControllerProvider.notifier)
                  .fetchTransactions();
              ref
                  .read(transactionControllerProvider.notifier)
                  .getTransactions();
              context.router.push(
                BillTransactionDetailsRoute(
                    type: airtimeTransactions?.type ?? '',
                    status: airtimeTransactions?.status ?? '',
                    transaction: airtimeTransactions ?? AirtimeTransaction()),
              );
            },
            onSecondaryAction: () {
              ref
                  .read(transactionControllerProvider.notifier)
                  .fetchTransactions();
              ref
                  .read(transactionControllerProvider.notifier)
                  .getTransactions();
              context.router.popUntil(
                  (route) => route.settings.name == BuyDataRoute.name);
            },
            primaryButtonColor: Colors.orange,
            backgroundColor: Colors.blue.shade900,
            secondaryButtonText: 'Buy More Data',
          );
        }
      } else if (selectedType == "Electricity") {
        final checksum = ChecksumHelper.generateBillChecksum(
          assetId: assetId,
          amount: amount,
          accountNumber: accountNumber,
          transactionType: 'Electricity',
          timeWindow: timeWindow,
        );

        final result = await ref
            .read(transactionControllerProvider.notifier)
            .buyElectricity(
              assetId: assetId ?? '',
              amount: amount != null ? int.parse(amount!) : 0,
              accountNumber: accountNumber ?? '',
              pin: pinController.text,
              checksum: checksum,
            );
        final airtimeTransactions =
            ref.watch(transactionControllerProvider).buyData.valueOrNull;
        final airtimeDetails = airtimeTransactions?.metadata;
        if (result == true) {
          showSuccessDialog(
            context: context,
            title: "Transaction Summary",
            details: [
              {"Network": airtimeDetails?.vendor?.name ?? ''},
              {"Phone Number": airtimeTransactions?.accountNumber ?? ''},
              {
                "Amount Sold":
                    "${airtimeTransactions?.baseCurrency} ${airtimeDetails?.amount}"
              },
              {"Payment Source": "Wallet"},
            ],
            buttonText: "View Details",
            onButtonPressed: () {
              context.router.push(
                BillTransactionDetailsRoute(
                    type: airtimeTransactions?.type ?? '',
                    status: airtimeTransactions?.status ?? '',
                    transaction: airtimeTransactions ?? AirtimeTransaction()),
              );
            },
            onSecondaryAction: () {
              context.router.popUntil(
                  (route) => route.settings.name == ElectricityBillRoute.name);
            },
            primaryButtonColor: AppColors.primaryColor,
            backgroundColor: Colors.blue.shade900,
            secondaryButtonText: 'Buy More Electricity',
          );
        }
      } else if (selectedType == "DSTV") {
        final checksum = ChecksumHelper.generateBillChecksum(
          assetId: assetId,
          amount: null,
          accountNumber: accountNumber,
          transactionType: 'CableTv',
          timeWindow: timeWindow,
        );

        final result =
            await ref.read(transactionControllerProvider.notifier).buyCableTv(
                  assetId: assetId ?? '',
                  accountNumber: accountNumber ?? '',
                  pin: pinController.text,
                  checksum: checksum,
                );
        final airtimeTransactions =
            ref.watch(transactionControllerProvider).buyData.valueOrNull;
        final airtimeDetails = airtimeTransactions?.metadata;
        if (result == true) {
          showSuccessDialog(
            context: context,
            title: "Subscription Successful!",
            details: [
              {"Network": airtimeDetails?.vendor?.name ?? ''},
              {"Smart Card Number": airtimeTransactions?.accountNumber ?? ''},
              {"Package": airtimeDetails?.product?.name ?? ''},
              {
                "Amount":
                    "${airtimeTransactions?.baseCurrency} ${airtimeDetails?.amount}"
              },
              {"Payment Source": "Wallet"},
              {"Token": "1234-5678-9012"},
            ],
            buttonText: "View Details",
            onButtonPressed: () {
              context.router.push(
                BillTransactionDetailsRoute(
                    type: airtimeTransactions?.type ?? '',
                    status: airtimeTransactions?.status ?? '',
                    transaction: airtimeTransactions ?? AirtimeTransaction()),
              );
            },
            onSecondaryAction: () {
              context.router.popUntil(
                  (route) => route.settings.name == CableBillRoute.name);
            },
            primaryButtonColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            secondaryButtonText: 'Buy More Subscription',
          );
        }
      } else if (selectedType == "Betting") {
        showSuccessDialog(
          context: context,
          title: "Your deposit of ₦5,000 to SportyBet was successful.",
          details: [],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.replaceAll([
              BillTransactionDetailsRoute(
                  type: 'Bill Payment',
                  status: 'Completed',
                  transaction: AirtimeTransaction()),
            ]);
            Navigator.pop(context);
          },
          secondaryButtonText: 'Place more bets',
          onSecondaryAction: () {
            context.router
                .popUntil((route) => route.settings.name == BettingRoute.name);
          },
          primaryButtonColor: Colors.black,
          backgroundColor: Colors.white,
        );
      } else if (selectedType == "Withdrawal") {
        final transaction =
            ref.watch(transactionControllerProvider).withdrawal.valueOrNull;
        showSuccessDialog(
          context: context,
          title: "Withdrawal Successful",
          details: [
            {"Bank Account": transaction?.accountNumber ?? ''},
            {"Withdrawal Amount": "₦${transaction?.amount ?? 0}"},
            {"Fee": "₦${transaction?.fee ?? 0}"},
            {"Total Amount Sent": "₦${transaction?.amount ?? 0}"},
          ],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.push(const HomeRoute());
          },
          onSecondaryAction: () {
            context.router.root.replaceAll([const ProfileRoute()]);
            Navigator.of(context).pop;
          },
          secondaryButtonText: 'Go to Home',
        );
      } else if (selectedType == null) {
        showSuccessDialog(
          context: context,
          title: "Withdrawal Successful",
          details: [],
          buttonText: "View Details",
          onButtonPressed: () {
            context.router.push(const HomeRoute());
          },
          onSecondaryAction: () {
            context.router.root.replaceAll([const ProfileRoute()]);
            Navigator.of(context).pop;
          },
          secondaryButtonText: 'Go to Home',
        );

        // showDialog(
        //   context: context,
        //   builder: (context) => const WithdrawalSuccessDialogScreen(
        //     isHome: null,
        //   ),
        // );
      }
    }

    useEffect(() {
      Future<void> authenticateWithBiometrics() async {
        if (biometricEnabled) {
          final localAuth = LocalAuthentication();
          bool canAuthenticate = await localAuth.canCheckBiometrics ||
              await localAuth.isDeviceSupported();

          if (canAuthenticate) {
            try {
              final authenticated = await localAuth.authenticate(
                localizedReason: "Authenticate to proceed with transaction",
                options: const AuthenticationOptions(biometricOnly: true),
              );

              if (authenticated) {
                handleDialog();
              }
            } catch (e) {
              debugPrint("Biometric authentication failed: $e");
            }
          }
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        authenticateWithBiometrics();
      });

      return null;
    }, []);

    final isLoading = selectedType == "Airtime"
        ? ref.watch(transactionControllerProvider).buyAirtime.isLoading
        : selectedType == "Data"
            ? ref.watch(transactionControllerProvider).buyData.isLoading
            : selectedType == "Electricity"
                ? ref
                    .watch(transactionControllerProvider)
                    .buyElectricity
                    .isLoading
                : selectedType == "DSTV"
                    ? ref
                        .watch(transactionControllerProvider)
                        .cableTvPlans
                        .isLoading
                    : false;

    return Scaffold(
      appBar: const CustomAppBar(
        showAction: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? AppColors.darkBorder
                  : Colors.white,
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
                const Gap(16),
                Text(
                  "Enter Your Transaction Pin",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.greyColor.shade400,
                  ),
                ),
                const Gap(16),
                Text(
                  "For security, please enter your 4-digit PIN.  ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.greyColor.shade400,
                  ),
                ),
                const Gap(16),
                // PIN Code Field
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 233,
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
                    GestureDetector(
                      onTap: pinNotifier.toggleVisibility,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 34,
                          height: 34,
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
                              size: 18,
                            ),
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
                  isLoading: isLoading,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePinScreen(),
                          ),
                        );
                      },
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
            onPressed: () {
              context.router.push(const SupportFaqRoute());
            },
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
