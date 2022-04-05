import 'package:flutter/material.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/fuel-station-screen-color-scheme.dart';

class FuelStationTypeSwitcherWidget extends StatelessWidget {
  final String labelText;
  FuelStationTypeSwitcherWidget({Key? key, required this.labelText}) : super(key: key);

  final FuelStationsScreenColorScheme colorScheme = getIt.get<FuelStationsScreenColorScheme>(instanceName: fsScreenColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    return Chip(
        elevation: 5,
        backgroundColor: colorScheme.fuelTypeSwitcherBtnBackgroundColor,
        avatar: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.near_me, color: colorScheme.fuelTypeSwitcherBtnForegroundColor)),
        label: Text(labelText),
        labelPadding: const EdgeInsets.all(3),
        labelStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: colorScheme.fuelTypeSwitcherBtnForegroundColor),
        onDeleted: () {},
        deleteIcon: Icon(Icons.chevron_right, color: colorScheme.fuelTypeSwitcherBtnForegroundColor));
  }
}