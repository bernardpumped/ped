/*
 *     Copyright (c) 2022.
 *     This file is part of Pumped End Device.
 *
 *     Pumped End Device is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Pumped End Device is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with Pumped End Device.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class UiThemes {
  static const lightTheme = 'light';
  static const lightThemeReadableName = 'Light Theme';
  static const darkTheme = 'dark';
  static const darkThemeReadableName = 'Dark Theme';
  static const systemTheme = 'system';
  static const systemThemeReadableName = 'System Theme';

  static const themes = {
    lightTheme: lightThemeReadableName,
    darkTheme: darkThemeReadableName,
    systemTheme: systemThemeReadableName
  };

  static getThemeMode(final String uiThemes) {
    if (DataUtils.isNotBlank(uiThemes)) {
      switch (uiThemes) {
        case lightTheme:
          return ThemeMode.light;
        case darkTheme:
          return ThemeMode.dark;
        case systemTheme:
          return ThemeMode.system;
        default:
          throw Exception('Invalid uiTheme : $uiThemes');
      }
    }
  }
}
