import 'package:auto_route/auto_route.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

final splashScreenRoute = AutoRoute(
  page: SplashShellRoute.page,
  children: [
    AutoRoute(
      page: SplashRoute.page,
    ),
  ],
);
