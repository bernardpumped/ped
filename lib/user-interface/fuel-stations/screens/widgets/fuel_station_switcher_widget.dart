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
import 'package:pumped_end_device/util/app_theme.dart';
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
            backgroundColor: AppTheme.modalBottomSheetBg(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            context: context,
            builder: _modalBottomSheetBuilder);
      },
      child: Chip(
          elevation: 5,
          avatar: Icon(iconData),
          label: Text(labelText),
          labelPadding: const EdgeInsets.all(3),
          labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).backgroundColor),
          onDeleted: () {
            showModalBottomSheet(
                backgroundColor: AppTheme.modalBottomSheetBg(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                context: context,
                builder: _modalBottomSheetBuilder);
          },
          deleteIcon: Icon(Icons.chevron_right, color: Theme.of(context).backgroundColor)),
    );
  }

  Widget _modalBottomSheetBuilder(context) {
    fuelStationType = widget.fuelStationType;
    LogUtil.debug(_tag, '_modalBottomSheetBuilder invoked');
    return StatefulBuilder(builder: (final BuildContext context, final StateSetter mystate) {
      return ListView(padding: const EdgeInsets.all(15), children: [
        ListTile(
            leading: const Icon(Icons.local_gas_station_rounded, size: 30),
            title: Text('Change Fuel Station', style: Theme.of(context).textTheme.headline6)),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: RadioListTile<FuelStationType>(
                selected: FuelStationType.nearby == fuelStationType,
                value: FuelStationType.nearby,
                title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Nearby Fuel Stations', style: Theme.of(context).textTheme.subtitle2),
                  const Icon(Icons.near_me, size: 25)
                ]),
                groupValue: fuelStationType,
                onChanged: (changedCat) {
                  mystate(() {
                    fuelStationType = FuelStationType.nearby;
                  });
                })),
        Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: RadioListTile<FuelStationType>(
                selected: FuelStationType.favourite == fuelStationType,
                value: FuelStationType.favourite,
                title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Favourite Fuel Stations', style: Theme.of(context).textTheme.subtitle2),
                  const Icon(Icons.favorite, size: 25)
                ]),
                groupValue: fuelStationType,
                onChanged: (changedCat) {
                  mystate(() {
                    fuelStationType = FuelStationType.favourite;
                  });
                })),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          const SizedBox(width: 40),
          ElevatedButton(
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                Navigator.pop(context);
                updateSelectedFuelStation();
              },
              child: const Text('Apply'))
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
