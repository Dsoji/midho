import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../bottomNav/app_router.gr.dart';

final _logger = Logger();

@RoutePage()
class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() async {
        try {
          await _checkLoginStatus(context);
        } catch (e, st) {
          _logger.e("🔥 Splash logic error: $e");
          _logger.e(st.toString());
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _checkLoginStatus(BuildContext context) async {
    _logger.d("🟡 Checking onboarding status...");

    try {
      final box = Hive.box('data');
      final hasSeenOnboarding = box.get('onboarding_seen') == true;
      final accessToken = box.get('accessToken');
      final rememberMe = box.get('remember_me') == true;

      _logger.d("📦 onboarding_seen = $hasSeenOnboarding");
      _logger.d("📦 accessToken = $accessToken");
      _logger.d("📦 rememberMe = $rememberMe");

      // Add a post frame callback to ensure navigation happens after the widget is mounted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          _logger.d("🚫 Context is not mounted. Returning...");
          return;
        }

        if (!hasSeenOnboarding) {
          _logger.d("🔰 Navigating to Onboarding...");
          context.router.replaceAll([const OnboardingRoute()]);
        } else if (accessToken != null && rememberMe) {
          _logger.d("🔐 Navigating to StayLogin...");
          context.router.replaceAll([const StayLoginRoute()]);
        } else {
          _logger.d("🔓 Navigating to Login...");
          context.router.replaceAll([const LoginRoute()]);
        }
      });
    } catch (e, st) {
      _logger.e("🔥 Error during onboarding check: $e");
      _logger.e(st.toString());

      // Ensure to navigate to onboarding if error occurs
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.router.replaceAll([const OnboardingRoute()]);
        }
      });
    }
  }
}
