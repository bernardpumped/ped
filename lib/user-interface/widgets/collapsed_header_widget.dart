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
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_logo_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class CollapsedHeaderWidget extends StatelessWidget {
  final FuelStation fuelStation;

  const CollapsedHeaderWidget({Key? key, required this.fuelStation}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    String headerText;
    if (fuelStation.fuelStationAddress.locality != null) {
      headerText = '${fuelStation.fuelStationName} ${fuelStation.fuelStationAddress.locality}';
    } else {
      headerText = fuelStation.fuelStationName;
    }
    headerText = headerText.toTitleCase();
    return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(children: [
          FuelStationLogoWidget(width: 55, height: 55, image: NetworkImage(fuelStation.merchantLogoUrl)),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(headerText,
                      style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis)))
        ]));
  }
}
