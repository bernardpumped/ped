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
import 'package:intl/intl.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_history_details_address_item_widget.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_history_details_feature_item_widget.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_history_details_operating_time_item_widget.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_history_details_price_item_widget.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_history_details_suggest_edit_item_widget.dart';

class UpdateHistoryDetailsItemWidget extends StatefulWidget {
  final UpdateHistory updateHistory;
  const UpdateHistoryDetailsItemWidget(this.updateHistory, {Key? key}) : super(key: key);

  @override
  State<UpdateHistoryDetailsItemWidget> createState() => _UpdateHistoryDetailsItemWidgetState();
}

class _UpdateHistoryDetailsItemWidgetState extends State<UpdateHistoryDetailsItemWidget> {
  var updateDateFormatter = DateFormat('dd-MMM-yyyy HH:mm');

  @override
  Widget build(final BuildContext context) {
    final String responseCode = widget.updateHistory.responseCode;
    final String fuelStation = widget.updateHistory.fuelStation;
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.updateHistory.updateEpoch);
    // TODO Additional logic here, as not all SUCCESS means success. Take care of overall exception codes.
    final Icon updateStatusIconCode = responseCode == "SUCCESS"
        ? _successUpdateStatusIcon
        : responseCode == "PENDING"
            ? _inProgressUpdateStatusIcon
            : _failedUpdateStatusIcon;
    return Card(
        // color: Colors.white,
        // surfaceTintColor: Colors.white,
        color: const Color(0xFFF9F8FF),
        surfaceTintColor: const Color(0xFFF9F8FF),
        // color: Color(0xFFD8ECEB),
        // surfaceTintColor: Color(0xFFD8ECEB),
        elevation: 1.5,
        child: Container(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
            child: Column(children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 10,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 8),
                              child: Text(fuelStation,
                                  style:
                                      const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.indigo))),
                          Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 5),
                              child: Text(updateDateFormatter.format(dateTime),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.indigo)))
                        ])),
                    Expanded(flex: 2, child: updateStatusIconCode)
                  ]),
              _getUpdateDetails(widget.updateHistory)
            ])));
  }

  static const _successUpdateStatusIcon = Icon(Icons.check, color: Colors.indigo, size: 30);
  static const _inProgressUpdateStatusIcon = Icon(Icons.sync, color: Colors.indigo, size: 30);
  static const _failedUpdateStatusIcon = Icon(Icons.error_outline, color: Colors.indigo, size: 30);

  Widget _getUpdateDetails(final UpdateHistory updateHistory) {
    List<Widget> children = [];
    final String updateType = updateHistory.updateType;
    final Map<String, dynamic> originalValues = updateHistory.originalValues;
    final Map<String, dynamic> updateValues = updateHistory.updateValues;
    final Map<String, dynamic>? invalidArguments = updateHistory.invalidArguments;
    final Map<String, dynamic>? recordLevelExceptionCodes = updateHistory.recordLevelExceptionCodes;
    originalValues.forEach((originalValueType, originalValue) {
      var updateValue = updateValues[originalValueType];
      var recordLevelExceptions =
          recordLevelExceptionCodes != null ? recordLevelExceptionCodes[originalValueType] ?? [] : [];
      if (updateType == UpdateType.operatingTime.updateTypeName) {
        children.add(UpdateHistoryDetailsOperatingTimeItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelException: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else if (updateType == UpdateType.price.updateTypeName) {
        children.add(UpdateHistoryDetailsPriceItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else if (updateType == UpdateType.suggestEdit.updateTypeName) {
        children.add(UpdateHistoryDetailsSuggestEditItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else if (updateType == UpdateType.fuelStationFeatures.updateTypeName) {
        children.add(UpdateHistoryDetailsFeatureItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else {
        children.add(UpdateHistoryDetailsAddressItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      }
    });
    return Column(children: children);
  }
}
