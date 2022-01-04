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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoFavouriteStationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(children: <Widget>[
      SizedBox(height: 120),
      Text(
        'No Favourites',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 20),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Tap on the bookmark",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            WidgetSpan(
              child: Icon(
                Icons.bookmark_border,
                size: 18,
                color: Colors.black54,
              ),
            ),
            TextSpan(
              text: " icon in Fuel Station details to add fuel station to favourites.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
          ],
        ),
      ),
    ]));
  }
}
