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
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/operating_time_range.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'operating_time_widget.dart';

class EditOperatingTimeLineItemWidget extends StatefulWidget {
  final bool isFaStation;
  final OperatingHours operatingHour;
  final OperatingHours? updatedOperatingHrs;
  final Function onOperatingTimeRangeChanged;
  final Function undoOperatingTimeChange;
  final bool backendUpdateInProgress;

  const EditOperatingTimeLineItemWidget(this.isFaStation, this.operatingHour, this.updatedOperatingHrs,
      this.undoOperatingTimeChange, this.onOperatingTimeRangeChanged, this.backendUpdateInProgress,
      {Key? key})
      : super(key: key);

  @override
  State<EditOperatingTimeLineItemWidget> createState() => _EditOperatingTimeLineItemWidgetStateNew();
}

class _EditOperatingTimeLineItemWidgetStateNew extends State<EditOperatingTimeLineItemWidget> {
  static const _tag = 'EditOperatingTimeLineItemWidget';
  static const _open24Hours = 0;
  static const _closed = 1;
  static const _other = 2;
  int _selectedValue = _other;

  static const _nonEditableHeight = 75.0;
  static const _editableHeight = 105.0;
  static const _errorHeight = 150.0;
  static const _noErrorMsgHeight = 0.0;
  static const _errorMsgHeight = 45.0;

  static const _quickDuration = 300;
  static const _slowDuration = 1000;

  int _containerHeightChangeTime = _slowDuration;
  int _errorMsgHeightChangeTime = _quickDuration;

  double _height = _editableHeight;
  double _errorContainerHeight = _noErrorMsgHeight;
  String _errorMessage = "";
  bool _editable = false;

  @override
  void initState() {
    super.initState();
    _editable = widget.operatingHour.operatingTimeSource != 'G' &&
        widget.operatingHour.operatingTimeSource != 'F' &&
        !widget.isFaStation;
    _setInitialHeight();
  }

