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
import 'package:pumped_end_device/util/log_util.dart';

class UpdateTile extends StatelessWidget {
  static const _tag = 'UpdateTile';
  final UpdateTileData _updateTileData;
  const UpdateTile(this._updateTileData, {Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, UpdateHistoryDetailsScreen.routeName, arguments: _updateTileData);
          LogUtil.debug(_tag, 'Tapped Item');
        },
        child: Card(
          color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 8, right: 25),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${_updateTileData.updateType.updateTypeReadableName} updates',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.indigo)),
                    const Icon(Icons.more_horiz)
                  ])),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0, bottom: 20, right: 25, top: 8),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Card(
                        elevation: 2,
                        color: const Color(0xFF3F51B5),
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(children: [
                              Text('${_updateTileData.success}',
                                  style:
                                      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              const Text('Success',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white))
                            ]))),
                    Card(
                        elevation: 2,
                        color: const Color(0xFFEB5D63),
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(children: [
                              Text('${_updateTileData.failure}',
                                  style:
                                      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              const Text('Failed ',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white))
                            ]))),
                    Card(
                        elevation: 2,
                        color: const Color(0xFFABA9BB),
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(children: [
                              Text('${_updateTileData.pending}',
                                  style:
                                      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              const Text('Pending',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white))
                            ])))
                  ]))
            ])));
  }
}
