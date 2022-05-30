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
import 'package:pumped_end_device/util/log_util.dart';

import 'fuel_station_type.dart';

class FuelStationSwitcherWidget extends StatefulWidget {
  final FuelStationType fuelStationType;
  final Function onChangeCallback;

  const FuelStationSwitcherWidget({Key? key, required this.fuelStationType, required this.onChangeCallback})
      : super(key: key);

  @override
  State<FuelStationSwitcherWidget> createState() => _FuelStationSwitcherWidgetState();
}

class _FuelStationSwitcherWidgetState extends State<FuelStationSwitcherWidget> {
  static const _tag = 'FuelStationSwitcherWidget';
  FuelStationType? fuelStationType;

  final FuelStationsScreenColorScheme colorScheme =
      getIt.get<FuelStationsScreenColorScheme>(instanceName: fsScreenColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    String labelText;
    IconData iconData;
    if (widget.fuelStationType == FuelStationType.nearby) {
      labelText = 'Nearby Fuel';
      iconData = Icons.near_me;
    } else {
      labelText = 'Favourite Fuel';
      iconData = Icons.favorite;
    }
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            context: context,
            builder: _modalBottomSheetBuilder,
            backgroundColor: colorScheme.fuelStationSwitcherWidgetBackgroundColor);
      },
      child: Chip(
          elevation: 5,
          backgroundColor: colorScheme.fuelStationSwitcherBtnBackgroundColor,
          avatar: CircleAvatar(
              backgroundColor: colorScheme.fuelStationSwitcherBtnBackgroundColor,
              child: Icon(iconData, color: colorScheme.fuelStationSwitcherBtnForegroundColor)),
          label: Text(labelText),
          labelPadding: const EdgeInsets.all(3),
          labelStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: colorScheme.fuelStationSwitcherBtnForegroundColor),
          onDeleted: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                context: context,
                builder: _modalBottomSheetBuilder,
                backgroundColor: colorScheme.fuelStationSwitcherWidgetBackgroundColor);
          },
          deleteIcon: Icon(Icons.chevron_right, color: colorScheme.fuelStationSwitcherBtnForegroundColor)),
    );
  }

  Widget _modalBottomSheetBuilder(context) {
    fuelStationType = widget.fuelStationType;
    LogUtil.debug(_tag, '_modalBottomSheetBuilder invoked');
    return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
      return ListView(padding: const EdgeInsets.all(15), children: [
        ListTile(
            leading:
                Icon(Icons.local_gas_station_rounded, size: 35, color: colorScheme.fuelStationSwitcherWidgetTextColor),
            title: Text('Change Fuel Station',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.fuelStationSwitcherWidgetTextColor))),
        Card(
            surfaceTintColor: colorScheme.fuelStationSwitcherWidgetBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: RadioListTile<FuelStationType>(
                selected: FuelStationType.nearby == fuelStationType,
                value: FuelStationType.nearby,
                activeColor: colorScheme.fuelStationSwitcherWidgetTextColor,
                title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Nearby Fuel Stations',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: colorScheme.fuelStationSwitcherWidgetTextColor)),
                  Icon(Icons.near_me, color: colorScheme.fuelStationSwitcherWidgetTextColor, size: 25)
                ]),
                groupValue: fuelStationType,
                onChanged: (changedCat) {
                  mystate(() {
                    fuelStationType = FuelStationType.nearby;
                  });
                })),
        Card(
            surfaceTintColor: colorScheme.fuelStationSwitcherWidgetBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: RadioListTile<FuelStationType>(
                selected: FuelStationType.favourite == fuelStationType,
                value: FuelStationType.favourite,
                activeColor: colorScheme.fuelStationSwitcherWidgetTextColor,
                title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Favourite Fuel Stations',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: colorScheme.fuelStationSwitcherWidgetTextColor)),
                  Icon(Icons.favorite, color: colorScheme.fuelStationSwitcherWidgetTextColor, size: 25)
                ]),
                groupValue: fuelStationType,
                onChanged: (changedCat) {
                  mystate(() {
                    fuelStationType = FuelStationType.favourite;
                  });
                })),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: colorScheme.fuelStationSwitcherWidgetTextColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                Navigator.pop(context);
                updateSelectedFuelStation();
              },
              child: Text('Apply', style: TextStyle(color: colorScheme.fuelStationSwitcherWidgetButtonTextColor)))
        ])
      ]);
    });
  }

  updateSelectedFuelStation() {
    setState(() {
      if (fuelStationType != null) {
        widget.onChangeCallback(fuelStationType);
      } else {
        LogUtil.debug(_tag, 'fuelStationType found as null');
      }
    });
  }
}
