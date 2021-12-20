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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/update_history_dao.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/get_fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/post_operating_time_update.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/dto/operating_time_vo.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/model/request/get_fuel_station_operating_hrs_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/request/alter_operating_time_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/model/response/get_fuel_station_operating_hrs_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/alter_operating_time_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/response-parser/get_fuel_station_operating_hrs_response_parser.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/reponse-parser/alter_operating_time_response_parser.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_operating_time_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/save_undo_button_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

import 'edit_operating_time_line_item_widget.dart';

class EditOperatingTimeWidget extends StatefulWidget {
  final FuelStation _fuelStation;
  final String titleText;
  final Function setStateFunction;
  final Function widgetExpanded;
  final String widgetKey;
  final Icon leadingWidgetIcon;
  final bool cupertinoIcon;
  final bool lazyLoaded;

  EditOperatingTimeWidget(this._fuelStation, this.titleText, this.setStateFunction, this.widgetExpanded, this.widgetKey,
      this.leadingWidgetIcon, this.cupertinoIcon, this.lazyLoaded);

  @override
  _EditOperatingTimeWidgetState createState() => _EditOperatingTimeWidgetState();
}

class _EditOperatingTimeWidgetState extends State<EditOperatingTimeWidget> {
  static const _TAG = 'EditOperatingTimeWidget';
  bool _backendUpdateInProgress = false;
  Future<GetFuelStationOperatingHrsResponse> getFuelStationOperatingHrsResponseFuture;
  Map<String, OperatingHours> _updatedOperatingTimeMap = {};
  bool _onValueChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.lazyLoaded) {
      getFuelStationOperatingHrsResponseFuture = _getFuelStationOperatingHrsFuture();
    }
  }

  Future<GetFuelStationOperatingHrsResponse> _getFuelStationOperatingHrsFuture() async {
    final int stationId = widget._fuelStation.stationId;
    final String fuelStationSource = widget._fuelStation.getFuelStationSource();
    try {
      final GetFuelStationOperatingHrsRequest request = GetFuelStationOperatingHrsRequest(
          requestUuid: Uuid().v1(), fuelStationId: stationId, fuelStationSource: fuelStationSource);
      return await GetFuelStationOperatingHrs(GetFuelStationOperatingHrsResponseParser()).execute(request);
    } on Exception catch (e, s) {
      LogUtil.debug(_TAG, 'Exception occurred while calling GetFuelStationOperatingHrsNew.execute $s');
      return GetFuelStationOperatingHrsResponse(
          'CALL-EXCEPTION', s.toString(), {}, DateTime.now().millisecondsSinceEpoch, null);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).copyWith(backgroundColor: Colors.white);
    return Theme(
        data: theme,
        child: widget.lazyLoaded
            ? _buildOperatingHoursExpansionTileFromFuture()
            : _buildOperatingHoursExpansionTile(widget._fuelStation.fuelStationOperatingHrs));
  }

  Text _getTitle() {
    return Text(widget.titleText, style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500));
  }

  Widget _buildOperatingHoursExpansionTileFromFuture() {
    return FutureBuilder<GetFuelStationOperatingHrsResponse>(
        future: getFuelStationOperatingHrsResponseFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListTile(title: Text('Error Loading', style: TextStyle(color: Colors.red)));
          } else if (snapshot.hasData) {
            final GetFuelStationOperatingHrsResponse response = snapshot.data;
            if (response.responseCode != 'SUCCESS') {
              return ListTile(title: Text('Error Loading', style: TextStyle(color: Colors.red)));
            } else {
              widget._fuelStation.fuelStationOperatingHrs = response.fuelStationOperatingHrs;
              return _buildOperatingHoursExpansionTile(response.fuelStationOperatingHrs);
            }
          } else {
            return ListTile(leading: widget.leadingWidgetIcon, title: Text('Loading...'));
          }
        });
  }

  ExpansionTile _buildOperatingHoursExpansionTile(final FuelStationOperatingHrs fuelStationOperatingHrs) {
    return ExpansionTile(
        initiallyExpanded: widget.widgetExpanded(),
        leading : widget.leadingWidgetIcon,
        title: _getTitle(),
        key: PageStorageKey<String>(widget.widgetKey),
        children: _editOperatingHoursExpansionTileWidgetTree(fuelStationOperatingHrs),
        onExpansionChanged: (expanded) {
          setState(() {
            widget.setStateFunction(expanded);
          });
        });
  }

  List<Widget> _editOperatingHoursExpansionTileWidgetTree(final FuelStationOperatingHrs fuelStationOperatingHrs) {
    final List<Widget> columnContent = [];
    final List<String> daysOfWeek = DateTimeUtils.weekDayShortToLongName.keys.toList();
    fuelStationOperatingHrs.weeklyOperatingHrs.forEach((operatingHrs) {
      final OperatingHours updatedOperatingHrs = _updatedOperatingTimeMap[operatingHrs.dayOfWeek];
      daysOfWeek.remove(operatingHrs.dayOfWeek);
      columnContent.add(EditOperatingTimeLineItemWidget(operatingHrs, updatedOperatingHrs, undoOperatingTimeChange,
          onOperatingTimeRangeChanged, _backendUpdateInProgress));
    });
    daysOfWeek.forEach((dayOfWeek) {
      final OperatingHours operatingHours = OperatingHours(dayOfWeek: dayOfWeek, status: Status.unknown);
      final OperatingHours updatedOperatingHrs = _updatedOperatingTimeMap[dayOfWeek];
      columnContent.add(EditOperatingTimeLineItemWidget(operatingHours, updatedOperatingHrs, undoOperatingTimeChange,
          onOperatingTimeRangeChanged, _backendUpdateInProgress));
    });
    columnContent.add(Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: SaveUndoButtonWidget(
            onSave: onSaveAction,
            onCancel: onUndoAction,
            onValueChange: _onValueChanged,
            saveButtonDisabled: _backendUpdateInProgress,
            undoButtonDisabled: _backendUpdateInProgress)));
    return columnContent;
  }

  void onOperatingTimeRangeChanged(final Map<String, dynamic> operatingTimeParams, final String dayOfWeek) {
    setState(() {
      _onValueChanged = true;
      OperatingHours uot = _updatedOperatingTimeMap.remove(dayOfWeek);
      if (uot == null) {
        uot = new OperatingHours(dayOfWeek: dayOfWeek);
      }
      if (operatingTimeParams.containsKey('OPEN_HOUR')) {
        uot.openingHrs = operatingTimeParams['OPEN_HOUR'];
      }
      if (operatingTimeParams.containsKey('OPEN_MINS')) {
        uot.openingMins = operatingTimeParams['OPEN_MINS'];
      }
      if (operatingTimeParams.containsKey('CLOSING_HOUR')) {
        uot.closingHrs = operatingTimeParams['CLOSING_HOUR'];
      }
      if (operatingTimeParams.containsKey('CLOSING_MINS')) {
        uot.closingMins = operatingTimeParams['CLOSING_MINS'];
      }
      if (operatingTimeParams.containsKey('OPERATING_TIME_RANGE')) {
        uot.operatingTimeRange = operatingTimeParams['OPERATING_TIME_RANGE'];
      }
      if (uot.openingHrs == 0 && uot.openingMins == 0 && uot.closingHrs == 0 && uot.closingMins == 0) {
        uot.status = Status.closed;
      } else {
        if (uot.openingHrs == 0 && uot.openingMins == 0 && uot.closingHrs == 23 && uot.closingMins == 59) {
          uot.status = Status.open24Hrs;
        } else {
          uot.status = Status.open;
        }
      }
      _updatedOperatingTimeMap.putIfAbsent(dayOfWeek, () => uot);
    });
  }

  void onSaveAction() async {
    if (_updatedOperatingTimeMap.length > 0) {
      final Map<String, dynamic> updatedValues = {};
      _updatedOperatingTimeMap.forEach((day, operatingHour) {
        updatedValues.putIfAbsent(day, () => jsonEncode(operatingHour.toJson()));
      });
      final Map<String, OperatingHours> originalOperatingHoursMap = _getOriginalOperatingHoursMap();
      Map<String, dynamic> originalPathAndValues = {};
      _updatedOperatingTimeMap.forEach((day, operatingHour) {
        if (originalOperatingHoursMap.containsKey(day)) {
          originalPathAndValues.putIfAbsent(
              day,
              () =>
                  originalOperatingHoursMap[day] != null ? jsonEncode(originalOperatingHoursMap[day].toJson()) : null);
        }
      });
      final AlterOperatingTimeRequest request = new AlterOperatingTimeRequest(
          uuid: Uuid().v1(),
          fuelStationId: widget._fuelStation.stationId,
          featureType: 'FUEL-FILL',
          fuelStationSource: widget._fuelStation.isFaStation ? "F" : "G",
          authValidatorType: 'FIREBASE',
          identityProvider: 'FIREBASE',
          oauthToken: 'my-dummy-oauth-token',
          oauthTokenSecret: 'my-dummy-oauth-token-secret',
          operatingTimeVos: _getOperatingTimeVos(_updatedOperatingTimeMap));
      AlterOperatingTimeResponse response;
      try {
        lockInputs();
        response = await PostOperatingTimeUpdate(AlterOperatingTimeResponseParser()).execute(request);
      } on Exception catch (e, s) {
        LogUtil.debug(_TAG, 'Exception occurred while calling PostOperatingTimeUpdate.execute $s');
        response = AlterOperatingTimeResponse(
            responseCode: 'CALL-EXCEPTION',
            responseDetails: s.toString(),
            invalidArguments: {},
            responseEpoch: DateTime.now().millisecondsSinceEpoch,
            exceptionCodes: [],
            updateResult: {},
            fuelStationId: request.fuelStationId,
            fuelStationSource: request.fuelStationSource,
            updateEpoch: DateTime.now().millisecondsSinceEpoch,
            uuid: request.uuid,
            successfulUpdate: false);
      } finally {
        unlockInputs();
      }
      int updateHistoryPersistenceResult =
          await _persistUpdateHistory(request, response, originalPathAndValues, updatedValues);
      LogUtil.debug(_TAG, 'UpdateHistory::operatingTime successfully persisted $updateHistoryPersistenceResult');
      if (response.responseCode == 'SUCCESS') {
        WidgetUtils.showToastMessage(
            context, 'Updated Operating time notified to pumped team', Theme.of(context).primaryColor);
      } else {
        WidgetUtils.showToastMessage(context, 'Error notifying update to pumped team', Theme.of(context).primaryColor);
      }
      Navigator.pop(context, _getUpdateResponse(request, response, originalPathAndValues, updatedValues));
    }
  }

  Future<int> _persistUpdateHistory(final AlterOperatingTimeRequest request, final AlterOperatingTimeResponse response,
      final Map<String, dynamic> originalPathAndValues, final Map<String, dynamic> updatedValues) async {
    final UpdateHistory updateHistory = new UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: widget._fuelStation.fuelStationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: response.updateEpoch,
        updateType: UpdateType.OPERATING_TIME.updateTypeName,
        responseCode: response.responseCode,
        originalValues: originalPathAndValues,
        updateValues: updatedValues,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    final int updateHistoryPersistenceResult = await UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
    return updateHistoryPersistenceResult;
  }

  void lockInputs() {
    LogUtil.debug(_TAG, 'locking the inputs');
    setState(() {
      _backendUpdateInProgress = true;
    });
  }

  void unlockInputs() {
    LogUtil.debug(_TAG, 'unlocking the inputs');
    setState(() {
      // Ideally it should take backend response before clearing this.
      _updatedOperatingTimeMap = {};
      _backendUpdateInProgress = false;
      _onValueChanged = false;
    });
  }

  Map<String, OperatingHours> _getOriginalOperatingHoursMap() {
    final Map<String, OperatingHours> originalOperatingHoursMap = {};
    final List<String> daysOfWeek = DateTimeUtils.weekDayShortToLongName.keys.toList();
    if (widget._fuelStation.fuelStationOperatingHrs != null &&
        widget._fuelStation.fuelStationOperatingHrs.weeklyOperatingHrs != null) {
      widget._fuelStation.fuelStationOperatingHrs.weeklyOperatingHrs.forEach((operatingHour) {
        originalOperatingHoursMap.putIfAbsent(operatingHour.dayOfWeek, () => operatingHour);
        daysOfWeek.remove(operatingHour.dayOfWeek);
      });
    }
    daysOfWeek.forEach((dayOfWeek) {
      originalOperatingHoursMap.putIfAbsent(dayOfWeek, () => null);
    });
    return originalOperatingHoursMap;
  }

  void onUndoAction() {
    setState(() {
      _updatedOperatingTimeMap = {};
      _onValueChanged = false;
    });
  }

  void undoOperatingTimeChange(final String dayOfWeek) {
    setState(() {
      if (_updatedOperatingTimeMap.containsKey(dayOfWeek)) {
        _updatedOperatingTimeMap.remove(dayOfWeek);
      }
      if (_updatedOperatingTimeMap.length == 0) {
        _onValueChanged = false;
      }
    });
  }

  List<OperatingTimeVo> _getOperatingTimeVos(final Map<String, OperatingHours> updatedOperatingTimeMap) {
    List<OperatingTimeVo> operatingTimeVos = [];
    LogUtil.debug(_TAG, 'updatedOperatingTimeMap.length : ${updatedOperatingTimeMap.length}');
    updatedOperatingTimeMap.forEach((day, operatingHour) {
      final OperatingTimeVo vo = new OperatingTimeVo();
      vo.dayOfWeek = operatingHour.dayOfWeek;
      LogUtil.debug(_TAG,
          'range ${operatingHour.status} openingHrs : ${operatingHour.openingHrs} openingMins : ${operatingHour.openingMins} closingHrs : ${operatingHour.closingHrs} closingMins ${operatingHour.closingMins}');
      vo.openingTime = sprintf('%02d:%02d', [operatingHour.openingHrs, operatingHour.openingMins]);
      vo.closingTime = sprintf('%02d:%02d', [operatingHour.closingHrs, operatingHour.closingMins]);
      vo.operatingTimeSource = 'C';
      vo.operatingTimeRange = operatingHour.operatingTimeRange;
      operatingTimeVos.add(vo);
    });
    return operatingTimeVos;
  }

  UpdateOperatingTimeResult _getUpdateResponse(
      final AlterOperatingTimeRequest request,
      final AlterOperatingTimeResponse response,
      final Map<String, dynamic> originalPathAndValues,
      final Map<String, dynamic> updatedValues) {
    return new UpdateOperatingTimeResult(true, response.updateEpoch,
        updateValues: updatedValues,
        originalValues: originalPathAndValues,
        invalidArguments: response.invalidArguments,
        recordLevelExceptionCodes: response.updateResult);
  }
}
