import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/widgets/custom_app_bar.dart';
import 'widget/crypto_card_widget.dart';

@RoutePage()
class CryptoScreen extends HookConsumerWidget {
  const CryptoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider).rates;
    final theme = Theme.of(context);

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
        appBar: CustomAppBar(
          title: "Select Crypto To Sell",
          showBackButton: false,
          showTitle: true,
          showAction: false,
          bckgrndColor: theme.brightness == Brightness.dark
              ? const Color(0xFF151515)
              : AppColors.whiteColor.shade100,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.read(transactionControllerProvider.notifier).getRates();
            return Future.delayed(const Duration(seconds: 1));
          },
          child: state.when(
            loading: () => state.maybeWhen(
              data: (rates) {
                final cryptoRates =
                    rates.data!.where((rate) => rate.type == "CRYPTO").toList();
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cryptoRates.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final data = cryptoRates[index];
                    return CryptoCard(rates: data);
                  },
                );
              },
              orElse: () {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => const CryptoCardShimmer(),
                );
              },
            ),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_outlined,
                      size: 48, color: Colors.red),
                  const Gap(12),
                  Text('Failed to load crypto rates.',
                      style: TextStyle(color: Colors.red[600], fontSize: 16)),
                  const Gap(6),
                  Text(error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            data: (rates) {
              final cryptoRates =
                  rates.data!.where((rate) => rate.type == "CRYPTO").toList();
              if (cryptoRates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(52),
                      const Icon(Icons.info_outline,
                          color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        "No crypto available.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cryptoRates.length,
                separatorBuilder: (context, index) => const Gap(8),
                itemBuilder: (context, index) {
                  final data = cryptoRates[index];
                  return CryptoCard(rates: data);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class CryptoCardShimmer extends StatelessWidget {
  const CryptoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryColor.shade50,
      highlightColor: AppColors.primaryColor.shade100,
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
