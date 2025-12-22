import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/gift_card/data/controller/gift_card_controller.dart';
import 'package:mdiho/features/home/presentation/widget/transaction_tile.dart';
import 'package:mdiho/features/home/presentation/widget/welcome_header.dart';
import 'package:mdiho/features/kyc/verification_method.dart';
import 'package:mdiho/features/profile/data/controller/profile_controller.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';
import '../../kyc/presentation/widget/kyc_dialog.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/theme_notifier.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import '../../bottomNav/app_router.gr.dart';
import 'widget/quick_action_grid.dart';
import 'widget/summary_card.dart';
import 'widget/wallet_balance_card.dart';

final logger = Logger();

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  void initializeHomeData(WidgetRef ref) {
    ref.read(authenticationControllerProvider.notifier).fetchProfile();
    ref.read(authenticationControllerProvider.notifier).fetchNotification();
    ref.read(giftCardControllerProvider.notifier).getGiftCards();
    ref.read(transactionControllerProvider.notifier).fetchTransactions();
    ref.read(profileControllerProvider.notifier).getFaq();
    ref.read(transactionControllerProvider.notifier).getTransactions();
    ref.read(transactionControllerProvider.notifier).getCurrencies();
    ref.read(transactionControllerProvider.notifier).getRates();
    ref.read(transactionControllerProvider.notifier).getReferrals();
    ref.read(transactionControllerProvider.notifier).getRewards();
    ref.read(profileControllerProvider.notifier).getBanks();
    ref.read(transactionControllerProvider.notifier).getDataPlans();
    ref.read(transactionControllerProvider.notifier).getCableTvPlans();
    ref.read(transactionControllerProvider.notifier).getAirtimePlans();
    ref.read(transactionControllerProvider.notifier).getElectricalPlans();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsRouter = AutoTabsRouter.of(context);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initializeHomeData(ref);
      });
      return null;
    }, []);

    useEffect(() {
      void listener() {
        if (tabsRouter.activeIndex == 0) {
          ref.read(authenticationControllerProvider.notifier).fetchProfile();
        }
      }

      tabsRouter.addListener(listener);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        listener();
      });

      return () {
        tabsRouter.removeListener(listener);
      };
    }, [tabsRouter]);

    int backPressCounter = 0;
    DateTime? lastBackPressTime;
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;

    useEffect(() {
      final box = Hive.box('data');
      box.put('biometric', userInfo?.biometrics ?? false);
      return null;
    }, [userInfo?.biometrics]);

    useEffect(() {
      return null;
    }, []);

// Automatically sync theme once userInfo is available
    useEffect(() {
      if (userInfo?.theme != null) {
        Future.microtask(() {
          final userTheme = userInfo!.theme!.toLowerCase().trim();
          final themeNotifier = ref.read(themeProvider.notifier);

          if (userTheme == 'light') {
            themeNotifier.setLightTheme();
          } else if (userTheme == 'dark') {
            themeNotifier.setDarkTheme();
          }
        });
      }
      return null;
    }, [userInfo?.theme]);

    useEffect(() {
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => KycDialog(
              onCompleteKyc: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const VerificationMethodScreen()));
                // TODO: Navigate to verification method
              },
            ),
          );
        }
      });
      return null;
    }, []);

    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) async {
        DateTime now = DateTime.now();

        // Reset counter if last press was more than 2 seconds ago
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          backPressCounter = 0;
        }

        lastBackPressTime = now;
        backPressCounter++;

        if (backPressCounter < 2) {
          Fluttertoast.showToast(
            msg: "Swipe back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          );
        } else {
          Navigator.of(context).pop(); // Allow exit on second back swipe
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(authenticationControllerProvider.notifier)
                  .fetchProfile();
              ref
                  .read(authenticationControllerProvider.notifier)
                  .fetchNotification();
              ref.read(giftCardControllerProvider.notifier).getGiftCards();
              ref
                  .read(transactionControllerProvider.notifier)
                  .fetchTransactions();
              ref.read(profileControllerProvider.notifier).getFaq();
              ref
                  .read(transactionControllerProvider.notifier)
                  .getTransactions();
              ref.read(transactionControllerProvider.notifier).getCurrencies();
              ref.read(transactionControllerProvider.notifier).getRates();
              ref.read(transactionControllerProvider.notifier).getReferrals();
              ref.read(transactionControllerProvider.notifier).getRewards();
              ref.read(profileControllerProvider.notifier).getBanks();
              ref.read(transactionControllerProvider.notifier).getDataPlans();
              ref
                  .read(transactionControllerProvider.notifier)
                  .getCableTvPlans();
              ref
                  .read(transactionControllerProvider.notifier)
                  .getAirtimePlans();
              ref
                  .read(transactionControllerProvider.notifier)
                  .getElectricalPlans();

              return Future.delayed(const Duration(seconds: 1));
            },
            child: const SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  WelcomeHeader(),
                  Gap(16),
                  WalletBalanceCard(
                    balance: 9500000,
                  ),
                  Gap(12),
                  SummaryCards(),
                  Gap(16),
                  QuickActionsGrid(),
                  Gap(16),
                  TransactionCard(),
                  Gap(
                    50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReferralButton extends StatelessWidget {
  const ReferralButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.router.push(const ReferallRoute());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? AppColors.secondaryColor.shade400
              : const Color(0xFFF5FDFE), // Light background color
          borderRadius: BorderRadius.circular(30), // Rounded corners
          border: Border.all(
            color: theme.brightness == Brightness.dark
                ? Colors.transparent
                : AppColors.customBlue,
            width: 0.5,
          ), // Light blue border
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconsaxPlusBold.award, // Placeholder icon
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.customBlue.shade700,
              size: 17,
            ),
            const SizedBox(width: 6),
            Text(
              "Referrals",
              style: TextStyle(
                fontSize: 12,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.customBlue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(6),
            Icon(
              IconsaxPlusLinear.arrow_right_3, // Placeholder icon
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.customBlue.shade700,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIconContainer extends StatelessWidget {
  const CustomIconContainer({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32, // Diameter = 2 * radius
        height: 32,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.brightness == Brightness.dark
                ? Colors.transparent
                : AppColors.whiteColor.shade50,
            border: Border.all(
              color: AppColors.whiteColor.shade600,
            )),
        child: const Center(
          child: Icon(
            IconsaxPlusLinear.notification,
            size: 20,
          ),
        ),
      ),
    );
  }
}
