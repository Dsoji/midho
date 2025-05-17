import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
