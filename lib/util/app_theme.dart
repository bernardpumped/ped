import 'package:flutter/material.dart';

class AppTheme {
  static const stationOpenColor = Color(0xFF05A985);
  static const stationCloseColor = Color(0xFFF65D91);
  static const pumpedImage = 'assets/images/ic_splash.png';
  static const pumpedImageBlackText = 'assets/images/ic_pumped_black_text.png';

  static const font = 'SF-Pro-Display';

  static getPumpedLogo(final BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? AppTheme.pumpedImageBlackText : AppTheme.pumpedImage;
  }

  static const _headline1TxtStyle = TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500);
  static const _headline2TxtStyle = TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500);
  static const _headline3TxtStyle = TextStyle(fontSize: 26.0, fontWeight: FontWeight.normal);
  static const _headline4TxtStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500);
  static const _headline5TxtStyle = TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal);
  static const _headline6TxtStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.normal);
  static const _subtitle1TxtStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);
  static const _subtitle2TxtStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal);
  static const _bodyText1TxtStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal);
  static const _bodyText2TxtStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal);
  static const _buttonTxtStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);
  static const _captionTxtStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500);
  static const _overLineTxtStyle = TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal);

  //https://api.flutter.dev/flutter/material/TextTheme-class.html
  static const textTheme = TextTheme(
      displayLarge: _headline1TxtStyle,
      displayMedium: _headline2TxtStyle,
      displaySmall: _headline3TxtStyle,
      headlineMedium: _headline4TxtStyle,
      headlineSmall: _headline5TxtStyle,
      titleLarge: _headline6TxtStyle,
      titleMedium: _subtitle1TxtStyle,
      titleSmall: _subtitle2TxtStyle,
      bodyLarge: _bodyText1TxtStyle,
      bodyMedium: _bodyText2TxtStyle,
      labelLarge: _buttonTxtStyle,
      bodySmall: _captionTxtStyle,
      labelSmall: _overLineTxtStyle);

  static const _primaryColorLgTh = Colors.indigo;
  static const _bgColorLgTh = Colors.white;
  static const _highLightColorForLgTh = Colors.indigo;
  static const _fontFamily = 'SF-Pro-Display';

  get lightTheme => ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: _bgColorLgTh, surfaceTintColor: _bgColorLgTh),
      brightness: Brightness.light,
      canvasColor: _bgColorLgTh,
      cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
          color: _bgColorLgTh,
          elevation: 1.5,
          shadowColor: _primaryColorLgTh,
          surfaceTintColor: _bgColorLgTh),
      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(_highLightColorForLgTh),
          checkColor: MaterialStateProperty.all(_bgColorLgTh),
          side: MaterialStateBorderSide.resolveWith((_) => const BorderSide(width: 2, color: _highLightColorForLgTh))),
      chipTheme: const ChipThemeData(
          backgroundColor: _highLightColorForLgTh,
          deleteIconColor: _bgColorLgTh,
          elevation: 2,
          iconTheme: IconThemeData(color: _bgColorLgTh),
          labelStyle: TextStyle(color: _bgColorLgTh)),
      dividerColor: _primaryColorLgTh.withOpacity(0.3),
      expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: _bgColorLgTh,
          collapsedIconColor: _highLightColorForLgTh,
          collapsedTextColor: _primaryColorLgTh,
          collapsedBackgroundColor: _bgColorLgTh,
          iconColor: _highLightColorForLgTh,
          textColor: _primaryColorLgTh),
      highlightColor: _highLightColorForLgTh,
      hintColor: _primaryColorLgTh.shade200,
      iconTheme: const IconThemeData(color: _primaryColorLgTh),
      listTileTheme: const ListTileThemeData(iconColor: _highLightColorForLgTh, textColor: _primaryColorLgTh),
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
      textTheme: textTheme.apply(
          bodyColor: _primaryColorLgTh,
          decorationColor: _primaryColorLgTh,
          displayColor: _primaryColorLgTh,
          fontFamily: _fontFamily),
      unselectedWidgetColor: _primaryColorLgTh,
      useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: _primaryColorLgTh, brightness: Brightness.light).copyWith(background: _bgColorLgTh).copyWith(error: Colors.red));

  static const _paleBlue = Color(0xFFA4C2F4);
  static const _highLightColorForDkTh = _paleBlue;
  static const _primaryColorDkTh = Colors.white;
  static const _bgColorDkTh = Colors.black87;

  get darkTheme => ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: _bgColorDkTh, surfaceTintColor: _bgColorDkTh),
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
          side: MaterialStateBorderSide.resolveWith((_) => const BorderSide(width: 2, color: _highLightColorForDkTh))),
      chipTheme: const ChipThemeData(
          backgroundColor: _highLightColorForDkTh,
          deleteIconColor: _bgColorDkTh,
          elevation: 2,
          iconTheme: IconThemeData(color: _bgColorDkTh),
          labelStyle: TextStyle(color: _bgColorDkTh)),
      dividerColor: _primaryColorDkTh.withOpacity(0.3),
      expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: _bgColorDkTh,
          collapsedIconColor: _highLightColorForDkTh,
          collapsedTextColor: _primaryColorDkTh,
          iconColor: _highLightColorForDkTh,
          textColor: _primaryColorDkTh),
      highlightColor: _highLightColorForDkTh,
      hintColor: _primaryColorDkTh,
      iconTheme: const IconThemeData(color: _primaryColorDkTh),
      listTileTheme: const ListTileThemeData(iconColor: _highLightColorForDkTh, textColor: _primaryColorDkTh),
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
          labelStyle: _headline6TxtStyle.apply(fontWeightDelta: 1, color: _highLightColorForDkTh),
          overlayColor: MaterialStateColor.resolveWith((states) => _bgColorDkTh),
          unselectedLabelColor: _highLightColorForDkTh,
          unselectedLabelStyle: _headline6TxtStyle.apply(color: _highLightColorForDkTh)),
      textTheme: textTheme.apply(
          bodyColor: _primaryColorDkTh,
          decorationColor: _primaryColorDkTh,
          displayColor: _primaryColorDkTh,
          fontFamily: _fontFamily),
      useMaterial3: true,
      unselectedWidgetColor: _primaryColorDkTh, colorScheme: ColorScheme.fromSeed(seedColor: _primaryColorDkTh, brightness: Brightness.dark).copyWith(background: _bgColorDkTh).copyWith(error: Colors.red));
}
