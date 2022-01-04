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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FontsAndColors {
  static const Color blackTextColor = Colors.black;
  static const Color primaryTextColor = Colors.black87;

  static const Color strongBlueTextColor = Color(0xff027EC3);
  static const Color pumpedNonActionableIconColor = strongBlueTextColor;

  static const Color vividBlueTextColor = Color(0xFF1873E6);
  static const Color pumpedSecondaryIconColor = vividBlueTextColor;

  static const Color veryDarkGrey = Color(0xFF616161);
  static const Color pumpedFuelStationDetailsColor = veryDarkGrey;

  static const Color strongRed = Color(0x11000000);
  static const Color pumpedBoxDecorationColor = strongRed;

  static const double normalFontSize = 14;
  static const double largeFontSize = 16;

  static const TextStyle aboutScreenParaTextStyle = TextStyle(fontSize: 14, color: primaryTextColor);
}
