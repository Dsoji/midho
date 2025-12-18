import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import 'common/res/app_colors.dart';

class NotificationService {
  static final _logger = Logger();

  static Future<void> initializeFCM() async {
    try {
      // Step 1: Initialize local notifications (Awesome Notifications)
      AwesomeNotifications().initialize(
        'resource://drawable/notify_icon',
        [
          NotificationChannel(
            channelKey: 'high_importance_channel',
            channelGroupKey: 'high_importance_channel',
            channelName: 'High Importance Notifications',
            channelDescription: 'Used for important alerts',
            defaultColor: AppColors.primaryColor,
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            onlyAlertOnce: false,
            criticalAlerts: true,
          ),
        ],
        debug: true,
      );

      // Step 2: Request notification permissions
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        _logger.w("❌ Notification permissions denied.");
        return;
      }

      _logger.i("🔓 Notification permission granted.");

      // Step 3: Ensure FCM auto-init
      await FirebaseMessaging.instance.setAutoInitEnabled(true);

      // Step 4: Get APNs token (iOS only)
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      _logger.d("📱 APNs Token: $apnsToken");

      // Step 5: Get and store FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        var box = Hive.box('data');
        final savedToken = box.get('fcm_token');
        if (savedToken != fcmToken) {
          await box.put('fcm_token', fcmToken);
          _logger.i("✅ New FCM token saved: $fcmToken");
        } else {
          _logger.d("⚠️ FCM token unchanged.");
        }
      } else {
        _logger.e("❌ Failed to get FCM token.");
      }

      // Step 6: Handle messages while app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _logger.d(
            "📥 Foreground FCM message received: ${message.notification?.title}");

        if (message.notification != null) {
          // If Firebase doesn't handle notification display on iOS
          if (message.notification?.android == null &&
              message.notification?.apple == null) {
            showLocalNotification(
              title: message.notification?.title,
              body: message.notification?.body,
            );
          }
        }
      });

      // Step 7: Handle notification tap from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _logger.i("🔔 Notification opened: ${message.data}");
        // Handle deep links or routing logic here
      });
    } catch (e, stack) {
      _logger.e("💥 Error initializing FCM: $e", error: e, stackTrace: stack);
    }
  }

  static void showLocalNotification({
    required String? title,
    required String? body,
  }) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'high_importance_channel',
        title: title ?? 'New Notification',
        body: body ?? '',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
