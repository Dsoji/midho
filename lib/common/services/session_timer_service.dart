// import 'dart:async';

// import 'package:flutter/widgets.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:logger/logger.dart';
// import 'package:mdiho/common/utils/locator.dart';

// import '../../features/bottomNav/app_router.dart';
// import '../../features/bottomNav/app_router.gr.dart';
// import 'session_service.dart';

// class SessionTimerService {
//   final _logger = Logger();
//   final Duration sessionDuration = const Duration(minutes: 5);
//   Timer? _timer;

//   bool get isRunning => _timer != null;

//   void startTimer(VoidCallback onTimeout) {
//     if (_timer != null) {
//       _logger.d("Timer already running");
//       return;
//     }

//     _logger.d("Starting session timer");
//     _timer = Timer(sessionDuration, () async {
//       _logger.d("Timer expired, logging out");
//       await SessionService().logout();
//       onTimeout();
//       locator.get<AppRouter>().replaceAll([const OnboardingRoute()]);
//       _timer = null;
//     });
//   }

//   void cancelTimer() {
//     _logger.d("Cancelling session timer");
//     _timer?.cancel();
//     _timer = null;
//   }
// }

// final sessionTimerProvider = Provider<SessionTimerService>((ref) {
//   return SessionTimerService();
// });
