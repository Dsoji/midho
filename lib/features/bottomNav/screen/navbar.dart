import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../app_router.gr.dart';
import 'bottom_nav.dart';

final logger = Logger();

@RoutePage()
class NaviBarScreen extends HookConsumerWidget {
  const NaviBarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    useEffect(() {
      final box = Hive.box('data');
      box.put('is_auth', false);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'high_importance_channel',
            title: message.notification?.title ?? 'No Title',
            body: message.notification?.body ?? 'No Body',
            notificationLayout: NotificationLayout.Default,
          ),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        logger.d('A new onMessageOpenedApp event was published!');
      });

      return () {};
    }, []);

    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        CryptoRoute(),
        TransactionHistoryRoute(),
        GiftCardRoute(),
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
                    ? AppColors.darkBorder
                    : Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final items = [
                    {
                      'icon': IconsaxPlusBold.home_2,
                      'inactiveIcon': IconsaxPlusLinear.home_2,
                      'label': 'Home',
                    },
                    {
                      'icon': HugeIcons.strokeRoundedBitcoinTransaction,
                      'inactiveIcon': HugeIcons.strokeRoundedBitcoinTransaction,
                      'label': 'Crypto',
                    },
                    {
                      'imagePath': ImageAssets.logo2,
                      'label': 'Transactions',
                    },
                    {
                      'icon': HugeIcons.strokeRoundedGiftCard,
                      'inactiveIcon': HugeIcons.strokeRoundedGiftCard,
                      'label': 'Gift Cards',
                    },
                    {
                      'icon': HugeIcons.strokeRoundedUser,
                      'inactiveIcon': HugeIcons.strokeRoundedUser,
                      'label': 'Profile',
                    },
                  ];

                  return BottomNav(
                    index: index,
                    onTap: () => tabsRouter.setActiveIndex(index),
                    icon: items[index]['icon'] as IconData?,
                    imagePath: items[index]['imagePath'] as String?,
                    label: items[index]['label'] as String,
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
