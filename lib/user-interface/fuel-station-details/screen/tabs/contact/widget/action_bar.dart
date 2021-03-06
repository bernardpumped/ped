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
import 'package:pumped_end_device/user-interface/fuel-station-details/fuel_station_details_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/directions_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/favorite_fuel_station_bookmark.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/phone_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/rate_widget.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class ActionBar extends StatelessWidget {
  final FuelStation fuelStation;
  final Function onFavouriteStatusChange;
  ActionBar({Key? key, required this.fuelStation, required this.onFavouriteStatusChange}) : super(key: key);

  final FuelStationDetailsScreenColorScheme colorScheme =
      getIt.get<FuelStationDetailsScreenColorScheme>(instanceName: fsDetailsScreenColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    final String? phone = DataUtils.isNotBlank(fuelStation.fuelStationAddress.phone1)
        ? fuelStation.fuelStationAddress.phone1
        : fuelStation.fuelStationAddress.phone2;
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 15, right: 12),
                    child: DirectionsWidget(
                        fuelStation.fuelStationAddress.latitude,
                        fuelStation.fuelStationAddress.longitude,
                        getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName))),
                (phone != null)
                    ? Padding(padding: const EdgeInsets.only(left: 12, right: 12), child: PhoneWidget(phone))
                    : const SizedBox(width: 0),
                Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: RateWidget(fuelStation.fuelStationAddress)),
                Padding(
                    padding: const EdgeInsets.only(left: 12, right: 15),
                    child: FavoriteFuelStationBookmark(fuelStation, onFavouriteStatusChange))
              ])),
    );
  }
}
