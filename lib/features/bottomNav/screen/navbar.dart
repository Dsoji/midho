import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../common/res/app_colors.dart';
import '../app_router.gr.dart';
import 'bottom_nav.dart';

@RoutePage()
class NaviBarScreen extends HookConsumerWidget {
  const NaviBarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        GiftCardRoute(),
        CryptoRoute(),
        TransactionHistoryRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final activeIndex = tabsRouter.activeIndex;

        return WillPopScope(
          onWillPop: () async {
            if (context.router.canPop()) {
              return false; // Prevents app from closing
            }
            return false; // App will close only if no back stack
          },
          child: Scaffold(
            extendBody: true,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: child, // AutoRoute handles this properly
            ),
            bottomNavigationBar: Container(
              height: 85,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade600
                    : Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final icons = [
                    [IconsaxPlusBold.home_2, IconsaxPlusLinear.home_2],
                    [IconsaxPlusBold.gift, IconsaxPlusLinear.gift],
                    [IconsaxPlusBold.coin_1, IconsaxPlusLinear.coin_1],
                    [IconsaxPlusBold.arrow_swap, IconsaxPlusLinear.arrow_swap],
                    [IconsaxPlusBold.user, IconsaxPlusLinear.user],
                  ];
                  final labels = [
                    'Home',
                    'Gift Cards',
                    'Crypto',
                    'Transactions',
                    'Profile'
                  ];

                  return BottomNav(
                    index: index,
                    onTap: () => tabsRouter.setActiveIndex(index), // Change tab
                    icon: activeIndex == index
                        ? icons[index][0]
                        : icons[index][1],
                    label: labels[index],
                    color: activeIndex == index
                        ? AppColors.primaryColor.shade500
                        : AppColors.secondaryColor.shade200,
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
