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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/operating_time_range.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'operating_time_widget.dart';

class EditOperatingTimeLineItemWidget extends StatefulWidget {
  final OperatingHours operatingHour;
  final OperatingHours updatedOperatingHrs;
  final Function onOperatingTimeRangeChanged;
  final Function undoOperatingTimeChange;
  final bool backendUpdateInProgress;

  EditOperatingTimeLineItemWidget(this.operatingHour, this.updatedOperatingHrs, this.undoOperatingTimeChange,
      this.onOperatingTimeRangeChanged, this.backendUpdateInProgress);

  @override
  _EditOperatingTimeLineItemWidgetStateNew createState() => _EditOperatingTimeLineItemWidgetStateNew();
}

class _EditOperatingTimeLineItemWidgetStateNew extends State<EditOperatingTimeLineItemWidget> {
  static const _TAG = 'EditOperatingTimeLineItemWidget';
  static const _OPEN_24_HOURS = 0;
  static const _CLOSED = 1;
  static const _OTHER = 2;
  int _selectedValue = _OTHER;

  static const _NON_EDITABLE_HEIGHT = 60.0;
  static const _EDITABLE_HEIGHT = 85.0;
  static const _ERROR_HEIGHT = 110.0;
  static const _NO_ERROR_MSG_HEIGHT = 0.0;
  static const _ERROR_MSG_HEIGHT = 25.0;

  static const _QUICK_DURATION = 300;
  static const _SLOW_DURATION = 1000;
  int _containerHeightChangeTime;
  int _errorMsgHeightChangeTime;

  double _height;
  double _errorContainerHeight;
  String _errorMessage = "";
  bool _editable;

  @override
  void initState() {
    super.initState();
    _editable = widget.operatingHour.operatingTimeSource != 'G' && widget.operatingHour.operatingTimeSource != 'F';
    _setInitialHeight();
  }

  void _setInitialHeight() {
    _errorContainerHeight = _NO_ERROR_MSG_HEIGHT;
    if (widget.operatingHour.status == Status.unknown) {
      _height = _EDITABLE_HEIGHT;
    } else if (_editable) {
      _height = _EDITABLE_HEIGHT;
    } else {
      _height = _NON_EDITABLE_HEIGHT;
    }
    _errorMessage = "";
    _containerHeightChangeTime = _SLOW_DURATION;
    _errorMsgHeightChangeTime = _QUICK_DURATION;
  }

  @override
  Widget build(final BuildContext context) {
    if (widget.updatedOperatingHrs != null) {
      if (widget.updatedOperatingHrs.status != null) {
        _selectedValue = widget.updatedOperatingHrs.status == Status.open24Hrs
            ? _OPEN_24_HOURS
            : (widget.updatedOperatingHrs.status == Status.closed ? _CLOSED : _OTHER);
      }
      LogUtil.debug(_TAG, 'calling _setUpdatedWidgetHeight');
      _setUpdatedWidgetHeight();
    } else {
      _selectedValue = _OTHER;
      LogUtil.debug(_TAG, 'calling _setInitialHeight');
      _setInitialHeight();
    }
    LogUtil.debug(_TAG, '_errorContainerHeight : $_errorContainerHeight _height : $_height');
    return _editable ? _getAnimatedContainer() : _getContainer();
  }

