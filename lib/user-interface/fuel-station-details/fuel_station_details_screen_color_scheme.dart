import 'package:flutter/material.dart';

class FuelStationDetailsScreenColorScheme {
  late Color backgroundColor;
  late Color fuelStationTitleTextColor;
  late Color fuelStationDetailsTextColor;


  FuelStationDetailsScreenColorScheme(final ThemeData themeData) {
    backgroundColor = const Color(0xFFF0EDFF);
    fuelStationTitleTextColor = themeData.primaryColor;
    fuelStationDetailsTextColor = themeData.primaryColor;
  }
}