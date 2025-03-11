import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
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
class ElectricityBillScreen extends HookConsumerWidget {
  const ElectricityBillScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Controller for input field
    final meterNoController =
        useTextEditingController(); // Controller for meter number input field
    final amountController =
        useTextEditingController(); // Controller for amount input field
    final List<Map<String, String>> providers = [
      {'name': 'MTN', 'logo': PlaceholderAssets.mtn},
      {'name': 'Glo', 'logo': PlaceholderAssets.glo},
      {'name': 'Airtel', 'logo': PlaceholderAssets.airtel},
      {'name': '9Mobile', 'logo': PlaceholderAssets.etisalat},
    ];
    final selectedProvider =
        useState<Map<String, String>>(providers[1]); // Default: Glo
    final selectedPlan = useState<String>("Ikeja Electric");

    void showDataPlanSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade600
            : const Color(0xFFF7F7F7),
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

    final tabController = useTabController(initialLength: 2);

    useEffect(() {
      void listener() {
        print(
            "Selected Tab: ${tabController.index == 0 ? 'Prepaid' : 'Postpaid'}");
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Pay Electricity Bill",
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
              "Choose your electricity provider to proceed with bill payment.",
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
                      "Provider",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade500,
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
                          width: 0.3,
                        ), // Slightly darker border
                        color: theme.brightness == Brightness.dark
                            ? Colors.transparent
                            : Colors.white, // Ensures white background
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 14, // Adjust size to match design
                            backgroundImage: AssetImage(
                              PlaceholderAssets.ie,
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
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16, // Slightly larger for better visibility
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor.shade700
                          : const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SegmentedTabControl(
                        tabPadding: const EdgeInsets.all(0),
                        controller: tabController,
                        indicatorPadding: const EdgeInsets.all(0),
                        barDecoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade500
                              : AppColors.greyColor.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        indicatorDecoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade500
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tabs: [
                          SegmentTab(
                            label: 'Prepaid',
                            backgroundColor: Colors.transparent,
                            selectedTextColor:
                                theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            textColor: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                          ),
                          SegmentTab(
                              label: 'Postpaid',
                              backgroundColor: Colors.transparent,
                              selectedTextColor:
                                  theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                              textColor: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black54),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  CustomTextField(
                    controller: meterNoController,
                    label: "Meter Number",
                    keyboardType: TextInputType.number,
                    hintText: 'Meter Number',
                  ),
                  const Gap(24),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Your meter number is usually located on your bill or meter device.',
                  ),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Enter Amount",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.greyColor.shade300,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Limit: ",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.greyColor.shade300,
                          ),
                          children: [
                            TextSpan(
                              text: " NGN 500.00 - NGN 10,000.00",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.greyColor.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  CustomTextField(
                    controller: amountController,
                    hintText: 'Enter amount',
                    isPassword: false,
                    keyboardType: TextInputType.number,
                  ),
                  const Gap(32),
                  FullButton(
                    text: "Continue",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionPinScreen(
                                    selectedType: 'Electricity',
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
            const Gap(150),
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
        "name": "Ikeja Electric",
        "logo": PlaceholderAssets.ie,
      },
      {
        "name": "Eko Electric",
        "logo": PlaceholderAssets.ie,
      },
      {
        "name": "Abuja Electric",
        "logo": PlaceholderAssets.ie,
      },
      {
        "name": "Kano Electric",
        "logo": PlaceholderAssets.ie,
      },
    ];
    final searchController = useTextEditingController();
    final theme = Theme.of(context);

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
            fillColor: theme.brightness == Brightness.dark
                ? AppColors.secondaryColor.shade500
                : Colors.white,
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade500
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ListView.separated(
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
          ),
          const Gap(150),
        ],
      ),
    );
  }
}
