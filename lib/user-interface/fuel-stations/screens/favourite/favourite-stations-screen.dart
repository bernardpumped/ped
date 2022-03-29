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
import 'package:pumped_end_device/user-interface/fuel-stations/widgets/fuel-stations-sort-fab.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav-drawer.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_text_widget.dart';

class FavouriteStationsScreen extends StatefulWidget {
  static const routeName = '/favourite-stations';
  const FavouriteStationsScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteStationsScreen> createState() => _FavouriteStationsScreenState();
}

class _FavouriteStationsScreenState extends State<FavouriteStationsScreen> {
  static const _tag = 'FavouriteStationsScreen';

  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: false,
          title: const ApplicationTitleTextWidget()),
      drawer: const NavDrawer(),
      body: _drawBody(),
      floatingActionButton: const FuelStationsSortFab());

  _drawBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 5.0, left: 20, right: 20),
              // child: FuelStationFuelTypeWidget(fuelStationChipTitle: 'Favourite Fuel', fuelTypeChipTitle: 'Unleaded 91', fuelTypeSwitcherData: null)
              child: Container()
          )]);
  }
}