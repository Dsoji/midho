import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/bills/data/model/response/airtime_electric_model/airtime_electric_model.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../transaction/data/controller/transaction_controller.dart';
import '../../transaction_pin/transaction_pin.dart';

@RoutePage()
class BuyAirtimeScreen extends HookConsumerWidget {
  const BuyAirtimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final amountController = useTextEditingController();
    final numberController = useTextEditingController();
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
      amountController.text = amount.replaceAll('₦', '');
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(transactionControllerProvider.notifier).getAirtimePlans();
      });
      return null;
    }, []);

    final airtimePlans = ref.watch(transactionControllerProvider).airtimePlans;

    // Initialize selectedProvider with a default value
    final selectedProvider =
        useState<({String name, String logo, String id})>(airtimePlans.when(
      data: (plans) => plans.isNotEmpty
          ? (
              name: plans.first.name ?? '',
              logo: plans.first.logo ?? '',
              id: plans.first.id ?? ''
            )
          : (name: '', logo: '', id: ''),
      loading: () => (name: '', logo: '', id: ''),
      error: (_, __) => (name: '', logo: '', id: ''),
    ));

    // Update the providers list handling
    final List<AirtimeElectricModel> providers = airtimePlans.when(
      data: (data) {
        // Convert the data to the required format
        return data
            .map((e) => AirtimeElectricModel(
                  name: e.name ?? "Unknown",
                  logo: e.logo ?? "assets/default_provider.png",
                  id: e.id ?? "",
                ))
            .toList();
      },
      error: (error, stackTrace) => [],
      loading: () => [],
    );

    // // Set the initial provider if available
    // useEffect(() {
    //   if (providers.isNotEmpty) {
    //     selectedProvider.value = {
    //       "name": providers[0].name ?? "",
    //       "logo": providers[0].logo ?? "",
    //       "assetId": providers[0].id ?? ""
    //     };
    //   }
    //   return null;
    // }, [providers]);

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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
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
                      Text("Amount",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.greyColor.shade700,
                          )),
                      Text(
                        "Limit: NGN 500.00 - NGN 10,000.00",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.greyColor.shade700,
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: amountController,
                    hintText: 'Enter amount',
                    isPassword: false,
                    keyboardType: TextInputType.number,
                    fillColor: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade700
                        : AppColors.whiteColor.shade500,
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
                                color: theme.brightness == Brightness.dark
                                    ? AppColors.secondaryColor
                                        .shade700 // Light border for dark mode
                                    : AppColors.whiteColor.shade300,
                                border: Border.all(
                                  color: theme.brightness == Brightness.dark
                                      ? AppColors.secondaryColor
                                          .shade700 // Light border for dark mode
                                      : AppColors.whiteColor
                                          .shade300, // Subtle border for light mode
                                  width: 1, // Border width
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.center,
                              child: Text(
                                amount,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: ''),
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
                      logger.d(selectedProvider.value);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionPinScreen(
                                    selectedType: 'Airtime',
                                    info:
                                        'This is your 4-digit PIN set during registration or in settings.',
                                    assetId: selectedProvider.value.id,
                                    amount: '10',
                                    accountNumber: numberController.text,
                                  ))).then((value) {
                        numberController.clear();
                        amountController.clear();
                      });
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

class ProviderPhoneInput extends HookConsumerWidget {
  final ValueNotifier<({String name, String logo, String id})> selectedProvider;
  final TextEditingController controller;
  final List<AirtimeElectricModel> providers;

  const ProviderPhoneInput({
    super.key,
    required this.selectedProvider,
    required this.controller,
    required this.providers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final airtimePlans = ref.watch(transactionControllerProvider).airtimePlans;
    void showProviderMenu(BuildContext context) {
      final theme = Theme.of(context);
      showModalBottomSheet(
        context: context,
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade700
            : const Color(0xFFF7F7F7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
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
                airtimePlans.when(
                  data: (plans) => ListView.separated(
                    shrinkWrap: true,
                    itemCount: plans.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      final provider = plans[index];
                      final isSelected =
                          provider.name == selectedProvider.value.name;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(provider.logo ?? ''),
                          backgroundColor: Colors.transparent,
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(
                          provider.name ?? 'Unknown',
                          style: TextStyle(
                            color: isSelected ? Colors.orange : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.orange)
                            : null,
                        onTap: () {
                          selectedProvider.value = (
                            name: provider.name ?? '',
                            logo: provider.logo ?? '',
                            id: provider.id ?? '',
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => showProviderMenu(context),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(selectedProvider.value.logo),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down,
                    size: 18, color: Colors.grey),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter phone number",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
          const Gap(8),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () => controller.clear(),
              child: const Icon(Icons.clear, size: 18, color: Colors.black),
            ),
        ],
      ),
    );
  }
}
