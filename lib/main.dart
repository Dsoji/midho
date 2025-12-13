import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/utils/locator.dart';
import 'package:mdiho/firebase_options.dart';
import 'package:mdiho/notification_service.dart';
import 'package:mdiho/swift_app.dart';

final logger = Logger();

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Add timeout and error handling for Firebase initialization
    try {
      await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
      // Continue without Firebase if it fails
    }

    await Hive.initFlutter();
    await Hive.openBox('data');

    await _getAndSaveDeviceId();
    await NotificationService.initializeFCM();
    // WidgetsBinding.instance.addObserver(AppLifecycleHandler());
    setUpLocator();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(ProviderScope(child: MyApp()));
  }, (error, stackTrace) {
    debugPrint("Error: $error");
    debugPrint("Stack Trace: $stackTrace");
  });
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