  Widget _getAnimatedContainer() {
    final double animatedContainerTopPadding = _errorContainerHeight != _NO_ERROR_MSG_HEIGHT ? 10 : 0;
    return AnimatedContainer(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        height: _height,
        duration: Duration(milliseconds: _containerHeightChangeTime),
        curve: Curves.fastOutSlowIn,
        child: Column(children: [
          Row(children: <Widget>[
            Expanded(
                flex: 2,
                child:
                    Text(widget.operatingHour.dayOfWeek, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            _getAlwaysOpenCloseWidget(7),
            Expanded(
                flex: 2,
                child: OperatingTimeWidget(
                    widget.operatingHour.openingHrs,
                    widget.operatingHour.openingMins,
                    widget.operatingHour.operatingTimeSource,
                    widget.operatingHour.status,
                    widget.onOperatingTimeRangeChanged,
                    'OT',
                    widget.operatingHour.dayOfWeek,
                    widget.backendUpdateInProgress,
                    updatedHrs: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.openingHrs : null,
                    updatedMins: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.openingMins : null)),
            Expanded(
                flex: 2,
                child: OperatingTimeWidget(
                    widget.operatingHour.closingHrs,
                    widget.operatingHour.closingMins,
                    widget.operatingHour.operatingTimeSource,
                    widget.operatingHour.status,
                    widget.onOperatingTimeRangeChanged,
                    'CT',
                    widget.operatingHour.dayOfWeek,
                    widget.backendUpdateInProgress,
                    updatedHrs: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.closingHrs : null,
                    updatedMins: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.closingMins : null)),
            Expanded(
                flex: 2,
                child: Container(
                    height: 30,
                    child: widget.updatedOperatingHrs != null
                        ? TextButton(
                            child: PumpedIcons.undoIcon_black87Size30,
                            onPressed: () {
                              if (widget.backendUpdateInProgress) {
                                LogUtil.debug(_TAG, 'Background task is in progress');
                              } else {
                                _selectedValue = 2;
                                widget.undoOperatingTimeChange(widget.operatingHour.dayOfWeek);
                              }
                            })
                        : SizedBox(width: 0)))
          ]),
          AnimatedContainer(
              padding: EdgeInsets.only(left: 30, top: animatedContainerTopPadding),
              height: _errorContainerHeight,
              duration: Duration(milliseconds: _errorMsgHeightChangeTime),
              child: Text(_errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue)))
        ]));
  }

  Widget _getContainer() {
    return Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        height: _height,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              flex: 2,
              child: Text(widget.operatingHour.dayOfWeek, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          Expanded(child: Container(), flex: 2),
          Expanded(
            flex: 2,
            child: OperatingTimeWidget(
                widget.operatingHour.openingHrs,
                widget.operatingHour.openingMins,
                widget.operatingHour.operatingTimeSource,
                widget.operatingHour.status,
                widget.onOperatingTimeRangeChanged,
                'OT',
                widget.operatingHour.dayOfWeek,
                widget.backendUpdateInProgress,
                updatedHrs: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.openingHrs : null,
                updatedMins: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.openingMins : null),
          ),
          Expanded(
              flex: 2,
              child: OperatingTimeWidget(
                  widget.operatingHour.closingHrs,
                  widget.operatingHour.closingMins,
                  widget.operatingHour.operatingTimeSource,
                  widget.operatingHour.status,
                  widget.onOperatingTimeRangeChanged,
                  'CT',
                  widget.operatingHour.dayOfWeek,
                  widget.backendUpdateInProgress,
                  updatedHrs: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.closingHrs : null,
                  updatedMins: widget.updatedOperatingHrs != null ? widget.updatedOperatingHrs.closingMins : null))
        ]));
  }

  void _setUpdatedWidgetHeight() {
    bool openingHrsValid = true;
    bool closingHrsValid = true;
    if (widget.updatedOperatingHrs.status == Status.open24Hrs || widget.updatedOperatingHrs.status == Status.closed) {
      openingHrsValid = true;
      closingHrsValid = true;
    } else {
      if (widget.updatedOperatingHrs.openingHrs == null) {
        openingHrsValid = false;
      }
      if (widget.updatedOperatingHrs.closingHrs == null) {
        closingHrsValid = false;
      }
    }
    if (!openingHrsValid || !closingHrsValid) {
      _height = _ERROR_HEIGHT;
      _errorContainerHeight = _ERROR_MSG_HEIGHT;
      _errorMessage = !openingHrsValid ? "Set Opening Hrs" : "Set Closing Hrs";
      _containerHeightChangeTime = _QUICK_DURATION;
      _errorMsgHeightChangeTime = _SLOW_DURATION;
    } else {
      _errorContainerHeight = _NO_ERROR_MSG_HEIGHT;
      _errorMessage = "";
      _height = _EDITABLE_HEIGHT;
      _containerHeightChangeTime = _SLOW_DURATION;
      _errorMsgHeightChangeTime = _QUICK_DURATION;
    }
  }

  Expanded _getAlwaysOpenCloseWidget(final int flexVal) {
    return Expanded(
        flex: flexVal,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
              height: 30,
              child: Row(children: [
                Radio(
                    value: _OPEN_24_HOURS,
                    groupValue: _selectedValue,
                    onChanged: _handleRadioValueChange,
                    focusColor: Theme.of(context).primaryColor),
                Text('Open 24 hours', style: TextStyle(fontSize: 14))
              ])),
          Container(
              height: 30,
              child: Row(children: [
                Radio(
                    value: _CLOSED,
                    groupValue: _selectedValue,
                    onChanged: _handleRadioValueChange,
                    focusColor: Theme.of(context).primaryColor),
                Text('Closed', style: TextStyle(fontSize: 14))
              ]))
        ]));
  }

  void _handleRadioValueChange(final int value) {
    setState(() {
      if (value == _OPEN_24_HOURS) {
        final Map<String, dynamic> operatingTimeParams = {
          'OPEN_HOUR': 0,
          'OPEN_MINS': 0,
          'CLOSING_HOUR': 23,
          'CLOSING_MINS': 59,
          'OPERATING_TIME_RANGE': OperatingTimeRange.ALWAYS_OPEN
        };
        widget.onOperatingTimeRangeChanged(operatingTimeParams, widget.operatingHour.dayOfWeek);
      } else if (value == _CLOSED) {
        final Map<String, dynamic> operatingTimeParams = {
          'OPEN_HOUR': 0,
          'OPEN_MINS': 0,
          'CLOSING_HOUR': 0,
          'CLOSING_MINS': 0,
          'OPERATING_TIME_RANGE': OperatingTimeRange.CLOSED
        };
        widget.onOperatingTimeRangeChanged(operatingTimeParams, widget.operatingHour.dayOfWeek);
      }
      _selectedValue = value;
    });
  }
}
