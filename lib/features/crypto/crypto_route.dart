import 'package:auto_route/auto_route.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

final cryptoRoutes = AutoRoute(
  page: CryptoShellRoute.page,
  children: [
    AutoRoute(
      page: CryptoRoute.page,
    ),
    AutoRoute(
      page: SellCryptoRoute.page,
    ),
    AutoRoute(
      page: QrCryptoRoute.page,
    ),
  ],
);
