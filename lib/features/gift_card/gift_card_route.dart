import 'package:auto_route/auto_route.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';

final giftCardRoutes = AutoRoute(
  page: GiftCardShellRoute.page,
  children: [
    AutoRoute(
      page: GiftCardRoute.page,
    ),
    AutoRoute(
      page: EnterCardDetailsRoute.page,
    ),
    AutoRoute(
      page: CardDetailsProofRoute.page,
    ),
  ],
);
