import 'package:flutter/material.dart';
import 'package:pumped_end_device/util/color_schemes.g.dart';

class AppTheme2 {
  static const font = 'SF-Pro-Display';
  // static const primarySwatch = Colors.indigo;

  // static const primaryColorLgTh = Colors.indigo;
  // static const primaryColorSwatchLgTh = Colors.indigo;
  // static const bgColorLgTh = Colors.white;

  // static const primaryColorDkTh = Colors.white;
  // static const primaryColorSwatchDkTh = Color(0xFFDEE1FC); gmail buttons etc.
  // static const primaryColorSwatchDkTh = Colors.lightBlue;
  // static const bgColorDkTh = Colors.black54;

  static const stationOpenColor = Color(0xFF05A985);
  static const stationCloseColor = Color(0xFFF65D91);
  static const pumpedImage = 'assets/images/ic_splash.png';
  static const pumpedImageBlackText = 'assets/images/ic_pumped_black_text.png';
  static const oldBackgroundColor = Color(0xFFF0EDFF);

  //https://api.flutter.dev/flutter/material/TextTheme-class.html
  static const textTheme = TextTheme(
      displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500, fontFamily: font), //displayLarge
      displayMedium: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500, fontFamily: font), //displayMedium
      displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, fontFamily: font), //displaySmall
      headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, fontFamily: font), //headlineMedium
      headlineSmall: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, fontFamily: font), //headlineSmall
      titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: font), //titleLarge
      titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, fontFamily: font), //titleMedium
      titleSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: font), //titleSmall
      bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: font), //bodyLarge
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: font), //bodyMedium
      labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: font), //labelLarge
      bodySmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: font), //bodySmall
      labelSmall: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal, fontFamily: font)); //labelSmall

  static getPumpedLogo(final BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? AppTheme2.pumpedImageBlackText : AppTheme2.pumpedImage;
  }

  static modalBottomSheetBg(final BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).primaryColor;
  }

//  https://m3.material.io/theme-builder#/custom

  get lightTheme => ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: textTheme.apply(bodyColor: lightColorScheme.primary, displayColor: lightColorScheme.primary));

  get darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: textTheme.apply(bodyColor: darkColorScheme.primary, displayColor: darkColorScheme.primary));

  static const paleBlue = Color(0xFFA4C2F4);
}
