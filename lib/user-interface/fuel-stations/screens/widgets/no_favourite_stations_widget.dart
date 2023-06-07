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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';

class NoFavouriteStationsWidget extends StatelessWidget {
  const NoFavouriteStationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: <Widget>[
          const SizedBox(height: 120),
          Text('No Favourites', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,
              textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
          const SizedBox(height: 20),
          Text.rich(
              TextSpan(children: [
                TextSpan(text: "Tap on the favourite ", style: Theme.of(context).textTheme.headlineSmall),
                const WidgetSpan(child: Icon(Icons.favorite_outline, size: 24)),
                TextSpan(
                    text: " icon in Fuel Station details to add fuel station to favourites.",
                    style: Theme.of(context).textTheme.headlineSmall)
              ]),
              textAlign: TextAlign.center)
        ]));
  }
}
