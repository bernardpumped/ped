import 'package:flutter/material.dart';

class AppTheme {
  static const font = 'SF-Pro-Display';
  static const primarySwatch = Colors.indigo;

  static const primaryColorLgTh = Colors.indigo;
  static const bgColorLgTh = Colors.white;

  static const primaryColorDkTh = Colors.green;
  static const bgColorDkTh = Colors.black45;

  //https://api.flutter.dev/flutter/material/TextTheme-class.html
  static const textTheme = TextTheme(
      headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      headline2: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      headline3: TextStyle(fontSize: 26.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      headline4: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      headline6: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      subtitle1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      subtitle2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      bodyText1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      bodyText2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      button: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      caption: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      overline: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh));

  get lightTheme => ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: bgColorLgTh, surfaceTintColor: bgColorLgTh),
      checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith((_) => const BorderSide(width: 2, color: primaryColorLgTh)),
          fillColor: MaterialStateProperty.all(bgColorLgTh),
          checkColor: MaterialStateProperty.all(primaryColorLgTh)),
      listTileTheme: const ListTileThemeData(iconColor: primaryColorLgTh, textColor: primaryColorLgTh),
      expansionTileTheme: const ExpansionTileThemeData(
          iconColor: primaryColorLgTh,
          textColor: primaryColorLgTh,
          collapsedIconColor: primaryColorLgTh,
          backgroundColor: bgColorLgTh,
          collapsedTextColor: primaryColorLgTh,
          collapsedBackgroundColor: bgColorLgTh),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: bgColorLgTh,
          circularTrackColor: bgColorLgTh,
          linearTrackColor: primaryColorLgTh,
          refreshBackgroundColor: primaryColorLgTh),
      tabBarTheme: TabBarTheme(
          overlayColor: MaterialStateColor.resolveWith((states) => bgColorLgTh),
          labelColor: primaryColorLgTh,
          unselectedLabelColor: primaryColorLgTh,
          indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: primaryColorLgTh))),
      useMaterial3: true,
      primarySwatch: primarySwatch,
      colorScheme: ColorScheme.fromSwatch(accentColor: primaryColorLgTh),
      iconTheme: const IconThemeData(color: primaryColorLgTh),
      dividerColor: primaryColorLgTh.withOpacity(0.3),
      backgroundColor: bgColorLgTh,
      scaffoldBackgroundColor: bgColorLgTh,
      canvasColor: bgColorLgTh,
      shadowColor: primaryColorLgTh,
      cardTheme: const CardTheme(
          surfaceTintColor: bgColorLgTh, color: bgColorLgTh, elevation: 1.5, shadowColor: primaryColorLgTh),
      unselectedWidgetColor: primaryColorLgTh,
      textTheme: textTheme);

  static const textThemeDkTh = TextTheme(
      headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      headline2: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      headline3: TextStyle(fontSize: 26.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      headline4: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      headline6: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      subtitle1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      subtitle2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      bodyText1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      bodyText2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      button: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      caption: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      overline: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh));

  get darkTheme => ThemeData(
      checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith((_) => const BorderSide(width: 2, color: primaryColorDkTh)),
          fillColor: MaterialStateProperty.all(bgColorDkTh),
          checkColor: MaterialStateProperty.all(primaryColorDkTh)),
      listTileTheme: const ListTileThemeData(iconColor: primaryColorDkTh, textColor: primaryColorDkTh),
      expansionTileTheme: const ExpansionTileThemeData(
          iconColor: primaryColorDkTh,
          textColor: primaryColorDkTh,
          collapsedIconColor: primaryColorDkTh,
          backgroundColor: bgColorDkTh,
          collapsedTextColor: primaryColorDkTh,
          collapsedBackgroundColor: bgColorDkTh),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: bgColorDkTh,
          circularTrackColor: bgColorDkTh,
          linearTrackColor: primaryColorDkTh,
          refreshBackgroundColor: primaryColorDkTh),
      tabBarTheme: TabBarTheme(
          overlayColor: MaterialStateColor.resolveWith((states) => bgColorDkTh),
          labelColor: primaryColorDkTh,
          unselectedLabelColor: primaryColorDkTh,
          indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: primaryColorDkTh))),
      useMaterial3: true,
      primarySwatch: primaryColorDkTh,
      colorScheme: const ColorScheme.dark(),
      iconTheme: const IconThemeData(color: primaryColorDkTh),
      dividerColor: primaryColorDkTh.withOpacity(0.3),
      backgroundColor: bgColorDkTh,
      scaffoldBackgroundColor: bgColorDkTh,
      shadowColor: primaryColorDkTh,
      cardTheme: const CardTheme(
          surfaceTintColor: bgColorDkTh, color: bgColorDkTh, elevation: 1.5, shadowColor: primaryColorDkTh),
      unselectedWidgetColor: primaryColorDkTh,
      textTheme: textThemeDkTh);
}
