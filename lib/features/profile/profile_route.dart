import 'package:auto_route/auto_route.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

final profileRoutes = AutoRoute(
  page: ProfileShellRoute.page,
  children: [
    AutoRoute(
      page: ProfileRoute.page,
    ),
    AutoRoute(
      page: PersonalInfoRoute.page,
    ),
    AutoRoute(
      page: ChangeEmailRoute.page,
    ),
    AutoRoute(
      page: SecurtiySettingsRoute.page,
    ),
    AutoRoute(
      page: PreferenceRoute.page,
    ),
    AutoRoute(
      page: ChangePasswordRoute.page,
    ),
    AutoRoute(
      page: ChangePinRoute.page,
    ),
    AutoRoute(
      page: LinkedBanksRoute.page,
    ),
    AutoRoute(
      page: AddNewBankRoute.page,
    ),
  ],
);
