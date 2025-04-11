import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mdiho/common/res/assets.dart';
import 'package:mdiho/features/bottomNav/app_router.gr.dart';
import 'package:mdiho/features/onboarding/presentation/onboarding_screen.dart';

import '../../common/res/app_colors.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
        ),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                SvgAssets.mdiho,
                width: 140,
                height: 140,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SvgPicture.asset(
                SvgAssets.mdihobckgrnd,
                width: double.infinity,
                height: 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
