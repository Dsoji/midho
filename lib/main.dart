import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/theme_notifier.dart';
import 'package:mdiho/common/utils/locator.dart';
import 'package:mdiho/features/bottomNav/app_router.dart';
import 'package:mdiho/firebase_options.dart';
import 'package:overlay_support/overlay_support.dart';

import 'common/app_theme.dart';
import 'common/toast/taost_service.dart';
import 'common/toast/toast_warpper.dart';
import 'common/utils/dimesnsion.dart';
import 'features/bottomNav/route_observer.dart';

final _logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  await Hive.openBox('data');

  await _getAndSaveDeviceId();
  await getFCMToken();
  setUpLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  MyApp({super.key});
  final appRouter = AppRouter();
  final toastKey = GlobalKey<ToastWrapperState>(); // ✅ Move this here

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    ToastService().initialize(toastKey); // ✅ Initialize once

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
    );

    final mediaQuery = MediaQuery.of(context);
    final scale =
        mediaQuery.textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2);
    Animate.restartOnHotReload = true;

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
          key: toastKey, // ✅ Attach key here
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
              ),
            );
          }),
        ),
      ),
    );
  }
}

Future<void> _getAndSaveDeviceId() async {
  var box = Hive.box('data');
  String? deviceId = box.get('device_id');

  if (deviceId == null) {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.name;
        debugPrint("Android Device ID: $deviceId");
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.name;
        debugPrint("iOS Device ID: $deviceId");
      }

      if (deviceId != null) {
        await box.put('device_id', deviceId);
        debugPrint("Device ID saved in Hive: $deviceId");
      } else {
        debugPrint("Device ID is NULL!");
      }
    } catch (e) {
      debugPrint("Error getting device ID: $e");
    }
  } else {
    debugPrint("Retrieved Device ID from Hive: $deviceId");
  }
}

Future<void> getFCMToken() async {
  String? fCMToken = await FirebaseMessaging.instance.getToken();
  if (fCMToken != null) {
    _logger.d("FCM Token: $fCMToken");
    try {
      await Hive.initFlutter();
      var box = await Hive.openBox('data');

      // Check if FCM token already exists
      var storedToken = box.get('fcm_token');
      if (storedToken == null) {
        // Save the new FCM token if it doesn't exist
        await box.put('fcm_token', fCMToken);
        storedToken = fCMToken;
        _logger.d("New FCM Token saved: $storedToken");
      } else {
        _logger.d("Existing FCM Token found: $storedToken");
      }
    } catch (e) {
      _logger.e("Error saving or fetching FCM Token: $e");
    }
  } else {
    _logger.e("Failed to retrieve FCM Token");
  }
}
