import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import '../../common/services/session_timer_service.dart';
import '../../common/utils/locator.dart';
import '../bottomNav/app_router.gr.dart';

final _logger = Logger();

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _logger.d("🟡 Checking login status...");

    try {
      final box = Hive.box('data');

      final hasSeenOnboarding = box.get('onboarding_seen') == true;
      final token = box.get('accessToken');
      final loginTimeMillis = box.get('login_time');

      _logger.d("👀 Onboarding seen: $hasSeenOnboarding");
      _logger.d("✅ Token: $token");
      _logger.d("✅ Login time: $loginTimeMillis");

      // 👋 First-time launch
      if (!hasSeenOnboarding) {
        _logger.d("🔰 First launch — navigating to onboarding.");
        context.router.replaceAll([const OnboardingRoute()]);
        return;
      }

      // 🔐 No session after onboarding
      if (token == null || loginTimeMillis == null) {
        _logger.d("🔓 No token — navigating to login.");
        context.router.replaceAll([const LoginRoute()]);
        return;
      }

      // ⏳ Check session validity
      final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimeMillis);
      final sessionValid =
          DateTime.now().difference(loginTime) < const Duration(minutes: 5);

      if (!sessionValid) {
        _logger.d("⏱ Session expired. Logging out.");
        await box.delete('accessToken');
        await box.delete('login_time');
        context.router.replaceAll([const LoginRoute()]);
        return;
      }

      // ✅ Session valid — start timer and go to app
      _logger.d("🟢 Session valid. Starting timer.");

      ref.read(sessionTimerProvider).startTimer(() async {
        await box.delete('accessToken');
        await box.delete('login_time');
        appRouter.replaceAll([const LoginRoute()]);
      });

      // 👇 Navigate to main screen after frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        appRouter.replaceAll([const NaviBarRoute()]);
      });
    } catch (e, st) {
      _logger.e("🔥 Error checking login status: $e");
      _logger.e(st.toString());
      context.router.replaceAll([const OnboardingRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:
          theme.brightness == Brightness.dark ? Colors.black : Colors.white,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
