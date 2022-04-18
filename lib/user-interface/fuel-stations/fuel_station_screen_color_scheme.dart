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
  late Color floatingBoxPanelBackgroundColor;
  late Color floatingBoxPanelSelectedColor;
  late Color floatingBoxPanelNonSelectedColor;

  late Color bodyBackgroundColor;
  late Color stationFuelTypeSwitcherColor;

  late Color fuelTypeSwitcherBtnBackgroundColor;
  late Color fuelTypeSwitcherBtnForegroundColor;

  late Color fuelStationSwitcherBtnBackgroundColor;
  late Color fuelStationSwitcherBtnForegroundColor;

  late Color fuelTypeSwitcherWidgetBackgroundColor;
  late Color fuelTypeSwitcherWidgetTextColor;
  late Color fuelTypeSwitcherWidgetButtonTextColor;

  late Color fuelStationSwitcherWidgetBackgroundColor;
  late Color fuelStationSwitcherWidgetTextColor;
  late Color fuelStationSwitcherWidgetButtonTextColor;

  late Color noDataScreenTextColor;

  FuelStationsScreenColorScheme(final ThemeData themeData) {
    floatingBoxPanelBackgroundColor = themeData.primaryColor;
    // floatingBoxPanelSelectedColor = const Color(0xFFFF886F); // derived from mycolor.space using indigo as primarycolor
    floatingBoxPanelSelectedColor = const Color(0xFFffd629);
    floatingBoxPanelNonSelectedColor = Colors.white;

    bodyBackgroundColor = const Color(0xFFF0EDFF); // derived from mycolor.space using indigo as primarycolor
    stationFuelTypeSwitcherColor = const Color(0xFFF0EDFF); // derived from mycolor.space using indigo as primarycolor

    fuelTypeSwitcherBtnBackgroundColor = themeData.primaryColor;
    fuelStationSwitcherBtnBackgroundColor = themeData.primaryColor;
    fuelTypeSwitcherBtnForegroundColor = Colors.white;
    fuelStationSwitcherBtnForegroundColor = Colors.white;

    fuelTypeSwitcherWidgetBackgroundColor = const Color(0xFFF0EDFF);
    fuelTypeSwitcherWidgetTextColor = themeData.primaryColor;
    fuelTypeSwitcherWidgetButtonTextColor = Colors.white;

    fuelStationSwitcherWidgetBackgroundColor = const Color(0xFFF0EDFF);
    fuelStationSwitcherWidgetTextColor = themeData.primaryColor;
    fuelStationSwitcherWidgetButtonTextColor = Colors.white;

    noDataScreenTextColor = themeData.primaryColor;
  }
}

class FuelStationCardColorScheme {
  late Color contextMenuBackgroundColor;
  late Color contextMenuForegroundColor;

  late Color cardColor;
  late Color primaryTextColor;
  late Color secondaryTextColor;

  late Color openCloseWidgetOpenColor;
  late Color openCloseWidgetCloseColor;

  late Color dividerColor;

  FuelStationCardColorScheme(final ThemeData themeData) {
    contextMenuBackgroundColor = Colors.white;
    contextMenuForegroundColor = themeData.primaryColor;

    cardColor = Colors.white;
    primaryTextColor = themeData.primaryColor;
    secondaryTextColor = themeData.colorScheme.secondary;
    openCloseWidgetOpenColor = const Color(0xFF05A985);
    openCloseWidgetCloseColor = const Color(0xFFF65D91);
    dividerColor = const Color(0xFF8987BC);
  }
}