import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../../../common/toast/toast.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import '../../transaction/data/model/response/rates_model/datum.dart';
import '../data/model/response/gift_card_model/datum.dart';

@RoutePage()
class EnterCardDetailsScreen extends HookConsumerWidget {
  const EnterCardDetailsScreen({
    super.key,
    required this.giftCard,
  });
  final GiftCardData giftCard;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rates =
        ref.watch(transactionControllerProvider).rates.valueOrNull?.data;
    final selectedRate = useState<RateData?>(null); // To hold selected value
    final selectedPlan = useState<String>("USD");
    final exchangeCurrency = useState<String>("NGN");
    final itemRates = useState<List<RateData>>([]);
    final conversionRate = useState<num?>(null);
    final rateId = useState<String?>(null);
    final availableCurrencies = useState<List<String>>([]);

    final selectedCategory = useState<String>("Select Sub-Category");
    void showDataPlanSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        backgroundColor: theme.brightness == Brightness.dark
            ? AppColors.secondaryColor.shade600
            : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        builder: (context) {
          return ProviderBottomSheet(
            selectedProvider: selectedPlan,
            availableCurrencies: availableCurrencies.value,
          );
        },
      );
    }

    final tabController = useTabController(initialLength: 2);
    final currentTab = useState(0);

// Listen to tab changes and update currentTab
    useEffect(() {
      void listener() {
        currentTab.value = tabController.index;
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, []);

// Update conversion rate when selectedPlan, rates, or current tab changes
    useEffect(() {
      if (rates != null && rates.isNotEmpty) {
        final matchedRates = rates
            .where(
              (rate) =>
                  rate.category == giftCard.id &&
                  rate.baseCurrency?.toUpperCase() ==
                      selectedPlan.value.toUpperCase(),
            )
            .toList();

        itemRates.value = matchedRates; // <-- Add this line

        final matchedRate =
            matchedRates.isNotEmpty ? matchedRates.first : RateData();

        conversionRate.value = currentTab.value == 0
            ? matchedRate.ecodeRate ?? 0.0
            : matchedRate.rate ?? 0.0;

        rateId.value = matchedRate.id;
        exchangeCurrency.value = matchedRate.exchangeCurrency ?? '';
      }

      return null;
    }, [selectedPlan.value, currentTab.value, rates]);

    useEffect(() {
      if (rates != null && rates.isNotEmpty) {
        // Get all rates for this gift card (regardless of currency)
        final allGiftCardRates =
            rates.where((rate) => rate.category == giftCard.id).toList();

        // Extract unique currencies from all rates for this gift card
        final uniqueCurrencies = allGiftCardRates
            .map((rate) => rate.baseCurrency ?? '')
            .where((currency) => currency.isNotEmpty)
            .toSet() // Remove duplicates
            .toList();

        availableCurrencies.value = uniqueCurrencies;
      }

      return null;
    }, [rates, giftCard.id]);

    //
    useEffect(() {
      if (rates != null && rates.isNotEmpty) {
        final matchedRate = rates.firstWhere(
          (rate) =>
              rate.name?.toLowerCase().contains(giftCard.name!.toLowerCase()) ==
                  true &&
              rate.baseCurrency?.toUpperCase() ==
                  selectedPlan.value.toUpperCase(),
          orElse: () => RateData(),
        );

        conversionRate.value = currentTab.value == 0
            ? matchedRate.ecodeRate ?? 0.0
            : matchedRate.rate ?? 0.0;

        rateId.value = matchedRate.id;
        exchangeCurrency.value = matchedRate.exchangeCurrency ?? '';
      }

      return null;
    }, [selectedPlan.value, currentTab.value, rates]);

    final usdController = useTextEditingController();
    final ngnController = useTextEditingController();

    final isEditingUSD = useState(false);
    final isEditingNGN = useState(false);

    void convertUSDToNGN(String value) {
      if (!isEditingUSD.value) return;
      if (value.isEmpty) {
        ngnController.text = "";
        return;
      }
      final usd = double.tryParse(value) ?? 0;
      ngnController.text =
          (usd * (conversionRate.value ?? 0)).toStringAsFixed(2);
    }

    void convertNGNToUSD(String value) {
      if (!isEditingNGN.value) return;
      if (value.isEmpty) {
        usdController.text = "";
        return;
      }
      final ngn = double.tryParse(value) ?? 0;
      usdController.text =
          (ngn / (conversionRate.value ?? 1)).toStringAsFixed(2);
    }

    useEffect(() {
      final usdText = usdController.text.trim();
      final ngnText = ngnController.text.trim();

      if (usdText.isNotEmpty) {
        convertUSDToNGN(usdText);
      } else if (ngnText.isNotEmpty) {
        convertNGNToUSD(ngnText);
      }
      return null;
    }, [conversionRate.value]);

    useEffect(() {
      void listener() {}

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    final FocusNode nodeText1 = FocusNode();
    final FocusNode nodeText2 = FocusNode();

    /// Creates the [KeyboardActionsConfig] to hook up the fields
    /// and their focus nodes to our [FormKeyboardActions].
    KeyboardActionsConfig buildConfig(BuildContext context) {
      return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: AppColors.secondaryColor.shade600,
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
            focusNode: nodeText1,
          ),
          KeyboardActionsItem(focusNode: nodeText2, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
              );
            }
          ]),
        ],
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Enter Gift Card Details",
        showBackButton: true,
        showTitle: true,
        showAction: false,
        centerTitle: true,
      ),
      body: KeyboardActions(
        config: buildConfig(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.darkBorder
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.secondaryColor.shade600
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.brightness == Brightness.dark
                              ? Colors.transparent
                              : AppColors.whiteColor.shade600,
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
                                giftCard.name ?? '',
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
                                'Gift Card',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: giftCard.icon ?? '',
                              height: 28,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/default_icon.png',
                                height: 28,
                                fit: BoxFit.contain,
                              ),
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
                          color: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade600
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.brightness == Brightness.dark
                                ? Colors.transparent
                                : AppColors.whiteColor.shade600,
                            width: 0.3,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Space between icon and text
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
                                ? AppColors.darkBorder
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
                    itemRates.value.isEmpty
                        ? GestureDetector(
                            onTap: () {
                              ToastService().showToast(
                                NotificationType.info,
                                message:
                                    "No sub-category avalaible for the currency selected",
                              );
                            },
                            child: AbsorbPointer(
                              // Prevent interaction with the underlying dropdown
                              child: DropdownButtonFormField2<RateData>(
                                value: null,
                                isExpanded: true,
                                hint: Text(
                                  selectedCategory.value,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                onChanged:
                                    (_) {}, // required but won't be called
                                items: const [], // empty
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 0.3,
                                      color: AppColors.greyColor.shade50,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 0.3,
                                      color: AppColors.greyColor.shade50,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 0.3,
                                      color: AppColors.greyColor.shade50,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 0.3,
                                      color: AppColors.greyColor.shade50,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Icon(
                                    IconsaxPlusLinear.arrow_down,
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    size: 16,
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: theme.brightness == Brightness.dark
                                        ? AppColors.secondaryColor.shade400
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ),
                          )
                        : DropdownButtonFormField2<RateData>(
                            value: selectedRate.value,
                            isExpanded: true,
                            hint: Text(
                              selectedCategory.value,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            onChanged: (value) {
                              selectedRate.value = value;
                            },
                            items: itemRates.value.map((rate) {
                              return DropdownMenuItem<RateData>(
                                value: rate,
                                child: Text(rate.name ?? ''),
                              );
                            }).toList(),
                            selectedItemBuilder: (context) {
                              return itemRates.value.map((rate) {
                                return Text(rate.name ?? '');
                              }).toList();
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 0.3,
                                  color: AppColors.greyColor.shade50,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 0.3,
                                  color: AppColors.greyColor.shade50,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 0.3,
                                  color: AppColors.greyColor.shade50,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 0.3,
                                  color: AppColors.greyColor.shade50,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                            ),
                            iconStyleData: IconStyleData(
                              icon: Icon(
                                IconsaxPlusLinear.arrow_down,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                size: 16,
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: theme.brightness == Brightness.dark
                                    ? AppColors.secondaryColor.shade400
                                    : Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              elevation: 3,
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
                                selectedPlan.value,
                                true,
                                context,
                                selectedPlan.value == "USD" ? "\$" : "₦",
                                selectedRate.value?.moq?.toString() ?? 'N/A',
                                conversionRate.value?.toString() ?? 'N/A',
                                nodeText1,
                                isEditingUSD,
                                isEditingNGN,
                              ),
                              const Gap(4),
                              _buildCurrencyField(
                                "You Will Receive",
                                ngnController,
                                "NGN",
                                PlaceholderAssets.ng,
                                convertNGNToUSD,
                                exchangeCurrency.value,
                                false,
                                context,
                                selectedPlan.value,
                                selectedRate.value?.moq?.toString() ?? 'N/A',
                                conversionRate.value?.toString() ?? 'N/A',
                                nodeText2,
                                isEditingUSD,
                                isEditingNGN,
                              ),
                            ],
                          ),
                          Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: CircleAvatar(
                                radius: 22, // Adjust size as needed
                                backgroundColor: Colors
                                    .transparent, // Transparent background
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      8), // Space around the icon
                                  decoration: BoxDecoration(
                                    color: theme.brightness == Brightness.dark
                                        ? AppColors.primaryColor.shade500
                                        : const Color(0xFFE6ECFC),
                                    shape: BoxShape.circle, // Makes it circular
                                    // Grey border
                                  ),
                                  child: Icon(
                                    Icons.arrow_downward,
                                    size: 12,
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
                      isLoading: ref
                          .watch(authenticationControllerProvider)
                          .imageUpload
                          .isLoading,
                      text: "Next",
                      width: double.infinity,
                      height: 48,
                      onPressed: () {
                        if (selectedRate.value == null) {
                          ToastService().showToast(
                            NotificationType.info,
                            message: 'Select a sub-category',
                          );

                          return;
                        }
                        if (usdController.text.isEmpty ||
                            (num.tryParse(usdController.text) ?? 0) <
                                (selectedRate.value!.moq ?? 0)) {
                          ToastService().showToast(
                            NotificationType.info,
                            message:
                                'Input your amount greater than or equal to ${selectedRate.value?.moq ?? 0}',
                          );
                          return;
                        }

                        context.router.push(
                          CardDetailsProofRoute(
                            giftCard: giftCard,
                            amount:
                                int.tryParse(usdController.text.trim()) ?? 0,
                            rates: selectedRate.value?.id,
                            isCode: tabController.index == 0 ? true : false,
                            currency: selectedPlan.value,
                          ),
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
    BuildContext context,
    String sign,
    String rate,
    String conversionRate,
    FocusNode focusNode,
    ValueNotifier<bool> isEditingUSD,
    ValueNotifier<bool> isEditingNGN,
  ) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              if (isTop == true) ...[
                const Gap(6),
                Container(
                  padding: const EdgeInsets.all(3),
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
                    ' Minimum ~ \$$rate ',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ] else ...[
                const Spacer(),
                Text(
                  '₦$conversionRate/$sign',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: ''),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixText: isTop == true ? currencySign : '',
                    hintText: '0',
                    prefixStyle: const TextStyle(fontFamily: '', fontSize: 10),
                  ),
                  onTap: () {
                    if (isTop == true) {
                      isEditingUSD.value = true;
                      isEditingNGN.value = false;
                    } else {
                      isEditingUSD.value = false;
                      isEditingNGN.value = true;
                    }
                  },
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontFamily: '',
                  ),
                ),
              ),
              if (isTop == false)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade500
                        : Colors.white, // Background color
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                    // Light grey border
                  ),
                  child: Row(
                    children: [
                      Text(
                        currencySign,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}

class ProviderBottomSheet extends HookConsumerWidget {
  final ValueNotifier<String> selectedProvider;
  final List<String> availableCurrencies;
  const ProviderBottomSheet({
    super.key,
    required this.selectedProvider,
    required this.availableCurrencies,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final currencies = availableCurrencies ?? [];

    final filteredCurrencies = useState<List<dynamic>>(currencies);

    // Listen to search changes and filter the list
    useEffect(() {
      void listener() {
        final query = searchController.text.toLowerCase();
        filteredCurrencies.value = currencies
            .where((currency) => currency.toLowerCase().contains(query))
            .toList();
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [currencies]);
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
            hintText: 'Search currency',
            isPassword: false,
            suffixIcon: const Icon(Icons.search),
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade700
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: filteredCurrencies.value.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No match found."),
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredCurrencies.value.length,
                      separatorBuilder: (context, index) => Divider(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.secondaryColor.shade400
                              : Colors.grey.shade100),
                      itemBuilder: (context, index) {
                        final provider = filteredCurrencies.value[index];
                        return ListTile(
                          title: Text(
                            provider,
                            style: const TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            selectedProvider.value = provider;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends HookWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(1); // State variable
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent, // Keep original background
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.darkBorder
              : Colors.white,
          border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                if (count.value > 1) {
                  count.value = count.value - 1;
                }
              },
              child: Icon(
                Icons.remove,
                color: count.value > 1
                    ? Colors.grey.shade800
                    : Colors.grey.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 4), // Replace Gap(4) with SizedBox
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: theme.brightness == Brightness.dark
                        ? Colors.black
                        : Colors.grey.shade300,
                  ),
                ),
              ),
              child: Text(
                "${count.value}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                count.value++;
              },
              child: const Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
