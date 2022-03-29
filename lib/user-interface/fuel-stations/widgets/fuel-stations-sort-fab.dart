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
import 'package:pumped_end_device/util/log_util.dart';

import 'fab/expandable-fab-action-button.dart';
import 'fab/expandable-fab.dart';

class FuelStationsSortFab extends StatelessWidget {
  static const _tag = 'FuelStationsSortFab';
  const FuelStationsSortFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
        distance: 100.0,
        children: [
          ExpandableFabActionButton(
              onPressed: () => _showAction(context, 0),
              icon: const Icon(Icons.local_offer, color: Colors.white), label: 'Offers'),
          ExpandableFabActionButton(
              onPressed: () => _showAction(context, 1),
              icon: const Icon(Icons.navigation, color: Colors.white), label: 'Distance'),
          ExpandableFabActionButton(
              onPressed: () => _showAction(context, 2),
              icon: const Icon(Icons.monetization_on, color: Colors.white), label: 'Price'),
          ExpandableFabActionButton(
              onPressed: () => _showAction(context, 2),
              icon: const Icon(Icons.label, color: Colors.white), label: 'Brand')]);
  }

  _showAction(BuildContext context, int i) {
    LogUtil.debug(_tag, 'Do Something : $i');
  }
}