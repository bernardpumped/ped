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

class NoFavouriteStationsWidget extends StatelessWidget {
  const NoFavouriteStationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: const <Widget>[
          SizedBox(height: 120),
          Text('No Favourites',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          SizedBox(height: 20),
          Text.rich(
              TextSpan(children: [
                TextSpan(text: "Tap on the favourite ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                WidgetSpan(child: Icon(Icons.favorite_outline, size: 24)),
                TextSpan(
                    text: " icon in Fuel Station details to add fuel station to favourites.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal))
              ]),
              textAlign: TextAlign.center)
        ]));
  }
}
