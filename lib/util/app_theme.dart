import 'package:flutter/material.dart';

class AppTheme {
  static const stationOpenColor = Color(0xFF05A985);
  static const stationCloseColor = Color(0xFFF65D91);
  static const pumpedImage = 'assets/images/ic_splash.png';
  static const pumpedImageBlackText = 'assets/images/ic_pumped_black_text.png';
  static const oldBackgroundColor = Color(0xFFF0EDFF);

  static const _headline1TxtStyle = TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500);
  static const _headline2TxtStyle = TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500);
  static const _headline3TxtStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal);
  static const _headline4TxtStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500);
  static const _headline5TxtStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal);
  static const _headline6TxtStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal);
  static const _subtitle1TxtStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);
  static const _subtitle2TxtStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal);
  static const _bodyText1TxtStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  static const _bodyText2TxtStyle = TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal);
  static const _buttonTxtStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);
  static const _captionTxtStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  static const _overLineTxtStyle = TextStyle(fontSize: 13.0, fontWeight: FontWeight.normal);

  //https://api.flutter.dev/flutter/material/TextTheme-class.html
  static const textTheme = TextTheme(
      headline1: _headline1TxtStyle,
      headline2: _headline2TxtStyle,
      headline3: _headline3TxtStyle,
      headline4: _headline4TxtStyle,
      headline5: _headline5TxtStyle,
      headline6: _headline6TxtStyle,
      subtitle1: _subtitle1TxtStyle,
      subtitle2: _subtitle2TxtStyle,
      bodyText1: _bodyText1TxtStyle,
      bodyText2: _bodyText2TxtStyle,
      button: _buttonTxtStyle,
      caption: _captionTxtStyle,
      overline: _overLineTxtStyle);

  static getPumpedLogo(final BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? AppTheme.pumpedImageBlackText : AppTheme.pumpedImage;
  }

  static modalBottomSheetBg(final BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).backgroundColor
        : Theme.of(context).primaryColor;
  }

  static const _primaryColorLgTh = Colors.indigo;
  static const _bgColorLgTh = Colors.white;
  static const _highLightColorForLgTh = Colors.indigo;
  static const _fontFamily = 'SF-Pro-Display';

  get lightTheme => ThemeData(
      appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(color: _highLightColorForLgTh),
          backgroundColor: _bgColorLgTh,
          centerTitle: false,
          elevation: 0,
          foregroundColor: _primaryColorLgTh,
          iconTheme: IconThemeData(color: _highLightColorForLgTh),
          surfaceTintColor: _bgColorLgTh,
          titleTextStyle: TextStyle(fontSize: 26, color: _highLightColorForLgTh)),
      backgroundColor: _bgColorLgTh,
      brightness: Brightness.light,
      canvasColor: _bgColorLgTh,
      cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
          color: _bgColorLgTh,
          elevation: 1.5,
          shadowColor: _primaryColorLgTh,
          surfaceTintColor: _bgColorLgTh),
      checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(_highLightColorForLgTh),
          fillColor: MaterialStateProperty.all(_bgColorLgTh),
          side: MaterialStateBorderSide.resolveWith((_) => const BorderSide(width: 2, color: _highLightColorForLgTh))),
      chipTheme: const ChipThemeData(
          backgroundColor: _highLightColorForLgTh,
          deleteIconColor: _bgColorLgTh,
          elevation: 2,
          iconTheme: IconThemeData(color: _bgColorLgTh),
          labelStyle: TextStyle(color: _bgColorLgTh)),
      colorScheme: ColorScheme.fromSeed(seedColor: _primaryColorLgTh, brightness: Brightness.light),
      dividerColor: _primaryColorLgTh.withOpacity(0.3),
      drawerTheme: const DrawerThemeData(backgroundColor: _bgColorLgTh, elevation: 2),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: _highLightColorForLgTh,
              elevation: 2,
              foregroundColor: _bgColorLgTh,
              shadowColor: _primaryColorLgTh,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              surfaceTintColor: _highLightColorForLgTh,
              textStyle: _buttonTxtStyle)),
      expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: _bgColorLgTh,
          collapsedIconColor: _highLightColorForLgTh,
          collapsedTextColor: _primaryColorLgTh,
          collapsedBackgroundColor: _bgColorLgTh,
          iconColor: _highLightColorForLgTh,
          textColor: _primaryColorLgTh),
      errorColor: Colors.red,
      highlightColor: _highLightColorForLgTh,
      hintColor: _primaryColorLgTh.shade200,
      iconTheme: const IconThemeData(color: _primaryColorLgTh),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _primaryColorLgTh)),
          focusColor: _primaryColorLgTh,
          hintStyle: _subtitle2TxtStyle.copyWith(color: _primaryColorLgTh)),
      listTileTheme: const ListTileThemeData(iconColor: _highLightColorForLgTh, textColor: _primaryColorLgTh),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              backgroundColor: _highLightColorForLgTh,
              elevation: 2,
              foregroundColor: _bgColorLgTh,
              shadowColor: _primaryColorLgTh,
              side: const BorderSide(color: _primaryColorLgTh, width: 0))),
      popupMenuTheme: PopupMenuThemeData(color: _bgColorLgTh.withOpacity(1), elevation: 2),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: _bgColorLgTh,
          color: _bgColorLgTh,
          linearTrackColor: _primaryColorLgTh,
          refreshBackgroundColor: _highLightColorForLgTh),
      radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all(_highLightColorForLgTh)),
      scaffoldBackgroundColor: _bgColorLgTh,
      shadowColor: _primaryColorLgTh,
      tabBarTheme: TabBarTheme(
          indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: _highLightColorForLgTh)),
          labelColor: _highLightColorForLgTh,
          labelStyle: _headline6TxtStyle.apply(fontWeightDelta: 1),
          overlayColor: MaterialStateColor.resolveWith((states) => _bgColorLgTh),
          unselectedLabelColor: _highLightColorForLgTh,
          unselectedLabelStyle: _headline6TxtStyle),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStateColor.resolveWith((states) => _highLightColorForLgTh))),
      textSelectionTheme: const TextSelectionThemeData(
          selectionColor: _primaryColorLgTh, cursorColor: _primaryColorLgTh, selectionHandleColor: _primaryColorLgTh),
      textTheme: textTheme.apply(
          bodyColor: _primaryColorLgTh,
          decorationColor: _primaryColorLgTh,
          displayColor: _primaryColorLgTh,
          fontFamily: _fontFamily),
      timePickerTheme: TimePickerThemeData(
          backgroundColor: _bgColorLgTh.withOpacity(1),
          dayPeriodTextColor: _primaryColorLgTh,
          dialHandColor: _primaryColorLgTh,
          entryModeIconColor: _primaryColorLgTh,
          helpTextStyle: const TextStyle(color: _primaryColorLgTh),
          hourMinuteTextColor: _primaryColorLgTh),
      unselectedWidgetColor: _primaryColorLgTh,
      useMaterial3: true);

  static const _paleBlue = Color(0xFFA4C2F4);
  static const _highLightColorForDkTh = _paleBlue;
  static const _primaryColorDkTh = Colors.white;
  static const _bgColorDkTh = Colors.black54;

  get darkTheme => ThemeData(
        appBarTheme: const AppBarTheme(
            actionsIconTheme: IconThemeData(color: _highLightColorForDkTh),
            backgroundColor: _bgColorDkTh,
            centerTitle: false,
            elevation: 0,
            foregroundColor: _primaryColorDkTh,
            iconTheme: IconThemeData(color: _highLightColorForDkTh),
            surfaceTintColor: _bgColorDkTh,
            titleTextStyle: TextStyle(fontSize: 26, color: _highLightColorForDkTh)),
        backgroundColor: _bgColorDkTh,
        brightness: Brightness.dark,
        canvasColor: _bgColorDkTh,
        cardTheme: const CardTheme(
            clipBehavior: Clip.antiAlias,
            color: _bgColorDkTh,
            elevation: 1.5,
            shadowColor: _primaryColorDkTh,
            surfaceTintColor: _bgColorDkTh),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(_highLightColorForDkTh),
            fillColor: MaterialStateProperty.all(_bgColorDkTh),
            side:
                MaterialStateBorderSide.resolveWith((_) => const BorderSide(width: 2, color: _highLightColorForDkTh))),
        chipTheme: const ChipThemeData(
            backgroundColor: _highLightColorForDkTh,
            deleteIconColor: _bgColorDkTh,
            elevation: 2,
            iconTheme: IconThemeData(color: _bgColorDkTh),
            labelStyle: TextStyle(color: _bgColorDkTh)),
        colorScheme: ColorScheme.fromSeed(seedColor: _primaryColorDkTh, brightness: Brightness.dark),
        dividerColor: _primaryColorDkTh.withOpacity(0.3),
        drawerTheme: DrawerThemeData(backgroundColor: _bgColorDkTh.withOpacity(1), elevation: 2),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: _highLightColorForDkTh,
                elevation: 2,
                foregroundColor: _bgColorDkTh,
                shadowColor: _primaryColorDkTh,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                surfaceTintColor: _highLightColorForDkTh,
                textStyle: _buttonTxtStyle)),
        expansionTileTheme: const ExpansionTileThemeData(
            backgroundColor: _bgColorDkTh,
            collapsedIconColor: _highLightColorForDkTh,
            collapsedTextColor: _primaryColorDkTh,
            iconColor: _highLightColorForDkTh,
            textColor: _primaryColorDkTh),
        errorColor: Colors.red,
        highlightColor: _highLightColorForDkTh,
        hintColor: _primaryColorDkTh,
        iconTheme: const IconThemeData(color: _primaryColorDkTh),
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _primaryColorDkTh)),
            focusColor: _primaryColorDkTh,
            hintStyle: _subtitle2TxtStyle.copyWith(color: _primaryColorDkTh)),
        listTileTheme: const ListTileThemeData(iconColor: _highLightColorForDkTh, textColor: _primaryColorDkTh),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                backgroundColor: _highLightColorForDkTh,
                elevation: 2,
                foregroundColor: _bgColorDkTh,
                shadowColor: _primaryColorDkTh,
                side: const BorderSide(color: _primaryColorDkTh, width: 0))),
        popupMenuTheme: PopupMenuThemeData(color: _bgColorDkTh.withOpacity(1), elevation: 2),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            circularTrackColor: _bgColorDkTh,
            color: _bgColorDkTh,
            linearTrackColor: _primaryColorDkTh,
            refreshBackgroundColor: _highLightColorForDkTh),
        radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all(_highLightColorForDkTh)),
        scaffoldBackgroundColor: _bgColorDkTh,
        shadowColor: _primaryColorDkTh,
        tabBarTheme: TabBarTheme(
            indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: _highLightColorForDkTh)),
            labelColor: _highLightColorForDkTh,
            labelStyle: _headline6TxtStyle.apply(fontWeightDelta: 1),
            overlayColor: MaterialStateColor.resolveWith((states) => _bgColorDkTh),
            unselectedLabelColor: _highLightColorForDkTh,
            unselectedLabelStyle: _headline6TxtStyle),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(foregroundColor: MaterialStateColor.resolveWith((states) => _highLightColorForDkTh))),
        textSelectionTheme: const TextSelectionThemeData(
            selectionColor: _primaryColorDkTh, cursorColor: _primaryColorDkTh, selectionHandleColor: _primaryColorDkTh),
        textTheme: textTheme.apply(
            bodyColor: _primaryColorDkTh,
            decorationColor: _primaryColorDkTh,
            displayColor: _primaryColorDkTh,
            fontFamily: _fontFamily),
        timePickerTheme: TimePickerThemeData(
            backgroundColor: _bgColorDkTh.withOpacity(1),
            dayPeriodTextColor: _primaryColorDkTh,
            dialHandColor: _primaryColorDkTh,
            entryModeIconColor: _primaryColorDkTh,
            helpTextStyle: const TextStyle(color: _primaryColorDkTh),
            hourMinuteTextColor: _primaryColorDkTh),
        useMaterial3: true,
        unselectedWidgetColor: _primaryColorDkTh,
      );
}
