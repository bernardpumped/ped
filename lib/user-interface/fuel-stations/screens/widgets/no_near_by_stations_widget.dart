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

class NoNearByStationsWidget extends StatelessWidget {
  const NoNearByStationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final FuelStationsScreenColorScheme colorScheme =
        getIt.get<FuelStationsScreenColorScheme>(instanceName: fsScreenColorSchemeName);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('No Nearby Stations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colorScheme.noDataScreenTextColor),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "Sorry your neighbourhood not yet covered by Pumped. We have informed Pumped admin.\n",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colorScheme.noDataScreenTextColor)),
                TextSpan(
                    text: "\nYou can refine your Search Options. Tap on ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colorScheme.noDataScreenTextColor)),
                const WidgetSpan(child: Icon(Icons.settings, color: Colors.indigo, size: 24)),
                TextSpan(
                    text: " icon on bottom bar, to customize search.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colorScheme.noDataScreenTextColor))
              ]))
        ]);
  }
}
