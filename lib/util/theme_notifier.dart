import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;
  double _textScale;

  ThemeNotifier(this._themeMode, this._textScale);

  getThemeMode() => _themeMode;

  getTextScale() => _textScale;

  setThemeMode(final ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
  }

  setTextScale(final double textScale) async {
    _textScale = textScale;
  }
}