import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/utils/version_helper.dart';
import 'package:mdiho/features/authentication/data/controller/authentication_controller.dart';
import 'package:mdiho/features/kyc/presentation/verification_method.dart';
import 'package:mdiho/features/kyc/presentation/widget/kyc_dialog.dart';
import 'package:mdiho/features/profile/data/controller/profile_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../common/res/app_colors.dart';
import '../../../common/res/assets.dart';
import '../app_router.gr.dart';
import 'bottom_nav.dart';

final logger = Logger();

@RoutePage()
class NaviBarScreen extends HookConsumerWidget {
  const NaviBarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userDetails = ref.watch(authenticationControllerProvider).userDetails;
    final isEcode = userDetails.value?.ecode ?? false;

    // Load package info asynchronously
    final packageInfoAsync = useFuture(PackageInfo.fromPlatform());
    final hasLogged = useRef(false);

    // Track if platform info has been logged
    final hasLoggedPlatform = useRef(false);
    // Track if update screen has been shown
    final updateScreenShown = useRef(false);

    // Fetch platform info once on mount
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(profileControllerProvider.notifier).getPlatform();
      });
      return null;
    }, []);

    // Log package info once when available
    useEffect(() {
      if (packageInfoAsync.hasData &&
          packageInfoAsync.data != null &&
          !hasLogged.value) {
        final packageInfo = packageInfoAsync.data!;
        hasLogged.value = true;

        logger.d('App Name: ${packageInfo.appName}');
        logger.d('Package Name: ${packageInfo.packageName}');
        logger.d('App Version: ${packageInfo.version}');
        logger.d('Build Number: ${packageInfo.buildNumber}');

        debugPrint('═══════════════════════════════════════');
        debugPrint('📱 App Name: ${packageInfo.appName}');
        debugPrint('📦 Package Name: ${packageInfo.packageName}');
        debugPrint('🔢 App Version: ${packageInfo.version}');
        debugPrint('🏗️ Build Number: ${packageInfo.buildNumber}');
        debugPrint('═══════════════════════════════════════');
      } else if (packageInfoAsync.hasError && !hasLogged.value) {
        hasLogged.value = true;
        logger.e('Error loading package info: ${packageInfoAsync.error}');
        debugPrint('❌ Error loading package info: ${packageInfoAsync.error}');
      }
      return null;
    }, [packageInfoAsync.hasData, packageInfoAsync.hasError]);

    // Check platform info periodically without causing rebuilds
    useEffect(() {
      // Check immediately
      Future<void> checkPlatform() async {
        final platformAsync = ref.watch(profileControllerProvider).platform;
        final packageInfo = packageInfoAsync.data;

        // Log the state for debugging
        debugPrint('🔍 Platform AsyncValue state:');
        debugPrint('  - hasData: ${platformAsync.hasValue}');
        debugPrint('  - isLoading: ${platformAsync.isLoading}');
        debugPrint('  - hasError: ${platformAsync.hasError}');

        platformAsync.when(
          data: (platform) async {
            // Check if platform has actual data (not just empty object)
            if (platform.youtube != null && platform.youtube != '') {
              if (!hasLoggedPlatform.value) {
                hasLoggedPlatform.value = true;
                logger.d('Platform: $platform');
                debugPrint('═══════════════════════════════════════');
                debugPrint('🖥️ Platform Data Loaded');
                debugPrint('📺 YouTube URL: ${platform.youtube}');
                debugPrint('📱 iOS Version: ${platform.iosVersion}');
                debugPrint('🤖 Android Version: ${platform.androidVersion}');
                debugPrint('🔒 Force Update: ${platform.forceVersion}');
                debugPrint('═══════════════════════════════════════');
              }

              // Check for version update
              if (packageInfo != null &&
                  !updateScreenShown.value &&
                  context.mounted) {
                final currentVersion = packageInfo.version;

                final isRequired = await VersionHelper.isUpdateRequired(
                  platformData: platform,
                  currentVersion: currentVersion,
                );
                debugPrint('🔄 isRequired: $isRequired');

                if (isRequired) {
                  updateScreenShown.value = true;
                  final isForce = VersionHelper.isForceUpdate(platform);

                  debugPrint('🔄 Update required!');
                  debugPrint('   Current: $currentVersion');
                  debugPrint(
                      '   Required: ${Platform.isIOS ? platform.iosVersion : platform.androidVersion}');
                  debugPrint('   Force update: $isForce');

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      context.router.push(
                        ForceUpdateRoute(
                          isForceUpdate: isForce,
                          platformData: platform,
                        ),
                      );
                    }
                  });
                }
              }
            } else {
              if (!hasLoggedPlatform.value) {
                debugPrint('⚠️ Platform data is empty/null');
              }
            }
          },
          loading: () {
            debugPrint('⏳ Platform data is still loading...');
          },
          error: (error, stackTrace) {
            if (!hasLoggedPlatform.value) {
              hasLoggedPlatform.value = true; // Don't keep retrying on error
              logger.e('Error loading platform: $error');
              debugPrint('❌ Error loading platform: $error');
              debugPrint('❌ Stack trace: $stackTrace');
            }
          },
        );
      }

      // Check immediately
      checkPlatform();

      // Check again after delays (in case it loads asynchronously)
      Future.delayed(const Duration(seconds: 1), checkPlatform);
      Future.delayed(const Duration(seconds: 3), checkPlatform);
      Future.delayed(const Duration(seconds: 5), checkPlatform);

      return null;
    }, [packageInfoAsync.hasData]);

    useEffect(() {
      final box = Hive.box('data');
      box.put('is_auth', false);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'high_importance_channel',
            title: message.notification?.title ?? 'No Title',
            body: message.notification?.body ?? 'No Body',
            notificationLayout: NotificationLayout.Default,
          ),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        logger.d('A new onMessageOpenedApp event was published!');
      });

      return () {};
    }, []);

    final userAsync = ref.watch(authenticationControllerProvider).userDetails;

    final kycStatus = userAsync.maybeWhen(
      data: (user) => user.kyc,
      orElse: () => null,
    );
    final enforceKyc = userAsync.maybeWhen(
      data: (user) => user.enforceKyc,
      orElse: () => null,
    );

    // Track if dialog has been shown to prevent multiple dialogs
    final dialogShown = useRef(false);

    useEffect(() {
      // Only show dialog when KYC is incomplete and enforcement is required
      // Also ensure we haven't shown it already and context is mounted
      if (kycStatus == false &&
          enforceKyc == true &&
          !dialogShown.value &&
          context.mounted) {
        dialogShown.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => KycDialog(
                onCompleteKyc: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerificationMethodScreen(),
                    ),
                  );
                },
              ),
            );
          }
        });
      }
      // Reset dialog flag if KYC status changes
      if (kycStatus == true) {
        dialogShown.value = false;
      }
      return null;
    }, [kycStatus, enforceKyc]);

    return AutoTabsRouter(
      routes: [
        const HomeRoute(),
        const CryptoRoute(),
        const TransactionHistoryRoute(),
        if (isEcode) const GiftCardRoute(),
        const ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final activeIndex = tabsRouter.activeIndex;

        return WillPopScope(
          onWillPop: () async {
            if (context.router.canPop()) {
              return false; // Prevents app from closing
            }
            return false; // App will close only if no back stack
          },
          child: Scaffold(
            extendBody: true,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: child, // AutoRoute handles this properly
            ),
            bottomNavigationBar: Container(
              height: 85,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                color: theme.brightness == Brightness.dark
                    ? AppColors.darkBorder
                    : Colors.white,
              ),
              child: Builder(
                builder: (context) {
                  final items = [
                    {
                      'icon': IconsaxPlusBold.home_2,
                      'inactiveIcon': IconsaxPlusLinear.home_2,
                      'label': 'Home',
                    },
                    {
                      'icon': HugeIcons.strokeRoundedBitcoinTransaction,
                      'inactiveIcon': HugeIcons.strokeRoundedBitcoinTransaction,
                      'label': 'Crypto',
                    },
                    {
                      'imagePath': ImageAssets.logo2,
                      'label': 'Transactions',
                    },
                    if (isEcode)
                      {
                        'icon': HugeIcons.strokeRoundedGiftCard,
                        'inactiveIcon': HugeIcons.strokeRoundedGiftCard,
                        'label': 'Gift Cards',
                      },
                    {
                      'icon': HugeIcons.strokeRoundedUser,
                      'inactiveIcon': HugeIcons.strokeRoundedUser,
                      'label': 'Profile',
                    },
                  ];

                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(items.length, (index) {
                      return BottomNav(
                        index: index,
                        onTap: () {
                          // Only check KYC for index 1 (Crypto tab)
                          if (index == 1 &&
                              kycStatus == false &&
                              enforceKyc == true) {
                            showDialog(
                              context: context,
                              builder: (context) => KycDialog(
                                onCompleteKyc: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VerificationMethodScreen(),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            tabsRouter.setActiveIndex(index);
                          }
                        },
                        icon: items[index]['icon'] as IconData?,
                        imagePath: items[index]['imagePath'] as String?,
                        label: items[index]['label'] as String,
                        color: activeIndex == index
                            ? AppColors.primaryColor.shade500
                            : AppColors.secondaryColor.shade200,
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
