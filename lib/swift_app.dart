import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mdiho/common/app_theme.dart';
import 'package:mdiho/common/theme_notifier.dart';
import 'package:mdiho/common/toast/toast_warpper.dart';
import 'package:mdiho/common/utils/dimesnsion.dart';
import 'package:mdiho/features/bottomNav/app_router.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/bottomNav/route_observer.dart';
import 'package:overlay_support/overlay_support.dart';

class MyApp extends HookConsumerWidget {
  MyApp({super.key});
  final appRouter = AppRouter();
  final toastKey = GlobalKey<ToastWrapperState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);

    return _MyAppStatefulWidget(
      appRouter: appRouter,
      toastKey: toastKey,
      themeNotifier: themeNotifier,
    );
  }
}

class _MyAppStatefulWidget extends StatefulWidget {
  final AppRouter appRouter;
  final GlobalKey<ToastWrapperState> toastKey;
  final ThemeMode themeNotifier;

  const _MyAppStatefulWidget({
    required this.appRouter,
    required this.toastKey,
    required this.themeNotifier,
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyAppStatefulWidget>
    with WidgetsBindingObserver {
  int? lastPausedTime;
  int? lastHiddenTime;
  int? lastInactiveTime;

  @override
  void initState() {
    super.initState();
    // Register the observer to listen to lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final scale =
        mediaQuery.textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2);

    return OverlaySupport.global(
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: mediaQuery.copyWith(textScaler: scale),
          child: child!,
        ),
        debugShowCheckedModeBanner: false,
        themeMode: widget.themeNotifier,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: ToastWrapper(
          key: widget.toastKey,
          child: Builder(builder: (context) {
            final media = MediaQuery.of(context);
            Dims.setSize(media);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(),
              child: Router(
                routerDelegate: widget.appRouter.delegate(
                  navigatorObservers: () => [AppRouterObserver()],
                ),
                routeInformationParser: widget.appRouter.defaultRouteParser(),
                routeInformationProvider: widget.appRouter.routeInfoProvider(),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    print("AppLifecycleState changed to $state at $currentTime");

    switch (state) {
      case AppLifecycleState.resumed:
        print("onResume called at $currentTime");
        if (lastPausedTime != null) {
          final elapsedPauseTime = currentTime - lastPausedTime!;
          print("Time since onPause: $elapsedPauseTime ms");
          if (elapsedPauseTime >= 30 * 1000) {
            print("30 seconds elapsed since onPause, triggering action");
            widget.appRouter.replaceAll([const SplashRoute()]);
          }
        }
        if (lastHiddenTime != null) {
          final elapsedHideTime = currentTime - lastHiddenTime!;
          print("Time since onHide: $elapsedHideTime ms");
          if (elapsedHideTime >= 30 * 1000) {
            print("30 seconds elapsed since onHide, triggering action");
            widget.appRouter.replaceAll([const SplashRoute()]);
          }
        }
        if (lastInactiveTime != null) {
          final elapsedInactiveTime = currentTime - lastInactiveTime!;
          print("Time since onInactive: $elapsedInactiveTime ms");
          if (elapsedInactiveTime >= 90 * 1000) {
            print("90 seconds elapsed since onInactive, triggering action");
            widget.appRouter.replaceAll([const SplashRoute()]);
          }
        }
        break;
      case AppLifecycleState.paused:
        print("onPause called at $currentTime");
        lastPausedTime = currentTime;
        break;
      case AppLifecycleState.inactive:
        print("onInactive called at $currentTime");
        lastInactiveTime = currentTime;
        break;
      case AppLifecycleState.detached:
        print("onHide called at $currentTime");
        lastHiddenTime = currentTime;
        break;
      case AppLifecycleState.hidden:
        print("onHidden called at $currentTime");
        break;
    }
  }
}
