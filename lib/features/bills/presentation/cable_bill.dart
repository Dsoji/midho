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
import '../../transaction/data/controller/transaction_controller.dart';
import '../../transaction_pin/transaction_pin.dart';

@RoutePage()
class CableBillScreen extends HookConsumerWidget {
  const CableBillScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Controller for input field
    final meterNoController =
        useTextEditingController(); // Controller for meter number input field
// Controller for amount input field

    final selectedPlan = useState<Map<String, String>>({
      "name": "Dstv",
      "logo": PlaceholderAssets.dstv, // Default logo
    });
    final subPlan = useState<String>("DSTV Compact - ₦8,000/Month");

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

    void showSubPlanSheet(BuildContext context) {
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
          return SubPlanBottomSheet(
            selectedPlan: subPlan,
          );
        },
      );
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(transactionControllerProvider.notifier).getCableTvPlans();
      });
      return null;
    }, []);

    final cableTvPlans = ref.watch(transactionControllerProvider).cableTvPlans;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Pay Cable TV Subscription",
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
              "Choose your Cable TV provider to renew your subscription.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.all(12),
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
                        "Cable TV providers".toUpperCase(),
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
                            radius: 14,
                            backgroundImage: selectedPlan.value["logo"]
                                        ?.startsWith('http') ??
                                    false
                                ? NetworkImage(selectedPlan.value["logo"]!)
                                : AssetImage(selectedPlan.value["logo"]!)
                                    as ImageProvider,
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              selectedPlan.value["name"] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  CustomTextField(
                    controller: meterNoController,
                    label: "Smart Card Numberr",
                    keyboardType: TextInputType.number,
                    hintText: 'Smart Card Number',
                  ),
                  const Gap(24),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Your smart card number can be found on your decoder or subscription card.',
                  ),
                  const Gap(24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Subscription Package",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.greyColor.shade500,
                      ),
                    ),
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () => showSubPlanSheet(context),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subPlan.value,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: ''),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
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
                                    selectedType: 'DSTV',
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
            const Gap(150)
          ],
        ),
      ),
    );
  }
}

class ProviderBottomSheet extends HookConsumerWidget {
  final ValueNotifier<Map<String, String>> selectedProvider;
  const ProviderBottomSheet({super.key, required this.selectedProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cableTvPlans = ref.watch(transactionControllerProvider).cableTvPlans;
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
            child: cableTvPlans.when(
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
                        selectedProvider.value = {
                          "name": provider.name ?? '',
                          "logo": provider.logo ?? '',
                        };
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
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
              color: theme.brightness == Brightness.dark
                  ? AppColors.secondaryColor.shade500
                  : const Color(0xFFD9D9D9),
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
            fillColor: theme.brightness == Brightness.dark
                ? Colors.transparent
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
                      style: const TextStyle(fontSize: 16, fontFamily: ''),
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
