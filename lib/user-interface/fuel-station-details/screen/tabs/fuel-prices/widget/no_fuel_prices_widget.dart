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

class NoFuelPricesWidget extends StatelessWidget {
  const NoFuelPricesWidget({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text('No Fuel Prices',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500, color: Colors.indigo),
                  textAlign: TextAlign.center),
              Text(
                  "\n Click here if you'd appreciate this station providing accurate prices we'll let them know",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo),
                  textAlign: TextAlign.center),
              Text('\n Come back again soon.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo),
                  textAlign: TextAlign.center)
            ]));
  }

}