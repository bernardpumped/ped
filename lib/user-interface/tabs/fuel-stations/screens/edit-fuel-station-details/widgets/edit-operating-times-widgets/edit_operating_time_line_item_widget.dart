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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/operating_time_range.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'operating_time_widget.dart';

class EditOperatingTimeLineItemWidget extends StatefulWidget {
  final bool isFaStation;
  final OperatingHours operatingHour;
  final OperatingHours? updatedOperatingHrs;
  final Function onOperatingTimeRangeChanged;
  final Function undoOperatingTimeChange;
  final bool backendUpdateInProgress;

  const EditOperatingTimeLineItemWidget(this.isFaStation, this.operatingHour, this.updatedOperatingHrs, this.undoOperatingTimeChange,
      this.onOperatingTimeRangeChanged, this.backendUpdateInProgress, {Key? key}) : super(key: key);

  @override
  _EditOperatingTimeLineItemWidgetStateNew createState() => _EditOperatingTimeLineItemWidgetStateNew();
}

class _EditOperatingTimeLineItemWidgetStateNew extends State<EditOperatingTimeLineItemWidget> {
  static const _tag = 'EditOperatingTimeLineItemWidget';
  static const _open24Hours = 0;
  static const _closed = 1;
  static const _other = 2;
  int _selectedValue = _other;

  static const _nonEditableHeight = 60.0;
  static const _editableHeight = 85.0;
  static const _errorHeight = 110.0;
  static const _noErrorMsgHeight = 0.0;
  static const _errorMsgHeight = 25.0;

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
    _editable = widget.operatingHour.operatingTimeSource != 'G' && widget.operatingHour.operatingTimeSource != 'F' && !widget.isFaStation;
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
      LogUtil.debug(_tag, 'calling _setUpdatedWidgetHeight');
      _setUpdatedWidgetHeight();
    } else {
      _selectedValue = _other;
      LogUtil.debug(_tag, 'calling _setInitialHeight');
      _setInitialHeight();
    }
    LogUtil.debug(_tag, '_errorContainerHeight : $_errorContainerHeight _height : $_height');
    return _editable ? _getAnimatedContainer() : _getContainer();
  }

  Widget _getAnimatedContainer() {
    final double animatedContainerTopPadding = _errorContainerHeight != _noErrorMsgHeight ? 10 : 0;
    return AnimatedContainer(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        height: _height,
        duration: Duration(milliseconds: _containerHeightChangeTime),
        curve: Curves.fastOutSlowIn,
        child: Column(children: [
          Row(children: <Widget>[
            Expanded(
                flex: 2,
                child:
                    Text(widget.operatingHour.dayOfWeek, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            _getAlwaysOpenCloseWidget(7),
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
                    updatedMins: widget.updatedOperatingHrs?.closingMins)),
            Expanded(
                flex: 2,
                child: SizedBox(
                    height: 30,
                    child: widget.updatedOperatingHrs != null
                        ? TextButton(
                            child: PumpedIcons.undoIconBlack87Size30,
                            onPressed: () {
                              if (widget.backendUpdateInProgress) {
                                LogUtil.debug(_tag, 'Background task is in progress');
                              } else {
                                _selectedValue = 2;
                                widget.undoOperatingTimeChange(widget.operatingHour.dayOfWeek);
                              }
                            })
                        : const SizedBox(width: 0)))
          ]),
          AnimatedContainer(
              padding: EdgeInsets.only(left: 30, top: animatedContainerTopPadding),
              height: _errorContainerHeight,
              duration: Duration(milliseconds: _errorMsgHeightChangeTime),
              child: Text(_errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue)))
        ]));
  }

  Widget _getContainer() {
    return Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        height: _height,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              flex: 2,
              child: Text(widget.operatingHour.dayOfWeek, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          Expanded(child: Container(), flex: 2),
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
                updatedMins: widget.updatedOperatingHrs?.openingMins),
          ),
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
        ]));
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
    } else {
      _errorContainerHeight = _noErrorMsgHeight;
      _errorMessage = "";
      _height = _editableHeight;
      _containerHeightChangeTime = _slowDuration;
      _errorMsgHeightChangeTime = _quickDuration;
    }
  }

  Expanded _getAlwaysOpenCloseWidget(final int flexVal) {
    return Expanded(
        flex: flexVal,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          SizedBox(
              height: 30,
              child: Row(children: [
                Radio(
                    value: _open24Hours,
                    groupValue: _selectedValue,
                    onChanged: _handleRadioValueChange,
                    focusColor: Theme.of(context).primaryColor),
                const Text('Open 24 hours', style: TextStyle(fontSize: 14))
              ])),
          SizedBox(
              height: 30,
              child: Row(children: [
                Radio(
                    value: _closed,
                    groupValue: _selectedValue,
                    onChanged: _handleRadioValueChange,
                    focusColor: Theme.of(context).primaryColor),
                const Text('Closed', style: TextStyle(fontSize: 14))
              ]))
        ]));
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
