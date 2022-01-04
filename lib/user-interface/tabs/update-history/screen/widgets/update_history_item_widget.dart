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
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update_type.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_item_widget_colors.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_suggest_edit_item.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_update_address_item_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_update_fuel_quote_item.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_update_fuel_station_feature_item_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_update_operating_time_item_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_update_phone_number_item_widget.dart';
import 'package:pumped_end_device/models/update_history.dart';

class UpdateHistoryItemWidget extends StatefulWidget {
  final UpdateHistory updateHistory;
  UpdateHistoryItemWidget(this.updateHistory);

  @override
  _UpdateHistoryItemWidgetState createState() => _UpdateHistoryItemWidgetState();
}

class _UpdateHistoryItemWidgetState extends State<UpdateHistoryItemWidget> {
  var updateDateFormatter = new DateFormat('dd-MMM-yyyy HH:mm');

  @override
  Widget build(final BuildContext context) {
    final String updateType = widget.updateHistory.updateType;
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
      color: UpdateHistoryItemWidgetColors.updateCardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
        child: Column(children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: _getUpdateTypeIcon(updateType),
                    flex: 2),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 6),
                          child: Text(fuelStation,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: UpdateHistoryItemWidgetColors.stationNameColor))),
                      Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 5),
                          child: Text("${updateDateFormatter.format(dateTime)}",
                              style: TextStyle(fontSize: 16, color: UpdateHistoryItemWidgetColors.updateDateIconColor)))
                    ]),
                    flex: 10),
                Expanded(child: updateStatusIconCode, flex: 2)
              ]),
          _getUpdateDetails(widget.updateHistory)
        ]),
      ),
    );
  }

  static const _operatingTimeUpdateIcon = const Icon(IconData(IconCodes.operating_time_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);
  static const _fuelPriceUpdateIcon = const Icon(IconData(IconCodes.fuel_price_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);
  static const _suggestEditIcon = const Icon(IconData(IconCodes.suggest_edit_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);
  static const _phoneNumUpdateIcon = const Icon(IconData(IconCodes.phone_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);
  static const _featuresUpdateIcon = const Icon(IconData(IconCodes.features_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);
  static const _addressUpdateIcon = const Icon(IconData(IconCodes.address_details_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);

  static const _successUpdateStatusIcon = const Icon(IconData(IconCodes.success_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);
  static const _inProgressUpdateStatusIcon = const Icon(IconData(IconCodes.in_progress_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);
  static const _failedUpdateStatusIcon = const Icon(IconData(IconCodes.failed_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true), color: UpdateHistoryItemWidgetColors.updateTypeIconColor, size: 35);

  Icon _getUpdateTypeIcon(final String updateType) {
    if (updateType == UpdateType.OPERATING_TIME.updateTypeName) {
      return _operatingTimeUpdateIcon;
    } else if (updateType == UpdateType.PRICE.updateTypeName) {
      return _fuelPriceUpdateIcon;
    } else if (updateType == UpdateType.SUGGEST_EDIT.updateTypeName) {
      return _suggestEditIcon;
    } else if (updateType == UpdateType.PHONE_NUMBER.updateTypeName) {
      return _phoneNumUpdateIcon;
    } else if (updateType == UpdateType.FUEL_STATION_FEATURES.updateTypeName) {
      return _featuresUpdateIcon;
    } else {
      return _addressUpdateIcon;
    }
  }

  Widget _getUpdateDetails(final UpdateHistory updateHistory) {
    List<Widget> children = [];
    final String updateType = updateHistory.updateType;
    final Map<String, dynamic> originalValues = updateHistory.originalValues;
    final Map<String, dynamic> updateValues = updateHistory.updateValues;
    final Map<String, dynamic> invalidArguments = updateHistory.invalidArguments;
    final Map<String, dynamic> recordLevelExceptionCodes = updateHistory.recordLevelExceptionCodes;
    originalValues.forEach((originalValueType, originalValue) {
      var updateValue = updateValues[originalValueType];
      var recordLevelExceptions = recordLevelExceptionCodes != null ? recordLevelExceptionCodes[originalValueType] : [];
      if (updateType == UpdateType.OPERATING_TIME.updateTypeName) {
        children.add(UpdateHistoryUpdateOperatingTimeItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelException: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else if (updateType == UpdateType.PRICE.updateTypeName) {
        children.add(UpdateHistoryUpdateFuelQuoteItem(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else if (updateType == UpdateType.SUGGEST_EDIT.updateTypeName) {
        children.add(UpdateHistorySuggestEditItem(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else if (updateType == UpdateType.PHONE_NUMBER.updateTypeName) {
        children.add(UpdateHistoryUpdatePhoneNumberItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else if (updateType == UpdateType.FUEL_STATION_FEATURES.updateTypeName) {
        children.add(UpdateHistoryUpdateFuelStationFeatureItemWidget(
            valueType: originalValueType,
            originalValue: originalValue,
            updateValue: updateValue,
            recordLevelExceptions: recordLevelExceptions,
            serverExceptions: invalidArguments));
      } else {
        children.add(UpdateHistoryUpdateAddressItemWidget(
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
