import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';

@RoutePage()
class SellCryptoScreen extends HookConsumerWidget {
  const SellCryptoScreen({
    super.key,
    required this.name,
    required this.symbol,
    required this.rate,
    required this.img,
  });
  final String name;
  final String symbol;
  final String rate;
  final String img;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final theme = Theme.of(context);
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Enter Amount To Sell",
          showBackButton: true,
          showTitle: true,
          showAction: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade500
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.secondaryColor.shade700
                            : AppColors.whiteColor.shade500,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.orange.shade100,
                                backgroundImage: AssetImage(img),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    symbol,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.brightness == Brightness.dark
                                          ? AppColors.secondaryColor.shade200
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            rate,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              _buildCurrencyField(
                                  "You Pay",
                                  usdController,
                                  "USD",
                                  PlaceholderAssets.us,
                                  convertUSDToNGN,
                                  "\$ ",
                                  context),
                              const Gap(4),
                              _buildCurrencyField(
                                  "You Receive",
                                  ngnController,
                                  "NGN",
                                  PlaceholderAssets.ng,
                                  convertNGNToUSD,
                                  "₦ ",
                                  context),
                            ],
                          ),
                          Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: CircleAvatar(
                                radius: 24, // Adjust size as needed
                                backgroundColor: Colors
                                    .transparent, // Transparent background
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
                    const SizedBox(height: 16),
                    InfoWidget(
                      theme: theme,
                      text:
                          "Enter the exact amount of USD you'd like to sell. Ensure it matches the amount you will send later.",
                    ),
                    const SizedBox(height: 16),
                    FullButton(
                      text: "Next",
                      width: double.infinity,
                      height: 48,
                      onPressed: () {
                        context.router.push(
                          const QrCryptoRoute(),
                        );
                      },
                      textColor: Colors.white,
                      color: AppColors.primaryColor.shade500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCurrencyField(
      String label,
      TextEditingController controller,
      String currency,
      String flagPath,
      Function(String) onChanged,
      String currencySign,
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
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            ],
          ),
        ],
      ),
    );
  }
}
