import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../transactio_pin/transaction_pin.dart';

@RoutePage()
class BettingScreen extends HookConsumerWidget {
  const BettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Controller for input field
    final meterNoController =
        useTextEditingController(); // Controller for meter number input field
    final amountController =
        useTextEditingController(); // Controller for amount input field

    final selectedPlan = useState<String>("Sporty Bet");
    final subPlan = useState<String>("DSTV Compact - ₦8,000/Month");

    void showDataPlanSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFFF7F7F7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return ProviderBottomSheet(
            selectedProvider: selectedPlan,
          );
        },
      );
    }

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
        title: "Fund Betting Account",
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
              "Select your betting platform and enter the amount to deposit",
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Betting Platform",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyColor.shade500,
                      ),
                    ),
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () => showDataPlanSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.greyColor.shade50,
                        ), // Slightly darker border
                        color: Colors.white, // Ensures white background
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 14, // Adjust size to match design
                            backgroundImage: AssetImage(
                              PlaceholderAssets.sporty,
                            ), // Replace with correct asset
                            backgroundColor: Colors
                                .transparent, // Ensure no background color
                          ),
                          const SizedBox(
                              width: 12), // Space between icon and text
                          Expanded(
                            child: Text(
                              selectedPlan.value,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black, // Ensures dark text
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16, // Slightly larger for better visibility
                            color: Colors.black54, // Softer black tone
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  CustomTextField(
                    controller: meterNoController,
                    label: "Betting ID",
                    keyboardType: TextInputType.number,
                    hintText: 'Enter Betting ID / Username',
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
                            color: const Color(0xFFFAFAFA), // Background color
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      8), // Adds spacing for better tap feedback
                              alignment: Alignment.center,
                              child: Text(
                                amount,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
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
                        'Ensure the betting ID or username is correct. Transactions are non-refundable.',
                  ),
                  const Gap(32),
                  FullButton(
                    text: "Next",
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

class ProviderBottomSheet extends HookConsumerWidget {
  final ValueNotifier<String> selectedProvider;
  const ProviderBottomSheet({super.key, required this.selectedProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, String>> providers = [
      {
        "name": "Sporty Bet",
        "logo": PlaceholderAssets.sporty,
      },
      {
        "name": "Bet9ja",
        "logo": PlaceholderAssets.sporty,
      },
      {
        "name": "Naija Bet",
        "logo": PlaceholderAssets.sporty,
      },
    ];
    final searchController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Select Provider",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: searchController,
            hintText: 'Search Provider',
            isPassword: false,
            suffixIcon: const Icon(Icons.search),
            fillColor: Colors.white,
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.separated(
                  itemCount: providers.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade100),
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(provider["logo"]!),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        provider["name"]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        selectedProvider.value = provider["name"]!;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(150),
        ],
      ),
    );
  }
}

class SubPlanBottomSheet extends HookConsumerWidget {
  final ValueNotifier<String> selectedPlan;
  const SubPlanBottomSheet({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> plans = [
      "DSTV Compact - ₦8,000/Month",
      "DSTV Flex - ₦5,000/Month",
      "DSTV Original - ₦8,000/Month",
      "DSTV Yanga - ₦3,500/Month",
    ];
    final searchController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Select Subscription Plan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: searchController,
            hintText: 'Search subscription Plan',
            isPassword: false,
            suffixIcon: const Icon(Icons.search),
            fillColor: Colors.white,
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ListView.separated(
              itemCount: plans.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final plan = plans[index];
                return ListTile(
                  title: Center(
                    child: Text(
                      plan,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center, // Ensures text is centered
                    ),
                  ),
                  onTap: () {
                    selectedPlan.value = plan;
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const Gap(150),
        ],
      ),
    );
  }
}
