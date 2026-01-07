import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/extension/string/string_extension.dart';
import 'package:mdiho/features/crypto/presentation/crypto_screen.dart';
import 'package:mdiho/features/gift_card/data/controller/gift_card_controller.dart';
import 'package:mdiho/features/home/presentation/widget/kyc_card.dart';
import 'package:mdiho/features/home/presentation/widget/transaction_tile.dart';
import 'package:mdiho/features/home/presentation/widget/welcome_header.dart';
import 'package:mdiho/features/leaderboard/leaderbord_screen.dart';
import 'package:mdiho/features/profile/data/controller/profile_controller.dart';
import 'package:mdiho/features/transaction/data/controller/transaction_controller.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/theme_notifier.dart';
import '../../authentication/data/controller/authentication_controller.dart';
import '../../bottomNav/app_router.gr.dart';
import '../../profile/data/Model/response/user_profile_model/user_profile_model.dart';
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
    ref.read(profileControllerProvider.notifier).getPlatform();
    ref.read(profileControllerProvider.notifier).getLeaderboard();
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
    final userAsync = ref.watch(authenticationControllerProvider).userDetails;

    // Safely extract userInfo without throwing on error states
    // Use previous data during loading to prevent blank screen flash
    final previousUserInfo = useRef<UserProfileModel?>(null);

    // Get current value safely to initialize ref (only if in data state)
    UserProfileModel? currentValue;
    userAsync.maybeWhen(
      data: (user) {
        currentValue = user;
        if (previousUserInfo.value == null) {
          previousUserInfo.value = user;
        }
      },
      orElse: () {},
    );

    // Initialize with current data if available, or get from AsyncValue
    final userInfo = userAsync.when(
      data: (user) {
        previousUserInfo.value = user;
        return user;
      },
      loading: () {
        // Return previous data during loading to prevent blank screen
        // Use current value if ref not set yet (shouldn't happen, but safety check)
        return previousUserInfo.value ?? currentValue ?? UserProfileModel();
      },
      error: (_, __) {
        // Return previous data on error to prevent blank screen
        return previousUserInfo.value ?? currentValue ?? UserProfileModel();
      },
    );

    useEffect(() {
      final box = Hive.box('data');
      box.put('biometric', userInfo.biometrics ?? false);
      return null;
    }, [userInfo.biometrics]);

// Automatically sync theme once userInfo is available
    useEffect(() {
      if (userInfo.theme != null) {
        Future.microtask(() {
          final userTheme = userInfo.theme!.toLowerCase().trim();
          final themeNotifier = ref.read(themeProvider.notifier);

          if (userTheme == 'light') {
            themeNotifier.setLightTheme();
          } else if (userTheme == 'dark') {
            themeNotifier.setDarkTheme();
          }
        });
      }
      return null;
    }, [userInfo.theme]);

    final kycStatus = userAsync.maybeWhen(
      data: (user) => user.kyc,
      orElse: () => null,
    );
    final enforceKyc = userAsync.maybeWhen(
      data: (user) => user.enforceKyc,
      orElse: () => null,
    );

    // Track if dialog has been shown to prevent duplicates
    final contextRef = useRef<BuildContext?>(null);

    // Store context ref during build (safe to do)
    contextRef.value = context;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  const WelcomeHeader(),
                  const Gap(16),
                  const WalletBalanceCard(
                    balance: 9500000,
                  ),
                  if (kycStatus == false) const CompletedKycCard(),
                  const Gap(12),
                  const SummaryCards(),
                  const Gap(16),
                  const LeaderboardEmptyStateCard(),
                  const Gap(16),
                  const QuickActionsGrid(),
                  const Gap(16),
                  const TransactionCard(),
                  const Gap(
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

class LeaderboardEmptyStateCard extends HookConsumerWidget {
  const LeaderboardEmptyStateCard({super.key});

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 22), // Space for icon alignment
              const Gap(8),
              Text(
                'Username',
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            'Monthly traded value',
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(
      profileControllerProvider.select((state) => state.leaderboard),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? AppColors.darkBorder
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Leaderboard",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF565B8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rewards State
          state.when(
            loading: () => Column(
              children: List.generate(
                2,
                (_) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CryptoCardShimmer(),
                ),
              ),
            ),
            error: (error, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_outlined,
                      size: 48, color: Colors.red),
                  const Gap(12),
                  Text('Failed to load rewards.',
                      style: TextStyle(color: Colors.red[600], fontSize: 16)),
                  const Gap(6),
                  Text(error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            data: (data) {
              final rewards = data;
              if (rewards.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(52),
                      const Icon(Icons.info_outline,
                          color: Colors.grey, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        "No leaderboard available.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  _buildHeader(context, theme),
                  Divider(
                    height: 1,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.secondaryColor.shade500
                        : Colors.grey.shade300,
                  ),
                  ...rewards.take(2).expand((reward) => [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.brightness == Brightness.dark
                                          ? AppColors.secondaryColor.shade400
                                          : const Color(0xFFF9F9FB),
                                    ),
                                    child: Icon(Icons.arrow_upward,
                                        size: 12,
                                        color:
                                            theme.brightness == Brightness.dark
                                                ? Colors.white
                                                : const Color(0xFF2B2B2B)),
                                  ),
                                  const Gap(8),
                                  Text(
                                    '${reward.user?.username}',
                                    style: TextStyle(
                                      color: theme.brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${reward.totalTradingValue}'.formatAsNaira(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  fontFamily: '',
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (reward != rewards.take(3).last)
                          Divider(
                            height: 1,
                            color: theme.brightness == Brightness.dark
                                ? AppColors.secondaryColor.shade500
                                : Colors.grey.shade300,
                          ),
                      ]),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // View All Rewards Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? AppColors.secondaryColor.shade400
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.secondaryColor.shade400
                      : AppColors.greyColor.shade500,
                  width: theme.brightness == Brightness.dark ? 0.5 : 0.07,
                ),
              ),
              child: Center(
                child: Text(
                  'View Leaderboard ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const Gap(12),
        ],
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
