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

class UpdateHistoryDetailsAddressItemWidget extends StatelessWidget {
  final String valueType;
  final dynamic originalValue;
  final dynamic updateValue;
  final Map<String, dynamic>? serverExceptions;
  final List<dynamic>? recordLevelExceptions;

  const UpdateHistoryDetailsAddressItemWidget(
      {Key? key,
      required this.valueType,
      this.originalValue,
      this.updateValue,
      this.serverExceptions,
      this.recordLevelExceptions})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final String addressComponent = valueType;
    final String addressOriginalValue = (originalValue == null || originalValue == '') ? '----' : originalValue;
    final String addressUpdatedValue = updateValue;
    final String addressUpdateResult = _getUpdateResult();
    return Card(
        margin: const EdgeInsets.all(2),
        child: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('Address Component', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text(addressComponent, style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('Old Address', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text(addressOriginalValue, style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('New Address', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text(addressUpdatedValue, style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 12),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('Status', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text(addressUpdateResult, style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ]))
        ]));
  }

  String _getUpdateResult() {
    if (serverExceptions == null || serverExceptions!.isEmpty) {
      if (recordLevelExceptions == null || recordLevelExceptions!.isEmpty) {
        return 'Success';
      }
      return _getTranslatedUpdateResult();
    } else {
      return 'Failed';
    }
  }

  String _getTranslatedUpdateResult() {
    return 'Failed';
  }
}
