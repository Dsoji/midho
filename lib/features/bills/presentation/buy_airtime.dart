import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/bills/presentation/widget/custom_phone_textfield.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../transactio_pin/transaction_pin.dart';

@RoutePage()
class BuyAirtimeScreen extends HookConsumerWidget {
  const BuyAirtimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final amountController = useTextEditingController();
    final numberController =
        useTextEditingController(); // Controller for input field
    final List<Map<String, String>> providers = [
      {'name': 'MTN', 'logo': PlaceholderAssets.mtn},
      {'name': 'Glo', 'logo': PlaceholderAssets.glo},
      {'name': 'Airtel', 'logo': PlaceholderAssets.airtel},
      {'name': '9Mobile', 'logo': PlaceholderAssets.etisalat},
    ];
    final selectedProvider =
        useState<Map<String, String>>(providers[1]); // Default: Glo
    final selectedAmount = useState<String?>(null);

    final List<String> amounts = [
      '₦50',
      '₦100',
      '₦200',
      '₦500',
      '₦1000',
      '₦2000',
      '₦3000',
      '₦5000'
    ];

    void updateSelection(String amount) {
      selectedAmount.value = amount;
      amountController.text =
          amount.replaceAll('₦', ''); // Remove currency symbol
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Buy Airtime",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Choose your mobile network to top up your airtime balance",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade400
                      : Colors.white,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProviderPhoneInput(
                    selectedProvider: selectedProvider,
                    controller: numberController,
                    providers: providers,
                  ),
                  const Gap(24),
                  CustomTextField(
                    controller: amountController,
                    hintText: 'Enter amount',
                    isPassword: false,
                    label: 'Amount',
                    keyboardType: TextInputType.number,
                  ),
                  const Gap(16),
                  SizedBox(
                    height: 84,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 items per row
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5, // Adjust for button shape
                      ),
                      itemCount: amounts.length,
                      itemBuilder: (context, index) {
                        final amount = amounts[index];
                        final isSelected = selectedAmount.value == amount;

                        return InkWell(
                          onTap: () => updateSelection(amount),
                          borderRadius: BorderRadius.circular(
                              8), // Ensures ripple effect stays within bounds
                          splashColor: Colors.orange
                              .withOpacity(0.3), // Customize splash color
                          highlightColor: Colors.orange
                              .withOpacity(0.1), // Customize highlight color
                          child: Material(
                            color: theme.brightness == Brightness.dark
                                ? Colors.transparent
                                : const Color(0xFFFAFAFA), // Background color
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.brightness == Brightness.dark
                                      ? Colors
                                          .white54 // Light border for dark mode
                                      : Colors
                                          .transparent, // Subtle border for light mode
                                  width: 1, // Border width
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      4), // Adds spacing for better tap feedback
                              alignment: Alignment.center,
                              child: Text(
                                amount,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(24),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Ensure the phone number is correct. Transactions are non-refundable.',
                  ),
                  const Gap(32),
                  FullButton(
                    text: "Buy Airtime",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionPinScreen(
                                    info:
                                        'This is your 4-digit PIN set during registration or in settings.',
                                  )));
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
}
