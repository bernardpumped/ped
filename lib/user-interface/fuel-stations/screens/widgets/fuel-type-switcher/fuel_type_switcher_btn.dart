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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/fuel_station_screen_color_scheme.dart';

class FuelTypeSwitcherButton extends StatelessWidget {
  final String _txtToDisplay;
  final Function() _trailingButtonAction;
  FuelTypeSwitcherButton(this._txtToDisplay, this._trailingButtonAction, {Key? key}) : super(key: key);

  final FuelStationsScreenColorScheme colorScheme =
      getIt.get<FuelStationsScreenColorScheme>(instanceName: fsScreenColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    return Chip(
        elevation: 5,
        backgroundColor: colorScheme.fuelTypeSwitcherBtnBackgroundColor,
        avatar: CircleAvatar(
            backgroundColor: colorScheme.fuelTypeSwitcherBtnBackgroundColor,
            child: Icon(Icons.workspaces, color: colorScheme.fuelTypeSwitcherBtnForegroundColor)),
        label: Text(_txtToDisplay, overflow: TextOverflow.ellipsis),
        labelStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: colorScheme.fuelTypeSwitcherBtnForegroundColor),
        labelPadding: const EdgeInsets.all(3),
        onDeleted: _trailingButtonAction,
        deleteIcon: Icon(Icons.chevron_right, color: colorScheme.fuelTypeSwitcherWidgetBackgroundColor));
  }
}
