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

class FuelStationsScreenColorScheme {
  late Color appBarColor;
  late Color appBarTextColor;
  late Color backgroundColor;

  FuelStationsScreenColorScheme(final ThemeData themData) {
    appBarColor = Colors.white;
    appBarTextColor = themData.colorScheme.secondary;
    backgroundColor = Colors.white70;
    // appBarColor = themData.colorScheme.secondary;
    // appBarTextColor = Colors.white;
    // backgroundColor = themData.colorScheme.secondary;
  }
}

class FuelStationCardColorScheme {
  late Color fuelStationCardColor;
  late Color fsCardPrimaryTextColor;
  late Color fsCardSecondaryTextColor;
  late Color chipColor;
  late Color chipInactiveColor;
  late Color chipTextColor;

  FuelStationCardColorScheme(final ThemeData themData) {
    fuelStationCardColor = themData.colorScheme.primaryContainer;
    fsCardPrimaryTextColor = themData.colorScheme.onPrimaryContainer;
    fsCardSecondaryTextColor = themData.colorScheme.onSecondaryContainer;
    chipColor = themData.colorScheme.secondary;
    chipTextColor = themData.colorScheme.onPrimary;
    chipInactiveColor = themData.colorScheme.inversePrimary;
  }
}