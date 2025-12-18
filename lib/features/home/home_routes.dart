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
      page: TransactinRoute.page,
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
    AutoRoute(
      page: NotificationRoute.page,
    ),
    AutoRoute(
      page: ReferallRoute.page,
    ),
    AutoRoute(
      page: AddNewBankRoute.page,
    ),
    AutoRoute(
      page: BillTransactionDetailsRoute.page,
    ),
    AutoRoute(
      page: SupportFaqRoute.page,
    ),
    AutoRoute(
      page: WithdrawReferallRoute.page,
    ),
    AutoRoute(
      page: GiftCardRoute.page,
    ),
    AutoRoute(
      page: EnterCardDetailsRoute.page,
    ),
    AutoRoute(
      page: CardDetailsProofRoute.page,
    ),
    AutoRoute(
      page: TransactinRoute.page,
    ),
  ],
);
