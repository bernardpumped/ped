import 'package:flutter/material.dart';

class PumpedAppBarColorScheme {
  late Color backgroundColor;
  late Color iconThemeColor;
  late Color foregroundColor;
  late Color titleColor;

  PumpedAppBarColorScheme(final ThemeData themeData) {
    backgroundColor = const Color(0xFFF0EDFF);
    iconThemeColor = themeData.primaryColor;
    foregroundColor = themeData.primaryColor;
    titleColor = themeData.primaryColor;
  }
}