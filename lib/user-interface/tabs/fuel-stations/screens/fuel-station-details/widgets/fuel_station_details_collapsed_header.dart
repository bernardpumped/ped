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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/image_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';

class FuelStationDetailsCollapsedHeader extends StatelessWidget {
  final FuelStation fuelStation;

  const FuelStationDetailsCollapsedHeader({Key? key, required this.fuelStation}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    String headerText;
    if (fuelStation.fuelStationAddress.locality != null) {
      headerText = '${fuelStation.fuelStationName} ${fuelStation.fuelStationAddress.locality}';
    } else {
      headerText = fuelStation.fuelStationName;
    }
    return Row(children: [
      ImageWidget(imageUrl: fuelStation.merchantLogoUrl, width: 50, height: 50, padding: const EdgeInsets.only(right: 15)),
      Text(headerText, style: const TextStyle(fontSize: 19, color: Colors.black87, fontFamily: 'SF-Pro-Display'))
    ]);
  }
}
