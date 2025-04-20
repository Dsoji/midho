import 'package:flutter/material.dart';

class AppColors {
  // static Color black = '#000000'.htmlColorToColor();
  // static Color backGroundGrey = '#f7f8f8'.htmlColorToColor();
  // static Color youngRanchersPrimary = '10AB72'.htmlColorToColor();
  // static Color deepOnboardGreen = const Color(0xFF11312b);
  // static Color deepBlack = const Color(0xFF111312);
  // static Color textColor = const Color(0xFF282828);
  // static Color errorRed = const Color(0xFFE25A51);
  // static Color yellow = const Color(0xFFFFC628);
  // static Color greyBoxColor = const Color(0xFFE8EAEA);
  // static Color greyTextColor = const Color(0xFF3E4544);
  // static Color greyOrangeColor = const Color(0xFFF08F5D);
  static Color scaffoldColorLight = const Color.fromRGBO(247, 247, 247, 1);
  static Color errorColors = const Color.fromRGBO(255, 0, 0, 1);
  static Color infoColor = const Color.fromARGB(255, 219, 245, 71);
  static Color successColor = const Color.fromARGB(255, 20, 161, 20);
  static Color darkBorder = const Color(0xFF151515);

  static const MaterialColor primaryColor = MaterialColor(
    0xFF002B95, // Primary swatch value (blue-500: #002b95)
    <int, Color>{
      50: Color(0xFFE6EAF4), // blue-50
      100: Color(0xFFB0BDDE), // blue-100
      200: Color(0xFF8A9DCE), // blue-200
      300: Color(0xFF5471B8), // blue-300
      400: Color(0xFF3355AA), // blue-400
      500: Color(0xFF002B95), // blue-500
      600: Color(0xFF002788), // blue-600
      700: Color(0xFF001F6A), // blue-700
      800: Color(0xFF001852), // blue-800
      900: Color(0xFF00123F), // blue-900
    },
  );

  static const MaterialColor secondaryColor = MaterialColor(
    0xFF000000, // Primary color (500)
    <int, Color>{
      50: Color(0xFFE6E6E6), // #e6e6e6
      100: Color(0xFFB0B0B0), // #b0b0b0
      200: Color(0xFF8A8A8A), // #8a8a8a
      300: Color(0xFF545454), // #545454
      400: Color(0xFF333333), // #333333
      500: Color(0xFF000000), // #000000
      600: Color(0xFF000000), // #000000
      700: Color(0xFF000000), // #000000
      800: Color(0xFF000000), // #000000
      900: Color(0xFF000000), // #000000
    },
  );

  static MaterialColor whiteColor = const MaterialColor(
    0xFFF7F7F7, // Using white-500 (#f7f7f7) as the primary swatch value
    <int, Color>{
      50: Color(0xFFFEFEFE), // #fefefe
      100: Color(0xFFFDFDFD), // #fdfdfd
      200: Color(0xFFFBFBFB), // #fbfbfb
      300: Color(0xFFFAFAFA), // #fafafa
      400: Color(0xFFF9F9F9), // #f9f9f9
      500: Color(0xFFF7F7F7), // #f7f7f7
      600: Color(0xFFE1E1E1), // #e1e1e1
      700: Color(0xFFAFAFAF), // #afafaf
      800: Color(0xFF888888), // #888888
      900: Color(0xFF686868), // #686868
    },
  );

  static MaterialColor greyColor = const MaterialColor(
    0xFF555555,
    <int, Color>{
      50: Color(0xFFEAEAEA), // #eaeaea
      100: Color(0xFFBDBDBD), // #bdbdbd
      200: Color(0xFF9D9D9D), // #9d9d9d
      300: Color(0xFF717171), // #717171
      400: Color(0xFF555555), // #555555
      500: Color(0xFF2B2B2B), // #2b2b2b
      600: Color(0xFF272727), // #272727
      700: Color(0xFF1F1F1F), // #1f1f1f
      800: Color(0xFF181818), // #181818
      900: Color(0xFF121212), // #121212
    },
  );

  static MaterialColor tertiaryColor = const MaterialColor(
    0xFF46E3F6,
    <int, Color>{
      50: Color(0xFFEDFDFE), // #edfcfe
      100: Color(0xFFC6F6FC), // #c6f6fc
      200: Color(0xFFAAF2FB), // #aaf2fb
      300: Color(0xFF83ECF9), // #83ecf9
      400: Color(0xFF6BE9F8), // #6be9f8
      500: Color(0xFF46E3F6), // #46e3f6
      600: Color(0xFF40CFE0), // #40cfe0
      700: Color(0xFF32A1AF), // #32a1af
      800: Color(0xFF277D87), // #277d87
      900: Color(0xFF1D5F67), // #1d5f67
    },
  );

  static const MaterialColor blueColor = MaterialColor(
    0xFF00CCFF, // Using "Normal" blue (#00ccff) as the primary swatch value
    <int, Color>{
      50: Color(0xFFE6FAFF), // Light - #e6faff
      100: Color(0xFFD9F7FF), // Light:hover - #d9f7ff
      200: Color(0xFFB0EFFF), // Light:active - #b0efff
      300: Color(0xFF00CCFF), // Normal - #00ccff
      400: Color(0xFF00B8E6), // Normal:hover - #00b8e6
      500: Color(0xFF00A3CC), // Normal:active - #00a3cc
      600: Color(0xFF0099BF), // Dark - #0099bf
      700: Color(0xFF007A99), // Dark:hover - #007a99
      800: Color(0xFF005C73), // Dark:active - #005c73
      900: Color(0xFF004759), // Darker - #004759
    },
  );

  static const MaterialColor customBlue = MaterialColor(
    0xFF0041E3, // Primary color (500)
    <int, Color>{
      50: Color(0xFFE6ECFC), // #e6ecfc
      100: Color(0xFFB0C4F6), // #b0c4f6
      200: Color(0xFF8AA8F2), // #8aa8f2
      300: Color(0xFF5480EC), // #5480ec
      400: Color(0xFF3367E9), // #3367e9
      500: Color(0xFF0041E3), // #0041e3
      600: Color(0xFF003BCF), // #003bcf
      700: Color(0xFF002EA1), // #002ea1
      800: Color(0xFF00247D), // #00247d
      900: Color(0xFF001B5F), // #001b5f
    },
  );
}
