import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppRouterObserver extends AutoRouterObserver {
  static final ValueNotifier<List<String>> loadingTextsNotifier =
      ValueNotifier<List<String>>([]);

  @override
  void didPush(Route route, Route? previousRoute) {
    if (kDebugMode) log('New route pushed: ${route.settings.name}');
    _updateLoadingTexts(route.settings.name);
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    if (kDebugMode) log('Tab route visited: ${route.name}');
    _updateLoadingTexts(route.name);
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    if (kDebugMode) log('Tab route re-visited: ${route.name}');
    _updateLoadingTexts(route.name);
  }

  void _updateLoadingTexts(String? routeName) {
    if (routeName == null) return;

    // Map routes to loading text arrays
    switch (routeName) {
      case 'SignInRoute':
        loadingTextsNotifier.value = [
          "Signing in",
          "Authenticating",
          "Hang tight",
        ];
        break;

      case 'CreateAccountRoute':
        loadingTextsNotifier.value = [
          "Creating account",
          "Setting up",
          "Almost there",
        ];
        break;

      case 'CreatePostRoute':
        loadingTextsNotifier.value = [
          "Posting",
          "Uploading",
          "One sec",
        ];
        break;

      case 'ForgotPasswordRoute':
        loadingTextsNotifier.value = [
          "Resetting",
          "Sending code",
          "Hold on",
        ];
        break;

      case 'OtpVerificationRoute':
        loadingTextsNotifier.value = [
          "Verifying",
          "Checking",
          "Hang on",
        ];
        break;

      case 'ResetPasswordRoute':
        loadingTextsNotifier.value = [
          "Resetting",
          "Updating",
          "One moment",
        ];
        break;

      case 'ResetPasswordVerificationRoute':
        loadingTextsNotifier.value = [
          "Checking code",
          "Verifying",
          "Hold tight",
        ];
        break;

      case 'DiscoverInterestRoute':
        loadingTextsNotifier.value = [
          "Updating",
          "Hang on",
          "One sec",
        ];
        break;

      case 'CourseDetailsRoute':
        loadingTextsNotifier.value = [
          "Adding your review",
          "Almost done",
          "One sec",
        ];
        break;

      default:
        loadingTextsNotifier.value = [
          "Loading",
          "Please wait",
          "Fetching",
        ];
        break;
    }
  }
}
