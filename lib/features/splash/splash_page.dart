import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/onboarding/presentation/onboarding_screen.dart';

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

    await Future.delayed(const Duration(seconds: 3));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
    // if (token == null) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const OnboardingScreen(),
    //     ),
    //   );
    // } else {
    //   context.router.push(
    //     const NaviBarRoute(),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.brightness == Brightness.dark ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                ImageAssets.logo,
                width: 62,
                height: 62,
              ),
            ),
            const Gap(25),
            Text(
              'Swift Swap',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
