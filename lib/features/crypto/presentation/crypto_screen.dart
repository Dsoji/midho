import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../../../common/widgets/custom_app_bar.dart';
import 'widget/crypto_card_widget.dart';

@RoutePage()
class CryptoScreen extends HookConsumerWidget {
  const CryptoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, String>> cryptoData = [
      {
        'name': 'Bitcoin',
        'symbol': 'BTC',
        'rate': '1640/1USD',
        'img': PlaceholderAssets.btc
      },
      {
        'name': 'Ethereum',
        'symbol': 'ETH',
        'rate': '3200/1USD',
        'img': PlaceholderAssets.eth
      },
      {
        'name': 'Litecoin',
        'symbol': 'LTC',
        'rate': '180/1USD',
        'img': PlaceholderAssets.ltc
      },
    ];
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
        body: Column(
          children: [
            const Gap(16),
            Expanded(
              child: ListView.separated(
                itemCount: cryptoData.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.transparent,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final data = cryptoData[index];
                  return CryptoCard(
                    img: data['img']!,
                    name: data['name']!,
                    symbol: data['symbol']!,
                    rate: data['rate']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
