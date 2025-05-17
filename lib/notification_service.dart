import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import 'common/res/app_colors.dart';

class NotificationService {
  static final _logger = Logger();

  static Future<void> initializeFCM() async {
    // Step 1: Initialize Awesome Notifications
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

    // Step 2: Request Firebase Notification Permission
    await FirebaseMessaging.instance.requestPermission();

    // Step 3: Save FCM Token
    String? newToken = await FirebaseMessaging.instance.getToken();
    if (newToken != null) {
      var box = Hive.box('data');
      String? savedToken = box.get('fcm_token');
      if (savedToken != newToken) {
        await box.put('fcm_token', newToken);
        _logger.d("✅ FCM Token saved: $newToken");
      }
    }

    // Step 4: Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.d("📥 Foreground FCM message: ${message.notification?.title}");

      _logger.i('📩 FCM Message received: ${message.notification?.title}');
      if (message.notification != null) {
        showLocalNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      }
    });

    // Step 5: Handle notification tap from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _logger.i("🔔 Notification clicked from background: ${message.data}");
    });
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
