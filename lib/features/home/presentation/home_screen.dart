import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:mdiho/features/home/presentation/widget/transaction_tile.dart';

import '../../../common/app_theme.dart';
import '../../../common/res/app_colors.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import 'widget/quick_action_grid.dart';
import 'widget/summary_card.dart';
import 'widget/wallet_balance_card.dart';
import 'widget/welcome_header.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ref.read(authenticationControllerProvider.notifier).fetchProfile();
        // ref.read(profileControllerProvider.notifier).getFaq();
      });
      return null;
    }, []);

    final theme = Theme.of(context);
    int backPressCounter = 0;
    DateTime? lastBackPressTime;
    final userInfo =
        ref.watch(authenticationControllerProvider).userDetails.valueOrNull;
    if (userInfo?.theme == 'LIGHT') {
      ref.read(themeNotifierProvider).toggleTheme(ThemeMode.light);
    } else if (userInfo?.theme == 'DARK') {
      ref.read(themeNotifierProvider).toggleTheme(ThemeMode.dark);
    }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: RefreshIndicator(
              onRefresh: () async {
                ref
                    .read(authenticationControllerProvider.notifier)
                    .fetchProfile();
                return Future.delayed(const Duration(seconds: 1));
              },
              child: const Column(
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
        // context.router.push(const ReferallRoute());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ReferallScreen(),
        //   ),
        // );
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
