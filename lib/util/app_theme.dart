import 'package:flutter/material.dart';

class AppTheme {
  static const font = 'SF-Pro-Display';
  static const primarySwatch = Colors.indigo;

  static const primaryColorLgTh = Colors.indigo;
  static const primaryColorSwatchLgTh = Colors.indigo;
  static const bgColorLgTh = Colors.white;

  static const primaryColorDkTh = Colors.greenAccent;
  static const primaryColorSwatchDkTh = Colors.green;
  static const bgColorDkTh = Colors.black54;

  static const stationOpenColor = Color(0xFF05A985);
  static const stationCloseColor = Color(0xFFF65D91);
  static const pumpedImage = 'assets/images/ic_splash.png';
  static const pumpedImageBlackText = 'assets/images/ic_pumped_black_text.png';
  static const oldBackgroundColor = Color(0xFFF0EDFF);

  //https://api.flutter.dev/flutter/material/TextTheme-class.html
  static const textTheme = TextTheme(
      headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      headline2: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      headline3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      headline4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      headline5: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      subtitle2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorLgTh),
      caption: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
      overline: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh));

  static getPumpedLogo(final BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? AppTheme.pumpedImageBlackText : AppTheme.pumpedImage;
  }

  static modalBottomSheetBg(final BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).backgroundColor
        : Theme.of(context).primaryColor;
  }

  get lightTheme => ThemeData(
      drawerTheme: const DrawerThemeData(backgroundColor: bgColorLgTh, elevation: 2),
      errorColor: Colors.red,
      highlightColor: Colors.amber,
      brightness: Brightness.light,
      popupMenuTheme: const PopupMenuThemeData(color: bgColorLgTh),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              elevation: 2,
              shadowColor: primaryColorLgTh,
              foregroundColor: bgColorLgTh,
              backgroundColor: primaryColorLgTh,
              side: const BorderSide(color: primaryColorLgTh, width: 0))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              elevation: 2,
              shadowColor: primaryColorLgTh,
              backgroundColor: primaryColorLgTh,
              surfaceTintColor: primaryColorLgTh,
              foregroundColor: bgColorLgTh,
              textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: font),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
      inputDecorationTheme: const InputDecorationTheme(
          focusColor: primaryColorLgTh,
          hintStyle:
              TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorLgTh),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColorLgTh))),
      textSelectionTheme: const TextSelectionThemeData(
          selectionColor: primaryColorLgTh, cursorColor: primaryColorLgTh, selectionHandleColor: primaryColorLgTh),
      timePickerTheme: const TimePickerThemeData(
          backgroundColor: bgColorLgTh,
          hourMinuteTextColor: primaryColorLgTh,
          dialHandColor: primaryColorLgTh,
          entryModeIconColor: primaryColorLgTh,
          dayPeriodTextColor: primaryColorLgTh,
          helpTextStyle: TextStyle(color: primaryColorLgTh)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStateColor.resolveWith((states) => primaryColorLgTh))),
      chipTheme: const ChipThemeData(
          elevation: 2,
          backgroundColor: primaryColorLgTh,
          labelStyle: TextStyle(color: bgColorLgTh),
          deleteIconColor: bgColorLgTh,
          iconTheme: IconThemeData(color: bgColorLgTh)),
      appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(color: primaryColorLgTh),
          centerTitle: false,
          backgroundColor: bgColorLgTh,
          surfaceTintColor: bgColorLgTh,
          iconTheme: IconThemeData(color: primaryColorLgTh),
          foregroundColor: primaryColorLgTh),
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
      primarySwatch: primaryColorSwatchLgTh,
      colorScheme: ColorScheme.fromSwatch(accentColor: primaryColorLgTh),
      iconTheme: const IconThemeData(color: primaryColorLgTh),
      dividerColor: primaryColorLgTh.withOpacity(0.3),
      backgroundColor: bgColorLgTh,
      scaffoldBackgroundColor: bgColorLgTh,
      canvasColor: bgColorLgTh,
      shadowColor: primaryColorLgTh,
      cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
          surfaceTintColor: bgColorLgTh,
          color: bgColorLgTh,
          elevation: 1.5,
          shadowColor: primaryColorLgTh),
      unselectedWidgetColor: primaryColorLgTh,
      textTheme: textTheme);

  static const textThemeDkTh = TextTheme(
      headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      headline2: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      headline3: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      headline4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      headline5: TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      subtitle2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: font, color: primaryColorDkTh),
      caption: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
      overline: TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh));

  get darkTheme => ThemeData(
      drawerTheme: DrawerThemeData(backgroundColor: bgColorDkTh.withOpacity(1), elevation: 2),
      brightness: Brightness.dark,
      errorColor: Colors.red,
      highlightColor: Colors.amber,
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              elevation: 2,
              shadowColor: primaryColorDkTh,
              foregroundColor: bgColorDkTh,
              backgroundColor: primaryColorDkTh,
              side: const BorderSide(color: primaryColorDkTh, width: 0))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              elevation: 2,
              shadowColor: primaryColorDkTh,
              backgroundColor: primaryColorDkTh,
              surfaceTintColor: primaryColorDkTh,
              foregroundColor: bgColorDkTh,
              textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: font),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
      inputDecorationTheme: const InputDecorationTheme(
          focusColor: primaryColorDkTh,
          hintStyle:
              TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, fontFamily: font, color: primaryColorDkTh),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColorDkTh))),
      textSelectionTheme: const TextSelectionThemeData(
          selectionColor: primaryColorDkTh, cursorColor: primaryColorDkTh, selectionHandleColor: primaryColorDkTh),
      timePickerTheme: TimePickerThemeData(
          backgroundColor: bgColorDkTh.withOpacity(1),
          hourMinuteTextColor: primaryColorDkTh,
          dialHandColor: primaryColorDkTh,
          entryModeIconColor: primaryColorDkTh,
          dayPeriodTextColor: primaryColorDkTh,
          helpTextStyle: const TextStyle(color: primaryColorDkTh)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStateColor.resolveWith((states) => primaryColorDkTh))),
      chipTheme: const ChipThemeData(
          elevation: 2,
          backgroundColor: primaryColorDkTh,
          labelStyle: TextStyle(color: bgColorDkTh),
          deleteIconColor: bgColorDkTh,
          iconTheme: IconThemeData(color: bgColorDkTh)),
      appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: bgColorDkTh,
          surfaceTintColor: bgColorDkTh,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColorDkTh),
          foregroundColor: primaryColorDkTh),
      checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith((_) => const BorderSide(width: 2, color: primaryColorDkTh)),
          fillColor: MaterialStateProperty.all(bgColorDkTh),
          checkColor: MaterialStateProperty.all(primaryColorDkTh)),
      listTileTheme: const ListTileThemeData(iconColor: primaryColorDkTh, textColor: primaryColorDkTh),
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: primaryColorDkTh,
        textColor: primaryColorDkTh,
        collapsedIconColor: primaryColorDkTh,
        // backgroundColor: bgColorDkTh,
        collapsedTextColor: primaryColorDkTh,
        // collapsedBackgroundColor: bgColorDkTh
      ),
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
      primarySwatch: primaryColorSwatchDkTh,
      colorScheme: const ColorScheme.dark(),
      iconTheme: const IconThemeData(color: primaryColorDkTh),
      dividerColor: primaryColorDkTh.withOpacity(0.3),
      backgroundColor: bgColorDkTh,
      scaffoldBackgroundColor: bgColorDkTh,
      canvasColor: bgColorDkTh,
      shadowColor: primaryColorDkTh,
      cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
          surfaceTintColor: bgColorDkTh,
          color: bgColorDkTh,
          elevation: 1.5,
          shadowColor: primaryColorDkTh),
      unselectedWidgetColor: primaryColorDkTh,
      textTheme: textThemeDkTh);
}
