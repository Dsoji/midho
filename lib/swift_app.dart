import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/app_theme.dart';
import 'package:mdiho/common/theme_notifier.dart';
import 'package:mdiho/common/toast/taost_service.dart';
import 'package:mdiho/common/toast/toast_warpper.dart';
import 'package:mdiho/common/utils/dimesnsion.dart';
import 'package:mdiho/features/bottomNav/app_router.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/bottomNav/route_observer.dart';
import 'package:overlay_support/overlay_support.dart';

final logger = Logger();

class MyApp extends HookConsumerWidget {
  MyApp({super.key});
  final appRouter = AppRouter();
  final toastKey = GlobalKey<ToastWrapperState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var box = Hive.box('data');
    final rememberMe = box.get('remember_me');
    final isAuth = box.get('is_auth');
    logger.d("rememberMe: $rememberMe");
    logger.d("isAuth: $isAuth");

    // Using useRef to store timestamps and useEffect to observe lifecycle state
    final lastPausedTime = useRef<int?>(null);
    final lastHiddenTime = useRef<int?>(null);
    final lastInactiveTime = useRef<int?>(null);

    useEffect(() {
      // Register the observer to listen to lifecycle events
      WidgetsBinding.instance.addObserver(AppLifecycleObserver(
        onResume: (currentTime) {
          logger.d("onResume called at $currentTime");

          // Check elapsed time since onPause and trigger actions
          if (lastPausedTime.value != null) {
            final elapsedPauseTime = currentTime - lastPausedTime.value!;
            logger.d("Time since onPause: $elapsedPauseTime seconds");

            if (elapsedPauseTime >= 30) {
              logger.d(
                  "30 seconds elapsed since onPause, checking conditions before navigation");

              // Get current values from Hive box
              final currentIsAuth = box.get('is_auth');
              final currentRememberMe = box.get('remember_me');

              logger.d(
                  "Current isAuth: $currentIsAuth, rememberMe: $currentRememberMe");

              // Check conditions before navigating
              if (currentIsAuth == false) {
                logger.d("isAuth is false, checking rememberMe status");
                if (currentRememberMe == false) {
                  logger.d(
                      "Navigating to SplashRoute - user not authenticated and rememberMe is false");
                  appRouter.push(const SplashRoute());
                } else {
                  logger.d(
                      "Navigating to StayLogin2Route - user not authenticated but rememberMe is true");
                  appRouter.push(const StayLogin2Route());
                }
              } else {
                logger.d(
                    "User is authenticated (isAuth: true), no navigation needed");
              }
            } else {
              logger.d("Less than 30 seconds elapsed, no action needed");
            }
          } else {
            logger.d("No lastPausedTime found, timer not started");
          }

          // Reset the timer to zero when app resumes
          lastPausedTime.value = null;
          lastHiddenTime.value = null;
          lastInactiveTime.value = null;
          logger.d("Timer reset to zero on resume");
        },
        onPause: (currentTime) {
          logger.d("onPause called at $currentTime - Timer started from zero");
          lastPausedTime.value = currentTime; // Start timer from zero
        },
        onInactive: (currentTime) {
          logger.d("onInactive called at $currentTime");
          lastInactiveTime.value = currentTime;
        },
        onHide: (currentTime) {
          logger.d("onHide called at $currentTime");
          lastHiddenTime.value = currentTime;
        },
      ));

      // Unregister the observer when the widget is disposed
      return () {
        WidgetsBinding.instance.removeObserver(AppLifecycleObserver(
          onResume: (currentTime) {},
          onPause: (currentTime) {},
          onInactive: (currentTime) {},
          onHide: (currentTime) {},
        ));
      };
    }, []);
    final mediaQuery = MediaQuery.of(context);
    final scale =
        mediaQuery.textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2);
    Animate.restartOnHotReload = true;
    ToastService().initialize(toastKey);
    final themeNotifier = ref.watch(themeProvider);

    return OverlaySupport.global(
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: mediaQuery.copyWith(textScaler: scale),
          child: child!,
        ),
        debugShowCheckedModeBanner: false,
        themeMode: themeNotifier,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: ToastWrapper(
          key: toastKey,
          child: Builder(builder: (context) {
            final media = MediaQuery.of(context);
            Dims.setSize(media);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(),
              child: Router(
                routerDelegate: appRouter.delegate(
                  navigatorObservers: () => [AppRouterObserver()],
                ),
                routeInformationParser: appRouter.defaultRouteParser(),
                routeInformationProvider: appRouter.routeInfoProvider(),
                backButtonDispatcher: RootBackButtonDispatcher(),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// Observer class for managing app lifecycle state
class AppLifecycleObserver extends WidgetsBindingObserver {
  final void Function(int) onResume;
  final void Function(int) onPause;
  final void Function(int) onInactive;
  final void Function(int) onHide;

  AppLifecycleObserver({
    required this.onResume,
    required this.onPause,
    required this.onInactive,
    required this.onHide,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final currentTime =
        DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds
    logger.d("Lifecycle state changed to: $state at time: $currentTime");
    switch (state) {
      case AppLifecycleState.resumed:
        onResume(currentTime);
        break;
      case AppLifecycleState.paused:
        onPause(currentTime);
        break;
      case AppLifecycleState.inactive:
        onInactive(currentTime);
        break;
      case AppLifecycleState.detached:
        onHide(currentTime);
        break;
      case AppLifecycleState.hidden:
        onHide(currentTime);
        break;
    }
  }
}

class LifecycleGuard {
  static bool shouldForceSplashOnResume = true;
  static bool wasNotificationPulledDown = false;
  static bool isBiometricActive = false; // Flag for biometric authentication
  static Timer? backgroundTimer;
  static int backgroundStartTime = 0;
  static int totalBackgroundTime = 0;

  static void startBackgroundTimer() {
    backgroundStartTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      totalBackgroundTime = currentTime - backgroundStartTime;
      logger.d("Background timer: $totalBackgroundTime seconds");

      if (totalBackgroundTime >= 30) {
        logger.d("30 seconds in background reached!");
        // Handle your logic here
      }
    });
  }

  static void stopBackgroundTimer() {
    backgroundTimer?.cancel();
    backgroundTimer = null;
  }
}
