import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'res/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Figtree',
    brightness: Brightness.light,
    primarySwatch: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldColorLight,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      headlineLarge: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      labelLarge: TextStyle(color: Colors.black),
      labelMedium: TextStyle(color: Colors.black),
      labelSmall: TextStyle(color: Colors.black),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.whiteColor.shade100,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    cardColor: AppColors.greyColor[50],
    iconTheme: const IconThemeData(color: Colors.black),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.primaryColor.shade500),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Figtree',
    brightness: Brightness.dark,
    primarySwatch: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.secondaryColor.shade700,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryColor.shade500,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardColor: AppColors.greyColor[700],
    iconTheme: const IconThemeData(color: Colors.white),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.primaryColor.shade500),
  );
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? onboardContainerColor;
  final Color? textColor;

  const CustomColors({
    required this.onboardContainerColor,
    required this.textColor,
  });

  @override
  CustomColors copyWith({Color? containerColor, Color? textColor}) {
    return CustomColors(
      onboardContainerColor: onboardContainerColor ?? onboardContainerColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other == null) return this;
    return CustomColors(
      onboardContainerColor:
          Color.lerp(onboardContainerColor, other.onboardContainerColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light); // Start with system mode

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode; // ✅ This updates the theme mode
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
