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
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/update-history/model/update_tile_data.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/update_history_details_screen.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UpdateTile extends StatelessWidget {
  static const _tag = 'UpdateTile';
  final UpdateTileData _updateTileData;
  const UpdateTile(this._updateTileData, {Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.background;
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, UpdateHistoryDetailsScreen.routeName, arguments: _updateTileData);
          LogUtil.debug(_tag, 'Tapped Item');
        },
        child: Card(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 8, right: 25),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${_updateTileData.updateType.updateTypeReadableName} updates',
                    style: Theme.of(context).textTheme.titleSmall,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                const Icon(Icons.more_horiz)
              ])),
          Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 20, right: 25, top: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.primary,
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: [
                          Text('${_updateTileData.success}',
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: bgColor),
                              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                          Text('Success', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: bgColor),
                              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                        ]))),
                Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.error,
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: [
                          Text('${_updateTileData.failure}',
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: bgColor),
                              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                          Text(' Failed  ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: bgColor),
                              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                        ]))),
                Card(
                    elevation: 2,
                    color: Theme.of(context).primaryColorLight,
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: [
                          Text('${_updateTileData.pending}',
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: bgColor),
                              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                          Text('Pending', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: bgColor),
                              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                        ])))
              ]))
        ])));
  }
}
