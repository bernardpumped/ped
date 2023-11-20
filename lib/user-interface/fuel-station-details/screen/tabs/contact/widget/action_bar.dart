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
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/directions_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/favorite_fuel_station_bookmark.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/hide_fuel_station_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/phone_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/rate_widget.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class ActionBar extends StatefulWidget {
  final FuelStation fuelStation;
  const ActionBar({super.key, required this.fuelStation});

  @override
  State<ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  @override
  Widget build(final BuildContext context) {
    final String? phone = DataUtils.isNotBlank(widget.fuelStation.fuelStationAddress.phone1)
        ? widget.fuelStation.fuelStationAddress.phone1
        : widget.fuelStation.fuelStationAddress.phone2;
    return Container(
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 15, right: 12),
                      child: DirectionsWidget(
                          widget.fuelStation.fuelStationAddress.latitude,
                          widget.fuelStation.fuelStationAddress.longitude,
                          getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName))),
                  (phone != null)
                      ? Padding(padding: const EdgeInsets.only(left: 12, right: 12), child: PhoneWidget(phone))
                      : const SizedBox(width: 0),
                  Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: RateWidget(widget.fuelStation.fuelStationAddress)),
                  Padding(
                      padding: const EdgeInsets.only(left: 12, right: 15),
                      child: FavoriteFuelStationBookmark(widget.fuelStation, () {
                        setState(() {});
                      })),
                  Padding(
                      padding: const EdgeInsets.only(left: 12, right: 15),
                      child: HideFuelStationWidget(widget.fuelStation, () {
                        setState(() {});
                      }))
                ])));
  }
}
