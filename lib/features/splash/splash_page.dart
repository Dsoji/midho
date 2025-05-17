import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/features/onboarding/presentation/onboarding_screen.dart';

import '../bottomNav/app_router.gr.dart';

final _logger = Logger();

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    var box = Hive.box('data'); // No need to reopen it
    final fcmtoken = box.get('fcm_token');
    final token = box.get('accessToken');
    final deviceId = box.get('device_id');

    _logger.d("User token: $token");
    _logger.d("Device ID: $deviceId");
    _logger.d("FCM Token: $fcmtoken");

    if (token == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    } else {
      context.router.push(
        const NaviBarRoute(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.brightness == Brightness.dark ? Colors.black : Colors.white,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
