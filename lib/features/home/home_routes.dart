import 'package:auto_route/auto_route.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

final homeRoutes = AutoRoute(
  page: HomeShellRoute.page,
  children: [
    AutoRoute(
      page: HomeRoute.page,
    ),
    AutoRoute(
      page: WithdrawFundsRoute.page,
    ),
    AutoRoute(
      page: TransactionPinRoute.page,
    ),
    AutoRoute(
      page: BuyAirtimeRoute.page,
    ),
    AutoRoute(
      page: BuyDataRoute.page,
    ),
    AutoRoute(
      page: ElectricityBillRoute.page,
    ),
    AutoRoute(
      page: BettingRoute.page,
    ),
    AutoRoute(
      page: CableBillRoute.page,
    ),
    AutoRoute(
      page: StandAloneTransactionDetailsRoute.page,
    ),
  ],
);
