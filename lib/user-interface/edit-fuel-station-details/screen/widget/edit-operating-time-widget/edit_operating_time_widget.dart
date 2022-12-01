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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao2/update_history_dao.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/dto/operating_time_vo.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/request/alter_operating_time_request.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/alter_operating_time_response.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/post_operating_time_update.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/reponse-parser/alter_operating_time_response_parser.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/update-results/update_operating_time_result.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-operating-time-widget/edit_operating_time_line_item_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit_action_buttons_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class EditOperatingTimeWidget extends StatefulWidget {
  final EditFuelStationDetailsParams _params;
  final double _heightHeaderWidget;

  const EditOperatingTimeWidget(this._params, this._heightHeaderWidget, {Key? key}) : super(key: key);

  @override
  State<EditOperatingTimeWidget> createState() => _EditOperatingTimeWidgetState();
}

class _EditOperatingTimeWidgetState extends State<EditOperatingTimeWidget> {
  static const _tag = 'EditOperatingTimeWidget';
  Map<String, OperatingHours> _updatedOperatingTimeMap = {};
  bool _backendUpdateInProgress = false;
  bool _onValueChanged = false;
  bool _fabVisible = false;
  late FuelStation _fuelStation;

  @override
  void initState() {
    super.initState();
    _fuelStation = widget._params.fuelStation;
  }

