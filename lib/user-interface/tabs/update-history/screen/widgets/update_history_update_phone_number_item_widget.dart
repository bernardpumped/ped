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
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_item_widget_colors.dart';

class UpdateHistoryUpdatePhoneNumberItemWidget extends StatelessWidget {
  final String valueType;
  final dynamic originalValue;
  final dynamic updateValue;
  final Map<String, dynamic> serverExceptions;
  final List<dynamic> recordLevelExceptions;

  const UpdateHistoryUpdatePhoneNumberItemWidget(
      {Key key,
      this.valueType,
      this.originalValue,
      this.updateValue,
      this.serverExceptions,
      this.recordLevelExceptions})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final String phoneType = valueType;
    final String originalPhoneNumber = originalValue ?? '----';
    final String updatedPhoneNumber = updateValue;
    final updateStatus = _getUpdateResult();
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: const EdgeInsets.all(2),
        color: UpdateHistoryItemWidgetColors.updateItemColor,
        child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                const Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                        child: Text('Phone Type',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: UpdateHistoryItemWidgetColors.updateTypeTxtColor)))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(phoneType,
                            style: const TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateValuesTxtColor))))
              ]),
              Row(children: <Widget>[
                const Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                        child: Text('Old Value',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: UpdateHistoryItemWidgetColors.updateValuesTxtColor)))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(originalPhoneNumber,
                            style: const TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateValuesTxtColor))))
              ]),
              Row(children: <Widget>[
                const Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                        child: Text('New Value',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: UpdateHistoryItemWidgetColors.updateValuesTxtColor)))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(updatedPhoneNumber,
                            style: const TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateValuesTxtColor))))
              ]),
              Row(children: <Widget>[
                const Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                        child: Text('Status',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: UpdateHistoryItemWidgetColors.updateValuesTxtColor)))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(updateStatus,
                            style: const TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateStatusTxtColor))))
              ])
            ])));
  }

  String _getUpdateResult() {
    if (serverExceptions == null || serverExceptions.isEmpty) {
      if (recordLevelExceptions == null || recordLevelExceptions.isEmpty) {
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
