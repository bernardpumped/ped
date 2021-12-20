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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/dto/operating_time_update_exception_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/operating_time_range.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_item_widget_colors.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';

class UpdateHistoryUpdateOperatingTimeItemWidget extends StatelessWidget {
  final valueType;
  final originalValue;
  final updateValue;
  final Map<String, dynamic> serverExceptions;
  final List<dynamic> recordLevelException;

  const UpdateHistoryUpdateOperatingTimeItemWidget(
      {Key key, this.valueType, this.originalValue, this.updateValue, this.serverExceptions, this.recordLevelException})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final String dayOfWeek = valueType;
    final OperatingHours originalOperatingHour =
        originalValue != null ? OperatingHours.fromJson(jsonDecode(originalValue)) : null;
    final OperatingHours updatedOperatingHour =
        updateValue != null ? OperatingHours.fromJson(jsonDecode(updateValue)) : null;
    String originalTimeRange = OperatingTimeRange.getStringRepresentation(originalOperatingHour);
    String updatedTimeRange;
    if (updatedOperatingHour != null) {
      updatedTimeRange = OperatingTimeRange.getStringRepresentation(updatedOperatingHour);
    }
    final String updateResult = _getUpdateResult();
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.all(2),
        color: UpdateHistoryItemWidgetColors.updateItemColor,
        child: Container(
            padding: EdgeInsets.all(5),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                        child: Text('Day of Week',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: UpdateHistoryItemWidgetColors.updateTypeTxtColor)))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(dayOfWeek,
                            style: TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateValuesTxtColor))))
              ]),
              Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 12),
                        child: Text('Old Range',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: UpdateHistoryItemWidgetColors.updateValuesTxtColor)))),
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('$originalTimeRange',
                            style: TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateValuesTxtColor))))
              ]),
              Row(children: <Widget>[
                Expanded(
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
                        padding: EdgeInsets.all(4),
                        child: Text('$updatedTimeRange',
                            style: TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateValuesTxtColor))))
              ]),
              Row(children: <Widget>[
                Expanded(
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
                        padding: EdgeInsets.all(4),
                        child: Text('$updateResult',
                            maxLines: 3,
                            style: TextStyle(fontSize: 15, color: UpdateHistoryItemWidgetColors.updateStatusTxtColor))))
              ]),
              _getUpdateResult() == 'Failed'
                  ? Row(children: <Widget>[
                      Expanded(
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
                              padding: EdgeInsets.all(4),
                              child: Text('${_getTranslatedUpdateResult()}',
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 15, color: UpdateHistoryItemWidgetColors.updateStatusTxtColor))))
                    ])
                  : SizedBox(height: 0)
            ])));
  }

  String _getUpdateResult() {
    if (serverExceptions == null || serverExceptions.length == 0) {
      if (recordLevelException == null || recordLevelException.length == 0) {
        return 'Success';
      }
    }
    return 'Failed';
  }

  String _getTranslatedUpdateResult() {
    List<String> translatedResultCode = [];
    for (final String resultCode in recordLevelException) {
      switch (resultCode) {
        case OperatingTimeUpdateExceptionCodes.TIME_NOT_IN_RANGE:
          translatedResultCode.add('TIme not in range');
          break;
        case OperatingTimeUpdateExceptionCodes.VERSION_MIS_MATCH:
          translatedResultCode.add('Stale update, please refresh');
          break;
        case OperatingTimeUpdateExceptionCodes.TIME_NOT_CHANGED:
          translatedResultCode.add('Same as old time');
          break;
        case OperatingTimeUpdateExceptionCodes.INVALID_PARAM_FOR_OPERATING_TIME:
          translatedResultCode.add('Invalid time');
          break;
        case OperatingTimeUpdateExceptionCodes.UPDATING_OPERATING_TIME_FOR_MULTIPLE_FUEL_STATIONS:
          translatedResultCode.add('Can update one station at a time');
          break;
        case OperatingTimeUpdateExceptionCodes.NO_OPERATING_TIMES_PROVIDED:
          translatedResultCode.add('No updated value provided');
          break;
        case OperatingTimeUpdateExceptionCodes.OPERATING_TIME_NOT_CROWD_SOURCED:
          translatedResultCode.add('Cannot change operating time not crowd sourced');
          break;
        case OperatingTimeUpdateExceptionCodes.OPERATING_TIME_FUEL_AUTHORITY_SOURCE:
          translatedResultCode.add('Cannot change operating time provided by Fuel Authority');
          break;
        case OperatingTimeUpdateExceptionCodes.OPERATING_TIME_GOOGLE_SOURCE:
          translatedResultCode.add('Cannot change operating time provided by Google');
          break;
        case OperatingTimeUpdateExceptionCodes.OPERATING_TIME_MERCHANT_SOURCE:
          translatedResultCode.add('Cannot change operating time provided by merchant');
          break;
      }
    }
    if (translatedResultCode.length == 0) {
      return 'Failed';
    } else {
      return translatedResultCode.join(', ');
    }
  }
}