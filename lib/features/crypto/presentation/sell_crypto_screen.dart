import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/toast/toast.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../common/widgets/custom_buttons.dart';
import '../../transaction/data/model/response/rates_model/datum.dart';

@RoutePage()
class SellCryptoScreen extends HookConsumerWidget {
  const SellCryptoScreen({
    super.key,
    required this.rates,
  });

  final RateData rates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usdController = useTextEditingController();
    final ngnController = useTextEditingController();

    final double conversionRate = rates.rate ?? 0;

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
                                radius: 24,
                                backgroundColor: Colors.transparent,
                                child: CachedNetworkImage(
                                  imageUrl: rates.icon ?? '',
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.grey[300],
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rates.name ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    rates.symbol ?? '',
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
                            '${rates.rate ?? ''}/1 USD',
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
                                  context,
                                  true),
                              const Gap(4),
                              _buildCurrencyField(
                                  "You Receive",
                                  ngnController,
                                  "NGN",
                                  PlaceholderAssets.ng,
                                  convertNGNToUSD,
                                  "₦ ",
                                  context,
                                  false),
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
                        if (usdController.text.isEmpty) {
                          ToastService().showToast(
                            NotificationType.info,
                            message: 'Input your amount.',
                          );
                          return;
                        }
                        context.router.push(
                          QrCryptoRoute(
                            amount: usdController.text.trim(),
                            crypto: rates,
                          ),
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
    BuildContext context,
    bool? isTop,
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
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              if (isTop == true)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade400
                        : const Color(0xFFFEEEE9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ' Minimum ~ \$${rates.moq}',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : AppColors.primaryColor.shade700,
                    ),
                  ),
                ),
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
                    hintText: currencySign,
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
