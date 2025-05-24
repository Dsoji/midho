import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/bills/data/model/response/data_tv_model/data_tv_model.dart';
import 'package:mdiho/features/bills/presentation/widget/custom_phone_textfield.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../transaction/data/controller/transaction_controller.dart';
import '../../transaction_pin/transaction_pin.dart';
import '../data/model/response/data_tv_model/product.dart';

@RoutePage()
class BuyDataScreen extends HookConsumerWidget {
  const BuyDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final numberController =
        useTextEditingController(); // Controller for input field
    // Default: Glo
    final selectedPlan = useState<String>("Select data plan");

    final dataPlans = ref.watch(transactionControllerProvider).dataPlans;

    final selectedProvider =
        useState<({String name, String logo, List<Product>? products})>(
            dataPlans.when(
      data: (plans) => plans.isNotEmpty
          ? (
              name: plans.first.name ?? '',
              logo: plans.first.logo ?? '',
              products: plans.first.products ?? [],
            )
          : (
              name: '',
              logo: '',
              products: [],
            ),
      loading: () => (
        name: '',
        logo: '',
        products: [],
      ),
      error: (_, __) => (
        name: '',
        logo: '',
        products: [],
      ),
    ));

    // final selectedPlan = useState<Product>(dataPlans.when(
    //   data: (plans) => plans.isNotEmpty ? plans.first.products?.first : null,
    //   loading: () => null,
    //   error: (_, __) => null,
    // ));

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
          return DataPlanBottomSheet(
            products: selectedProvider.value.products ?? [],
            // selectedPlan: selectedProvider,
          );
        },
      );
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(transactionControllerProvider.notifier).getDataPlans();
      });
      return null;
    }, []);

    final List<DataTvModel> providers = dataPlans.when(
      data: (data) {
        return data
            .map((e) => DataTvModel(
                  name: e.name ?? "",
                  logo: e.logo ?? "",
                  products: e.products ?? [],
                ))
            .toList();
      },
      error: (error, stackTrace) => [],
      loading: () => [],
    );
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Buy Data",
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
                  DataProviderPhoneInput(
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
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.greyColor.shade300,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Wallet Balance: ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : AppColors.greyColor.shade300,
                          ),
                          children: [
                            TextSpan(
                              text: "NGN 10,000.00",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.greyColor.shade500,
                                fontFamily: '',
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
                                    selectedType: 'Data',
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
  // final ValueNotifier<({Product products})> selectedPlan;
  final List<Product> products;
  const DataPlanBottomSheet({
    super.key,
    // required this.selectedPlan,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final theme = Theme.of(context);

    return SingleChildScrollView(
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
              itemCount: products.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Center(
                    child: Text(
                      "${product.name} - NGN ${product.amount}",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const Gap(130),
        ],
      ),
    );
  }
}
