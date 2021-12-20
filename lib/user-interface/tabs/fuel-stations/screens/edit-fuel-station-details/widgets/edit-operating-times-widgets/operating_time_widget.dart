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
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:sprintf/sprintf.dart';

class OperatingTimeWidget extends StatefulWidget {
  final int hours;
  final int mins;
  int updatedHrs;
  int updatedMins;
  final String source;
  final Status status;
  final String timeType;
  final String dayOfWeek;
  final Function onOperatingTimeRangeChanged;
  final bool backendUpdateInProgress;

  OperatingTimeWidget(this.hours, this.mins, this.source, this.status, this.onOperatingTimeRangeChanged, this.timeType,
      this.dayOfWeek, this.backendUpdateInProgress,
      {this.updatedHrs, this.updatedMins});
  @override
  _OperatingTimeWidgetState createState() => _OperatingTimeWidgetState();
}

class _OperatingTimeWidgetState extends State<OperatingTimeWidget> {
  static const _TAG = 'OperatingTimeWidget';
  String selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = _getOperatingTime();
  }

  String _getOperatingTime() {
    final int selectedHour = widget.updatedHrs != null ? widget.updatedHrs : widget.hours;
    final int selectedMin = widget.updatedMins != null ? widget.updatedMins : widget.mins;
    if (selectedHour != null && selectedMin != null) {
      return sprintf('%02d:%02d', [selectedHour, selectedMin]);
    } else {
      return widget.status == Status.unknown ? '-----' : sprintf('%02d:%02d', [selectedHour, selectedMin]);
    }
  }

  @override
  Widget build(final BuildContext context) {
    selectedTime = _getOperatingTime();
    return GestureDetector(
      onTap: () {
        if (widget.backendUpdateInProgress) {
          LogUtil.debug(_TAG, 'Background task is in progress');
        } else {
          if (widget.source != 'G' && widget.source != 'F') {
            _pickTime(context, widget.hours, widget.mins, true);
          } else {
            WidgetUtils.showToastMessage(context, 'Cannot change this operating time', Theme.of(context).primaryColor);
            LogUtil.debug(_TAG, 'Cannot mutate operating time provided by ${widget.source}');
          }
        }
      },
      child: Container(
          height: 30,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[SizedBox(width: 5), Text(selectedTime, style: TextStyle(fontSize: 14))])),
    );
  }

  Duration onTimeChangedDuration;

  void _pickTime(final BuildContext context, final int hrs, final int mins, final bool isOpenHr) {
    final Duration initialTime = new Duration(hours: hrs == null ? 0 : hrs, minutes: mins == null ? 0 : mins);
    showCupertinoModalPopup(
        useRootNavigator: false,
        context: context,
        builder: (context) => Container(
            decoration: BoxDecoration(color: Colors.white),
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(249, 249, 247, 1.0),
                      border: Border(bottom: const BorderSide(width: 0.5, color: Colors.black38))),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    _getCancelButton(context),
                    _getTimeTypeHeader(isOpenHr),
                    _getDoneButton(context)
                  ])),
              Expanded(
                  child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
                      minuteInterval: 1,
                      secondInterval: 1,
                      initialTimerDuration: initialTime,
                      onTimerDurationChanged: (onDateTimeChanged) {
                        onTimeChangedDuration = onDateTimeChanged;
                      }))
            ])));
  }

  Widget _getCancelButton(final BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  Widget _getTimeTypeHeader(final bool isOpenHr) {
    return Text(isOpenHr != null && isOpenHr ? 'Opening Hrs' : 'Closing Hrs',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black));
  }

  Widget _getDoneButton(final BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text('Done'),
        onPressed: () {
          if (onTimeChangedDuration != null) {
            widget.updatedHrs = onTimeChangedDuration.inHours;
            widget.updatedMins = onTimeChangedDuration.inMinutes % 60;
            selectedTime = _getOperatingTime();
            Map<String, dynamic> operatingTimeParams;
            if (widget.timeType == 'OT') {
              operatingTimeParams = {
                'OPEN_HOUR': widget.updatedHrs,
                'OPEN_MINS': widget.updatedMins,
                'OPERATING_TIME_RANGE': OperatingTimeRange.HAS_CLOSING_HOURS
              };
            } else {
              operatingTimeParams = {
                'CLOSING_HOUR': widget.updatedHrs,
                'CLOSING_MINS': widget.updatedMins,
                'OPERATING_TIME_RANGE': OperatingTimeRange.HAS_CLOSING_HOURS
              };
            }
            widget.onOperatingTimeRangeChanged(operatingTimeParams, widget.dayOfWeek);
          }
          Navigator.of(context).pop();
        });
  }
}
