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
    final themeNotifier = ref.watch(themeProvider);
    var box = Hive.box('data');
    final rememberMe = box.get('remember_me');
    final accessToken = box.get('accessToken');

    // Using useRef to store timestamps and useEffect to observe lifecycle state
    final lastPausedTime = useRef<int?>(null);
    final lastHiddenTime = useRef<int?>(null);
    final lastInactiveTime = useRef<int?>(null);

    useEffect(() {
      // Register the observer to listen to lifecycle events
      WidgetsBinding.instance.addObserver(AppLifecycleObserver(
        onResume: (currentTime) {
          logger.d("onResume called at $currentTime");
          if (lastPausedTime.value != null) {
            final elapsedPauseTime = currentTime - lastPausedTime.value!;
            logger.d("Time since onPause: $elapsedPauseTime ms");
            if (elapsedPauseTime >= 30 * 1000) {
              logger.d("30 seconds elapsed since onPause, triggering action");
              if (accessToken == null && rememberMe == false) {
                appRouter.push(const SplashRoute());
              } else {
                appRouter.push(const StayLogin2Route());
              }
            }
          }
          if (lastHiddenTime.value != null) {
            final elapsedHideTime = currentTime - lastHiddenTime.value!;
            logger.d("Time since onHide: $elapsedHideTime ms");
            if (elapsedHideTime >= 30 * 1000) {
              logger.d("30 seconds elapsed since onHide, triggering action");
              if (accessToken == null && rememberMe == false) {
                appRouter.push(const SplashRoute());
              } else {
                appRouter.push(const StayLogin2Route());
              }
            }
          }
          if (lastInactiveTime.value != null) {
            final elapsedInactiveTime = currentTime - lastInactiveTime.value!;
            logger.d("Time since onInactive: $elapsedInactiveTime ms");
            if (elapsedInactiveTime >= 90 * 1000) {
              logger
                  .d("90 seconds elapsed since onInactive, triggering action");
              if (accessToken == null && rememberMe == false) {
                appRouter.push(const SplashRoute());
              } else {
                appRouter.push(const StayLogin2Route());
              }
            }
          }
        },
        onPause: (currentTime) {
          logger.d("onPause called at $currentTime");
          lastPausedTime.value = currentTime;
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
    final currentTime = DateTime.now().millisecondsSinceEpoch;
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
}
