import 'package:auto_route/auto_route.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

final transactionRoutes = AutoRoute(
  page: TransactionShellRoute.page,
  children: [
    AutoRoute(
      page: TransactionHistoryRoute.page,
    ),
    AutoRoute(
      page: TransactionDetailsRoute.page,
    ),
  ],
);
