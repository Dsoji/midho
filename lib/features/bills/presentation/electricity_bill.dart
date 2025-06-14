import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/toast/toast.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../transaction/data/controller/transaction_controller.dart';
import '../../transaction_pin/transaction_pin.dart';

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

    final electricityPlans =
        ref.watch(transactionControllerProvider).electricityPlans;
    // Default: Glo
    final selectedPlan = useState<
        ({
          String name,
          String logo,
          String max,
          String min,
          String id
        })>(electricityPlans.when(
      data: (plans) => plans.isNotEmpty
          ? (
              name: plans.first.name ?? '',
              logo: plans.first.logo ?? '',
              max: plans.first.max.toString(),
              min: plans.first.min.toString(),
              id: plans.first.id ?? ''
            )
          : (name: '', logo: '', max: '', min: '', id: ''),
      loading: () => (name: '', logo: '', max: '', min: '', id: ''),
      error: (_, __) => (name: '', logo: '', max: '', min: '', id: ''),
    ));

    void showDataPlanSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade700
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
      void listener() {}

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(transactionControllerProvider.notifier).getElectricalPlans();
      });
      return null;
    }, []);

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
                    ? AppColors.darkBorder
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? AppColors.secondaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        "Select Your Electricity Provider".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.5,
                          letterSpacing: 2.04, // 17% of 12
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF8B8EAF),
                        ),
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
                          color: theme.brightness == Brightness.dark
                              ? Colors.transparent
                              : AppColors.greyColor.shade50,
                          width: 0.35,
                        ), // Slightly darker border
                        color: theme.brightness == Brightness.dark
                            ? AppColors.secondaryColor
                            : Colors.white, // Ensures white background
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14, // Adjust size to match design
                            backgroundImage: NetworkImage(
                              selectedPlan.value.logo,
                            ), // Replace with correct asset
                            backgroundColor: Colors
                                .transparent, // Ensure no background color
                          ),
                          const SizedBox(
                              width: 12), // Space between icon and text
                          Expanded(
                            child: Text(
                              selectedPlan.value.name,
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
                              text:
                                  " NGN ${selectedPlan.value.min} - NGN ${selectedPlan.value.max}",
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
                      if (amountController.text.trim().isEmpty) {
                        ToastService().showToast(
                          NotificationType.error,
                          message: 'Please enter an amount',
                        );
                        return;
                      }

                      if (meterNoController.text.trim().isEmpty) {
                        ToastService().showToast(
                          NotificationType.error,
                          message: 'Please enter a meter number',
                        );
                        return;
                      }

                      if (int.parse(amountController.text.trim()) <
                              int.parse(selectedPlan.value.min) ||
                          int.parse(amountController.text.trim()) >
                              int.parse(selectedPlan.value.max)) {
                        ToastService().showToast(
                          NotificationType.error,
                          message:
                              'Please enter an amount greater than ${selectedPlan.value.min} and less than ${selectedPlan.value.max}',
                        );
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionPinScreen(
                                    assetId: selectedPlan.value.id,
                                    amount: amountController.text,
                                    accountNumber: meterNoController.text,
                                    selectedType: 'Electricity',
                                    info:
                                        'This is your 4-digit PIN set during registration or in settings.',
                                  ))).then((value) {
                        meterNoController.clear();
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

class ProviderBottomSheet extends HookConsumerWidget {
  final ValueNotifier<
          ({String name, String logo, String max, String min, String id})>
      selectedProvider;
  const ProviderBottomSheet({super.key, required this.selectedProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final electricityPlans =
        ref.watch(transactionControllerProvider).electricityPlans;

    final searchController = useTextEditingController();
    final searchQuery = useState('');
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
            onChanged: (value) => searchQuery.value = value,
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
            child: electricityPlans.when(
              data: (plans) {
                final filteredPlans = plans
                    .where((provider) =>
                        provider.name?.toLowerCase().contains(
                              searchQuery.value.toLowerCase(),
                            ) ??
                        false)
                    .toList();

                return ListView.separated(
                  itemCount: filteredPlans.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade100),
                  itemBuilder: (context, index) {
                    final provider = filteredPlans[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(provider.logo ?? ''),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        provider.name ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        selectedProvider.value = (
                          logo: provider.logo ?? '',
                          name: provider.name ?? '',
                          max: provider.max.toString(),
                          min: provider.min.toString(),
                          id: provider.id ?? '',
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              loading: () => electricityPlans.maybeWhen(
                data: (plans) {
                  final filteredPlans = plans
                      .where((provider) =>
                          provider.name?.toLowerCase().contains(
                                searchQuery.value.toLowerCase(),
                              ) ??
                          false)
                      .toList();

                  return ListView.separated(
                    itemCount: filteredPlans.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      final provider = filteredPlans[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(provider.logo ?? ''),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(
                          provider.name ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          selectedProvider.value = (
                            logo: provider.logo ?? '',
                            name: provider.name ?? '',
                            max: provider.max.toString(),
                            min: provider.min.toString(),
                            id: provider.id ?? '',
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                orElse: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          const Gap(150),
        ],
      ),
    );
  }
}
