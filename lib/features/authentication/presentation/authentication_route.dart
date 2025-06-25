import 'package:auto_route/auto_route.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

final authenticationRoutes = AutoRoute(
  page: AuthShellRoute.page,
  children: [
    AutoRoute(
      page: OnboardingRoute.page,
    ),
    AutoRoute(
      page: LoginRoute.page,
    ),
    AutoRoute(
      page: StayLoginRoute.page,
    ),
    AutoRoute(
      page: RegistrationRoute.page,
    ),
    AutoRoute(
      page: ForgotPasswordRoute.page,
    ),
    AutoRoute(
      page: StayLogin2Route.page,
    ),
  ],
);