  void _setInitialHeight() {
    _errorContainerHeight = _noErrorMsgHeight;
    if (widget.operatingHour.status == Status.unknown) {
      _height = _editableHeight;
    } else if (_editable) {
      _height = _editableHeight;
    } else {
      _height = _nonEditableHeight;
    }
    _errorMessage = "";
    _containerHeightChangeTime = _slowDuration;
    _errorMsgHeightChangeTime = _quickDuration;
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.updatedOperatingHrs != null) {
      if (widget.updatedOperatingHrs?.status != null) {
        _selectedValue = widget.updatedOperatingHrs?.status == Status.open24Hrs
            ? _open24Hours
            : (widget.updatedOperatingHrs?.status == Status.closed ? _closed : _other);
      }
      LogUtil.debug(
          _tag,
          'UpdatedOperatingHrs : ${widget.updatedOperatingHrs?.dayOfWeek} '
          '${widget.updatedOperatingHrs?.openingHrs} ${widget.updatedOperatingHrs?.closingHrs} status ${widget.updatedOperatingHrs?.status} _selectedValue : $_selectedValue');
      _setUpdatedWidgetHeight();
    } else {
      _selectedValue = widget.operatingHour.status == Status.open24Hrs
          ? _open24Hours
          : (widget.operatingHour.status == Status.closed ? _closed : _other);
      LogUtil.debug(
          _tag,
          'OperatingHrs : ${widget.operatingHour.dayOfWeek} '
          '${widget.operatingHour.openingHrs} ${widget.operatingHour.closingHrs} status ${widget.operatingHour.status} _selectedValue : $_selectedValue');
      _setInitialHeight();
    }
    return _editable ? _getAnimatedContainer() : _getContainer();
  }

  Widget _getAnimatedContainer() {
    final double animatedContainerTopPadding = _errorContainerHeight != _noErrorMsgHeight ? 10 : 0;
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: AnimatedContainer(
          // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 10),
          height: _height,
          duration: Duration(milliseconds: _containerHeightChangeTime),
          curve: Curves.fastOutSlowIn,
          child: Column(children: [
            Row(children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Text(DateTimeUtils.weekDayShortToLongName[widget.operatingHour.dayOfWeek]!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.indigo))),
              Expanded(
                  flex: 9,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Card(
                            surfaceTintColor: const Color(0xFFF0EDFF),
                            color: const Color(0xFFF0EDFF),
                            child: _getAlwaysOpenCloseWidget()),
                        const SizedBox(height: 7),
                        Card(
                            surfaceTintColor: const Color(0xFFF0EDFF),
                            color: const Color(0xFFF0EDFF),
                            child: _getOpenCloseOperatingTimeWidget())
                      ]))
            ]),
            AnimatedContainer(
                padding: EdgeInsets.only(left: 30, top: animatedContainerTopPadding),
                height: _errorContainerHeight,
                duration: Duration(milliseconds: _errorMsgHeightChangeTime),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(_errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.red)),
                      const SizedBox(width: 30),
                      _getUndoButton()
                    ]))
          ])),
    );
  }

  Widget _getUndoButton() {
    return widget.updatedOperatingHrs != null
        ? GestureDetector(
            onTap: () {
              LogUtil.debug(_tag, 'undo Button clicked');
              if (widget.backendUpdateInProgress) {
                LogUtil.debug(_tag, 'Background task is in progress');
              } else {
                _selectedValue = 2;
                widget.undoOperatingTimeChange(widget.operatingHour.dayOfWeek);
              }
            },
            child: Container(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.indigo),
                child: Row(children: const [
                  Icon(Icons.history, color: Colors.white, size: 20),
                  SizedBox(width: 4),
                  Text('Undo', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500))
                ])))
        : const SizedBox(width: 0);
  }

  Row _getOpenCloseOperatingTimeWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: [
      const SizedBox(width: 15),
      const Text('Opens : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.indigo)),
      OperatingTimeWidget(
          _editable,
          widget.operatingHour.openingHrs,
          widget.operatingHour.openingMins,
          widget.operatingHour.operatingTimeSource,
          widget.operatingHour.status,
          widget.onOperatingTimeRangeChanged,
          'OT',
          widget.operatingHour.dayOfWeek,
          widget.backendUpdateInProgress,
          updatedHrs: widget.updatedOperatingHrs?.openingHrs,
          updatedMins: widget.updatedOperatingHrs?.openingMins),
      const SizedBox(width: 20),
      const Text('Closes : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.indigo)),
      OperatingTimeWidget(
          _editable,
          widget.operatingHour.closingHrs,
          widget.operatingHour.closingMins,
          widget.operatingHour.operatingTimeSource,
          widget.operatingHour.status,
          widget.onOperatingTimeRangeChanged,
          'CT',
          widget.operatingHour.dayOfWeek,
          widget.backendUpdateInProgress,
          updatedHrs: widget.updatedOperatingHrs?.closingHrs,
          updatedMins: widget.updatedOperatingHrs?.closingMins)
    ]);
  }

  Widget _getContainer() {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
          // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
          height: _height,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                flex: 2,
                child: Text(DateTimeUtils.weekDayShortToLongName[widget.operatingHour.dayOfWeek]!,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.indigo))),
            Expanded(
                flex: 2,
                child: OperatingTimeWidget(
                    _editable,
                    widget.operatingHour.openingHrs,
                    widget.operatingHour.openingMins,
                    widget.operatingHour.operatingTimeSource,
                    widget.operatingHour.status,
                    widget.onOperatingTimeRangeChanged,
                    'OT',
                    widget.operatingHour.dayOfWeek,
                    widget.backendUpdateInProgress,
                    updatedHrs: widget.updatedOperatingHrs?.openingHrs,
                    updatedMins: widget.updatedOperatingHrs?.openingMins)),
            Expanded(
                flex: 2,
                child: OperatingTimeWidget(
                    _editable,
                    widget.operatingHour.closingHrs,
                    widget.operatingHour.closingMins,
                    widget.operatingHour.operatingTimeSource,
                    widget.operatingHour.status,
                    widget.onOperatingTimeRangeChanged,
                    'CT',
                    widget.operatingHour.dayOfWeek,
                    widget.backendUpdateInProgress,
                    updatedHrs: widget.updatedOperatingHrs?.closingHrs,
                    updatedMins: widget.updatedOperatingHrs?.closingMins))
          ])),
    );
  }

  void _setUpdatedWidgetHeight() {
    bool openingHrsValid = true;
    bool closingHrsValid = true;
    if (widget.updatedOperatingHrs?.status == Status.open24Hrs || widget.updatedOperatingHrs?.status == Status.closed) {
      openingHrsValid = true;
      closingHrsValid = true;
    } else {
      if (widget.updatedOperatingHrs?.openingHrs == null) {
        openingHrsValid = false;
      }
      if (widget.updatedOperatingHrs?.closingHrs == null) {
        closingHrsValid = false;
      }
    }
    if (!openingHrsValid || !closingHrsValid) {
      _height = _errorHeight;
      _errorContainerHeight = _errorMsgHeight;
      _errorMessage = !openingHrsValid ? "Set Opening Hrs" : "Set Closing Hrs";
      _containerHeightChangeTime = _quickDuration;
      _errorMsgHeightChangeTime = _slowDuration;
    } else if (widget.updatedOperatingHrs != null) {
      _height = _errorHeight;
      _errorContainerHeight = _errorMsgHeight;
      _errorMessage = "";
      _containerHeightChangeTime = _quickDuration;
      _errorMsgHeightChangeTime = _slowDuration;
    } else {
      _errorContainerHeight = _noErrorMsgHeight;
      _errorMessage = "";
      _height = _editableHeight;
      _containerHeightChangeTime = _slowDuration;
      _errorMsgHeightChangeTime = _quickDuration;
    }
  }

  Widget _getAlwaysOpenCloseWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: <Widget>[
      SizedBox(
          height: 30,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Radio(
                value: _open24Hours,
                groupValue: _selectedValue,
                onChanged: _handleRadioValueChange,
                activeColor: Colors.indigo,
                focusColor: Colors.indigo),
            const Text('Open 24 hrs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.indigo))
          ])),
      SizedBox(
          height: 30,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Radio(
                value: _closed,
                groupValue: _selectedValue,
                onChanged: _handleRadioValueChange,
                activeColor: Colors.indigo,
                focusColor: Colors.indigo),
            const Text('Closed', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.indigo))
          ]))
    ]);
  }

  void _handleRadioValueChange(final int? value) {
    setState(() {
      if (value == _open24Hours) {
        final Map<String, dynamic> operatingTimeParams = {
          'OPEN_HOUR': 0,
          'OPEN_MINS': 0,
          'CLOSING_HOUR': 23,
          'CLOSING_MINS': 59,
          'OPERATING_TIME_RANGE': OperatingTimeRange.alwaysOpen
        };
        widget.onOperatingTimeRangeChanged(operatingTimeParams, widget.operatingHour.dayOfWeek);
      } else if (value == _closed) {
        final Map<String, dynamic> operatingTimeParams = {
          'OPEN_HOUR': 0,
          'OPEN_MINS': 0,
          'CLOSING_HOUR': 0,
          'CLOSING_MINS': 0,
          'OPERATING_TIME_RANGE': OperatingTimeRange.closed
        };
        widget.onOperatingTimeRangeChanged(operatingTimeParams, widget.operatingHour.dayOfWeek);
      }
      if (value != null) {
        _selectedValue = value;
      }
    });
  }
}
