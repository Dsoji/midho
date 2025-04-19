import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';

import '../../../common/widgets/custom_app_bar.dart';
import 'widget/crypto_card_widget.dart';

@RoutePage()
class CryptoScreen extends HookConsumerWidget {
  const CryptoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptos =
        ref.watch(transactionControllerProvider).rates.valueOrNull?.data;

    final cryptoRates =
        cryptos!.where((rate) => rate.type == "CRYPTO").toList();
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) {
        if (!didPop) {
          final tabsRouter = AutoTabsRouter.of(
            context,
          );

          tabsRouter.setActiveIndex(0);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Select Crypto To Sell",
          showBackButton: false,
          showTitle: true,
          showAction: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(transactionControllerProvider.notifier).getRates();
            return Future.delayed(const Duration(seconds: 1));
          },
          child: cryptoRates.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cryptoRates.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final data = cryptoRates[index];
                    return CryptoCard(
                      rates: data,
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(52),
                      const Icon(Icons.info_outline,
                          color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        "No crypto available.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
