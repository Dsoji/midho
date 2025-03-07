import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/bills/presentation/widget/custom_phone_textfield.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../transactio_pin/transaction_pin.dart';

@RoutePage()
class BuyDataScreen extends HookConsumerWidget {
  const BuyDataScreen({super.key});

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
    final selectedPlan = useState<String>("6 GB for 30 Days  NGN 10,000.00");

    void showDataPlanSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFFF7F7F7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return DataPlanBottomSheet(
            selectedPlan: selectedPlan,
          );
        },
      );
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
              "Choose your mobile network to purchase a data bundle",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Data Plan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyColor.shade300,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Wallet Balance: ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor.shade300,
                          ),
                          children: [
                            TextSpan(
                              text: "NGN 10,000.00",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyColor.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () => showDataPlanSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greyColor.shade50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedPlan.value,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(32),
                  FullButton(
                    text: "Confirm",
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

class DataPlanBottomSheet extends HookConsumerWidget {
  final ValueNotifier<String> selectedPlan;
  const DataPlanBottomSheet({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> plans = [
      "6 GB for 30 Days  NGN 10,000.00",
      "3 GB for 14 Days  NGN 5,000.00",
      "1.5 GB for 7 Days  NGN 2,500.00",
      "500 MB for 1 Day  NGN 500.00",
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
            "Select Data Plan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: searchController,
            hintText: 'Search Data Plan',
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
