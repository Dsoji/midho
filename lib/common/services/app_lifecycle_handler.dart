import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final _logger = Logger();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final box = Hive.box('data');

    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _logger.d("App is closing or becoming inactive. Logging out.");
      await box.delete('accessToken');
      await box.delete('login_time');
      await box.put('app_open', false);
    }
  }
}
