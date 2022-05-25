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

class NavDrawerColorScheme {
  late Color backgroundColor;
  late Color selectedBackgroundColor = Colors.white;
  late Color textColor;
  late Color selectedTextColor;
  late Color iconColor;
  late Color selectedIconColor;
  late Color dividerColor = Colors.white;
  static const pumpedImage = 'assets/images/ic_splash.png';

  NavDrawerColorScheme(final ThemeData themData) {
    backgroundColor = themData.primaryColor;
    selectedBackgroundColor = themData.colorScheme.onPrimary;
    textColor = Colors.white;
    selectedTextColor = backgroundColor;
    iconColor = Colors.white;
    selectedIconColor = backgroundColor;
    dividerColor = Colors.white;
  }
}