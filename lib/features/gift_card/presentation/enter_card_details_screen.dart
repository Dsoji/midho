import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import 'gift_card_screen.dart';

@RoutePage()
class EnterCardDetailsScreen extends HookConsumerWidget {
  const EnterCardDetailsScreen({
    super.key,
    required this.giftCard,
  });
  final GiftCard giftCard;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final selectedPlan = useState<String>("USD");
    final selectedCategory = useState<String>("Select Sub-Category");
    void showDataPlanSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
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

    final usdController = useTextEditingController();
    final ngnController = useTextEditingController();

    const conversionRate = 1400.0;

    void convertUSDToNGN(String value) {
      if (value.isEmpty) {
        ngnController.text = "";
        return;
      }
      final usd = double.tryParse(value) ?? 0;
      ngnController.text = (usd * conversionRate).toStringAsFixed(2);
    }

    void convertNGNToUSD(String value) {
      if (value.isEmpty) {
        usdController.text = "";
        return;
      }
      final ngn = double.tryParse(value) ?? 0;
      usdController.text = (ngn / conversionRate).toStringAsFixed(2);
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
        title: "Enter Gift Card Details",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.whiteColor.shade600,
                        width: 0.3,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              giftCard.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              giftCard.desc,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            giftCard.image,
                            height: 32,
                            width: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Currency',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.greyColor.shade700,
                        )),
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
                          CircleAvatar(
                            radius: 14, // Adjust size to match design
                            backgroundImage: AssetImage(
                              selectedPlan.value == "USD"
                                  ? PlaceholderAssets.us
                                  : PlaceholderAssets.ng,
                            ), // Replace with correct asset
                            backgroundColor: Colors
                                .transparent, // Ensure no background color
                          ),
                          const SizedBox(
                              width: 12), // Space between icon and text
                          Expanded(
                            child: Text(
                              selectedPlan.value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black, // Ensures dark text
                              ),
                            ),
                          ),
                          const Icon(
                            IconsaxPlusLinear.arrow_down,
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
                            label: 'E-Code',
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
                            label: 'Physical Card',
                            backgroundColor: Colors.transparent,
                            selectedTextColor:
                                theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            textColor: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Sub-Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.greyColor.shade700,
                        )),
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () {},
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
                          // Space between icon and text
                          Expanded(
                            child: Text(
                              selectedCategory.value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black, // Ensures dark text
                              ),
                            ),
                          ),
                          const Icon(
                            IconsaxPlusLinear.arrow_down,
                            size: 16, // Slightly larger for better visibility
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  SizedBox(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            _buildCurrencyField(
                                "Amount",
                                usdController,
                                "USD",
                                PlaceholderAssets.us,
                                convertUSDToNGN,
                                "\$ ",
                                true,
                                context),
                            const Gap(4),
                            _buildCurrencyField(
                              "You Will Receive",
                              ngnController,
                              "NGN",
                              PlaceholderAssets.ng,
                              convertNGNToUSD,
                              "₦ ",
                              false,
                              context,
                            ),
                          ],
                        ),
                        Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: CircleAvatar(
                              radius: 24, // Adjust size as needed
                              backgroundColor:
                                  Colors.transparent, // Transparent background
                              child: Container(
                                padding: const EdgeInsets.all(
                                    8), // Space around the icon
                                decoration: BoxDecoration(
                                  color: theme.brightness == Brightness.dark
                                      ? AppColors.secondaryColor.shade400
                                      : AppColors.primaryColor.shade50,
                                  shape: BoxShape.circle, // Makes it circular
                                  // Grey border
                                ),
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : AppColors.primaryColor.shade500,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Gap(24),
                  InfoWidget(
                    theme: theme,
                    text:
                        'Rates are subject to change until the trade is submitted.',
                  ),
                  const Gap(16),
                  FullButton(
                    text: "Next",
                    width: double.infinity,
                    height: 48,
                    onPressed: () {
                      context.router.push(
                        CardDetailsProofRoute(img: giftCard.image),
                      );
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

  Widget _buildCurrencyField(
      String label,
      TextEditingController controller,
      String currency,
      String flagPath,
      Function(String) onChanged,
      String currencySign,
      final bool isTop,
      BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade700
            : AppColors.whiteColor.shade500,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              if (isTop == true) ...[
                const Gap(6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade400
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: theme.brightness == Brightness.dark
                        ? Border.all()
                        : Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    ' Minimum ~ \$50',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
                const Spacer(),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Quantity',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ] else ...[
                const Spacer(),
                const Text(
                  'Rate~ ₦750/USD',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixText: currencySign,
                  ),
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontFamily: '',
                  ),
                ),
              ),
              if (isTop == false)
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12), // Adds spacing inside the container
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade500
                        : Colors.white, // Background color
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                    // Light grey border
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(flagPath),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currency,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              else
                const CounterWidget(),
            ],
          ),
        ],
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
        "name": "NGN",
        "logo": PlaceholderAssets.ng,
      },
      {
        "name": "USD",
        "logo": PlaceholderAssets.us,
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
            hintText: 'Search currency',
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

class CounterWidget extends HookWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (count.value > 0) {
                count.value--;
              }
            },
            child: Icon(
              Icons.remove,
              color: count.value > 0 ? Colors.grey : Colors.grey.shade400,
              size: 20,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Text(
              "${count.value}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              count.value++;
            },
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
