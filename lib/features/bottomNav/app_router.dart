import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mdiho/features/crypto/crypto_route.dart';
import 'package:mdiho/features/gift_card/gift_card_route.dart';
import 'package:mdiho/features/profile/profile_route.dart';
import 'package:mdiho/features/transaction/transaction_route.dart';

import '../home/home_routes.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: OnboardingRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: MdihoShellRoute.page,
          children: [
            AutoRoute(path: '', page: LoginRoute.page),
            AutoRoute(page: RegistrationRoute.page),
            AutoRoute(page: ConfirmPinRoute.page),
            AutoRoute(page: ForgotPasswordRoute.page),

            // AutoRoute(page: InterestRoute.page),
          ],
        ),
        AutoRoute(
          page: NaviBarRoute.page,
          children: [
            homeRoutes,
            giftCardRoutes,
            cryptoRoutes,
            transactionRoutes,
            profileRoutes,
          ],
        ),
        profileRoutes,
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}

class $AppRouter {}

class TransitionsBuilder {
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // you get an animation object and a widget
    // make your own transition
    return FadeTransition(opacity: animation, child: child);
  }
}
