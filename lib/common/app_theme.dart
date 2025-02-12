import 'package:flutter/material.dart';

import 'res/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Figtree',
    brightness: Brightness.light,
    primarySwatch: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldColorLight,
    extensions: [
      CustomColors(
        // Light theme container color
        textColor: Colors.black,
        onboardContainerColor:
            AppColors.primaryColor.shade100, // Light theme text color
      ),
    ],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
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
    primarySwatch: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.secondaryColor.shade700,
    extensions: [
      CustomColors(
        // Light theme container color
        textColor: Colors.black,
        onboardContainerColor:
            AppColors.secondaryColor.shade700, // Light theme text color
      ),
    ],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.greyColor[800],
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
