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

class NoNearByStationsWidget extends StatelessWidget {
  const NoNearByStationsWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('No Nearby Stations', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: "Sorry your neighbourhood not yet covered by Pumped. We have informed Pumped admin.\n",
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                      text: "\nYou can refine your Search Options. Tap on Settings ",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const WidgetSpan(child: Icon(Icons.settings, size: 24)),
                  TextSpan(
                      text: " icon in the navigation bar, to customize search.", style: Theme.of(context).textTheme.bodyLarge)
                ]), textScaler: TextScaler.linear(PedTextScaler.of<TextScalingFactor>(context)!.scaleFactor)),
          )
        ]);
  }
}
