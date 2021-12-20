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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_item_widget_colors.dart';

class UpdateHistoryUpdateFuelStationFeatureItemWidget extends StatelessWidget {
  final valueType;
  final originalValue;
  final updateValue;
  final Map<String, dynamic> serverExceptions;
  final recordLevelExceptions;

  const UpdateHistoryUpdateFuelStationFeatureItemWidget(
      {Key key,
      this.valueType,
      this.originalValue,
      this.updateValue,
      this.serverExceptions,
      this.recordLevelExceptions})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final String featureType = valueType;
    final String addRemove = updateValue ? 'Added' : 'Removed';
    final String updateStatus = _getUpdateResult();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.all(2),
      color: UpdateHistoryItemWidgetColors.updateItemColor,
      child: Container(
          padding: EdgeInsets.all(5),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                      child: Text(featureType,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: UpdateHistoryItemWidgetColors.updateTypeTxtColor)))),
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(addRemove,
                          style: TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateValuesTxtColor))))
            ]),
            Row(children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                      child: Text('Status',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: UpdateHistoryItemWidgetColors.updateValuesTxtColor)))),
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('$updateStatus',
                          style: TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateStatusTxtColor))))
            ])
          ])),
    );
  }

  String _getUpdateResult() {
    if (serverExceptions == null || serverExceptions.length == 0) {
      if (recordLevelExceptions == null || recordLevelExceptions.length == 0) {
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
