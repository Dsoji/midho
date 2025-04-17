import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'isDarkMode';
  var box = Hive.box('data');

  ThemeNotifier() : super(ThemeMode.system) {
    final isDark = box.get(_themeKey, defaultValue: false);
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void setLightTheme() {
    box.put(_themeKey, false);
    state = ThemeMode.light;
  }

  void setDarkTheme() {
    box.put(_themeKey, true);
    state = ThemeMode.dark;
  }
}
