/*
 *     Copyright (c) 2021.
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';

class NoNearByStationsWidget extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Text('No Nearby Stations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black54),
              textAlign: TextAlign.center),
          SizedBox(height: 20),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "Sorry your neighbourhood not yet covered by Pumped. We have informed Pumped admin.\n",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
                TextSpan(
                    text: "\nYou can refine your Search Options. Tap on ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
                WidgetSpan(
                    child: PumpedIcons.settingsIcon_black54Size24),
                TextSpan(
                    text: " icon on bottom bar, to customize search.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54))
              ]))
        ]));
  }
}