  @override
  Widget build(final BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _getTitleWidget(),
      const SizedBox(height: 10),
      Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height - widget._heightHeaderWidget,
            child: SingleChildScrollView(
                child: Column(children: _buildOperatingTimeGrid(_fuelStation.fuelStationOperatingHrs)))),
        Positioned(
            bottom: 25,
            right: 25,
            child: Visibility(
                visible: _fabVisible,
                child: EditActionButton(
                    undoButtonAction: _onOperatingTimeChangeUndo, saveButtonAction: _onOperatingTimeSave, tag: _tag)))
      ])
    ]);
  }

  _getTitleWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(Icons.access_time_rounded, size: 30),
          const SizedBox(width: 10),
          Text('Update Operating Times', style: Theme.of(context).textTheme.headline4)
        ]));
  }

  void _onOperatingTimeSave() async {
    if (_updatedOperatingTimeMap.isNotEmpty) {
      final Map<String, dynamic> updatedValues = {};
      List<String> badDayRecs = [];
      _updatedOperatingTimeMap.forEach((day, operatingHour) {
        if (_validOperatingHours(operatingHour)) {
          updatedValues.putIfAbsent(day, () => jsonEncode(operatingHour.toJson()));
        } else {
          badDayRecs.add(day);
        }
      });
      if (badDayRecs.isNotEmpty) {
        String badDays = badDayRecs.join(",");
        WidgetUtils.showToastMessage(context, 'Fix the operating hours for $badDays and try again');
        return;
      }
      final Map<String, OperatingHours?> originalOperatingHoursMap = _getOriginalOperatingHoursMap();
      Map<String, dynamic> originalPathAndValues = {};
      _updatedOperatingTimeMap.forEach((day, operatingHour) {
        if (originalOperatingHoursMap.containsKey(day)) {
          originalPathAndValues.putIfAbsent(
              day,
              () =>
                  originalOperatingHoursMap[day] != null ? jsonEncode(originalOperatingHoursMap[day]!.toJson()) : null);
        }
      });
      final AlterOperatingTimeRequest request = AlterOperatingTimeRequest(
          uuid: const Uuid().v1(),
          fuelStationId: _fuelStation.stationId,
          featureType: 'FUEL-FILL',
          fuelStationSource: _fuelStation.isFaStation ? "F" : "G",
          authValidatorType: 'FIREBASE',
          identityProvider: 'FIREBASE',
          oauthToken: widget._params.oauthToken,
          oauthTokenSecret: '',
          operatingTimeVos: _getOperatingTimeVos(_updatedOperatingTimeMap));
      AlterOperatingTimeResponse response;
      try {
        lockInputs();
        response = await PostOperatingTimeUpdate(AlterOperatingTimeResponseParser()).execute(request);
      } on Exception catch (e, s) {
        LogUtil.debug(_tag, 'Exception occurred while calling PostOperatingTimeUpdate.execute $s');
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
      dynamic insertRecordResult = await _persistUpdateHistory(request, response, originalPathAndValues, updatedValues);
      LogUtil.debug(_tag, 'UpdateHistory inserted for :: operatingTime :: result $insertRecordResult');
      if (!mounted) return;
      final Map<String, dynamic> responseParseMap = _isUpdateSuccessful(response);
      WidgetUtils.showToastMessage(context, responseParseMap[_responseMsg],
          isErrorToast: !responseParseMap[_isSuccess]!);
      Navigator.pop(context, _getUpdateResponse(request, response, originalPathAndValues, updatedValues));
    }
  }

  Future<dynamic> _persistUpdateHistory(
      final AlterOperatingTimeRequest request,
      final AlterOperatingTimeResponse response,
      final Map<String, dynamic> originalPathAndValues,
      final Map<String, dynamic> updatedValues) async {
    int updateEpoch = response.updateEpoch;
    if (response.updateEpoch > 1700000000) {
      //Ths is interim, till the Pumped fix is not pushed back.
      updateEpoch = response.updateEpoch ~/ 1000;
    }
    final UpdateHistory updateHistory = UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: _fuelStation.fuelStationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: updateEpoch,
        updateType: UpdateType.operatingTime.updateTypeName!,
        responseCode: response.responseCode,
        originalValues: originalPathAndValues,
        updateValues: updatedValues,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return await UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  static const _responseMsg = 'resp-msg';
  static const _isSuccess = 'is-success';

  Map<String, dynamic> _isUpdateSuccessful(final AlterOperatingTimeResponse response) {
    if (response.exceptionCodes != null && response.exceptionCodes!.isNotEmpty) {
      return {_responseMsg: 'Request to update operating hours failed with exceptions', _isSuccess: false};
    }
    if (!response.successfulUpdate) {
      if (response.responseCode == 'CALL-EXCEPTION') {
        return {_responseMsg: 'Transient issue occurred while updating Operating Hours, please retry', _isSuccess: false};
      }
      return {_responseMsg: 'Request to update operating hours failed', _isSuccess: false};
    } else {
      bool exceptionDetected = false;
      response.updateResult?.forEach((dayOfWeek, updateException) {
        exceptionDetected = exceptionDetected || (updateException as List).isNotEmpty;
      });
      if (exceptionDetected) {
        return {_responseMsg: 'Update request partially failed for a few operating hours', _isSuccess: false};
      }
      bool invalidArgsException = false;
      response.invalidArguments?.forEach((key, value) {
        invalidArgsException = invalidArgsException || DataUtils.isNotBlank(value);
      });
      if (invalidArgsException) {
        return {
          _responseMsg: 'Operating hours found invalid, please refresh / correct before update',
          _isSuccess: false
        };
      }
      return {_responseMsg: 'Operating hours successfully updated. Also notified Pumped Team', _isSuccess: true};
    }
  }

  List<OperatingTimeVo> _getOperatingTimeVos(final Map<String, OperatingHours> updatedOperatingTimeMap) {
    List<OperatingTimeVo> operatingTimeVos = [];
    LogUtil.debug(_tag, 'updatedOperatingTimeMap.length : ${updatedOperatingTimeMap.length}');
    updatedOperatingTimeMap.forEach((day, operatingHour) {
      final String openingTime = sprintf('%02d:%02d', [operatingHour.openingHrs, operatingHour.openingMins]);
      final String closingTime = sprintf('%02d:%02d', [operatingHour.closingHrs, operatingHour.closingMins]);
      final OperatingTimeVo vo = OperatingTimeVo(
          dayOfWeek: operatingHour.dayOfWeek,
          openingTime: openingTime,
          closingTime: closingTime,
          operatingTimeRange: operatingHour.operatingTimeRange,
          operatingTimeSource: 'C');
      LogUtil.debug(
          _tag,
          'range ${operatingHour.status} openingHrs : ${operatingHour.openingHrs} openingMins : ${operatingHour.openingMins} '
          'closingHrs : ${operatingHour.closingHrs} closingMins ${operatingHour.closingMins}');
      operatingTimeVos.add(vo);
    });
    return operatingTimeVos;
  }

  void lockInputs() {
    LogUtil.debug(_tag, 'locking the inputs');
    setState(() {
      _backendUpdateInProgress = true;
    });
  }

  void unlockInputs() {
    LogUtil.debug(_tag, 'unlocking the inputs');
    setState(() {
      // Ideally it should take backend response before clearing this.
      _updatedOperatingTimeMap = {};
      _backendUpdateInProgress = false;
      _onValueChanged = false;
    });
  }

  Map<String, OperatingHours?> _getOriginalOperatingHoursMap() {
    final Map<String, OperatingHours?> originalOperatingHoursMap = {};
    final List<String> daysOfWeek = DateTimeUtils.weekDayShortToLongName.keys.toList();
    if (_fuelStation.fuelStationOperatingHrs != null &&
        _fuelStation.fuelStationOperatingHrs?.weeklyOperatingHrs != null) {
      for (var operatingHour in _fuelStation.fuelStationOperatingHrs!.weeklyOperatingHrs) {
        originalOperatingHoursMap.putIfAbsent(operatingHour.dayOfWeek, () => operatingHour);
        daysOfWeek.remove(operatingHour.dayOfWeek);
      }
    }
    for (var dayOfWeek in daysOfWeek) {
      originalOperatingHoursMap.putIfAbsent(dayOfWeek, () => null);
    }
    return originalOperatingHoursMap;
  }

  void _onOperatingTimeChangeUndo() {
    setState(() {
      _updatedOperatingTimeMap = {};
      _onValueChanged = false;
      _fabVisible = false;
    });
  }

  _buildOperatingTimeGrid(final FuelStationOperatingHrs? fuelStationOperatingHrs) {
    final List<Widget> columnContent = [];
    final List<String> daysOfWeek = DateTimeUtils.weekDayShortToLongName.keys.toList();
    if (fuelStationOperatingHrs != null) {
      for (var operatingHrs in fuelStationOperatingHrs.weeklyOperatingHrs) {
        final OperatingHours? updatedOperatingHrs = _updatedOperatingTimeMap[operatingHrs.dayOfWeek];
        daysOfWeek.remove(operatingHrs.dayOfWeek);
        columnContent.add(EditOperatingTimeLineItemWidget(_fuelStation.isFaStation, operatingHrs, updatedOperatingHrs,
            _undoOperatingTimeChange, _onOperatingTimeRangeChanged, _backendUpdateInProgress));
      }
    }
    for (var dayOfWeek in daysOfWeek) {
      final OperatingHours operatingHours = OperatingHours(dayOfWeek: dayOfWeek, status: Status.unknown);
      final OperatingHours? updatedOperatingHrs = _updatedOperatingTimeMap[dayOfWeek];
      columnContent.add(EditOperatingTimeLineItemWidget(_fuelStation.isFaStation, operatingHours, updatedOperatingHrs,
          _undoOperatingTimeChange, _onOperatingTimeRangeChanged, _backendUpdateInProgress));
    }
    columnContent.add(const SizedBox(height: 200));
    return columnContent;
  }

  void _undoOperatingTimeChange(final String dayOfWeek) {
    LogUtil.debug(_tag, '_undoOperatingTimeChange called for day $dayOfWeek');
    setState(() {
      if (_updatedOperatingTimeMap.containsKey(dayOfWeek)) {
        _updatedOperatingTimeMap.remove(dayOfWeek);
      }
      if (_updatedOperatingTimeMap.isEmpty) {
        _onValueChanged = false;
      }
      _fabVisible = _updatedOperatingTimeMap.isNotEmpty;
    });
  }

  void _onOperatingTimeRangeChanged(final Map<String, dynamic> operatingTimeParams, final String dayOfWeek) {
    setState(() {
      _onValueChanged = true;
      OperatingHours? tmpUot = _updatedOperatingTimeMap.remove(dayOfWeek);
      OperatingHours uot = tmpUot ?? OperatingHours(dayOfWeek: dayOfWeek);
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
      _fabVisible = _onValueChanged;
    });
  }

  UpdateOperatingTimeResult _getUpdateResponse(
      final AlterOperatingTimeRequest request,
      final AlterOperatingTimeResponse response,
      final Map<String, dynamic> originalPathAndValues,
      final Map<String, dynamic> updatedValues) {
    int updateEpoch = response.updateEpoch;
    if (response.updateEpoch > 1700000000) {
      //Ths is interim, till the Pumped fix is not pushed back.
      updateEpoch = response.updateEpoch ~/ 1000;
    }
    return UpdateOperatingTimeResult(true, updateEpoch,
        updateValues: updatedValues,
        originalValues: originalPathAndValues,
        invalidArguments: response.invalidArguments,
        recordLevelExceptionCodes: response.updateResult);
  }

  bool _validOperatingHours(final OperatingHours operatingHour) {
    return operatingHour.openingHrs != null &&
        operatingHour.openingMins != null &&
        operatingHour.closingHrs != null &&
        operatingHour.closingMins != null;
  }
}
