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
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/operating_time_range.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:sprintf/sprintf.dart';

class OperatingTimeWidget extends StatefulWidget {
  final bool editable;
  final int? hours;
  final int? mins;
  int? updatedHrs;
  int? updatedMins;
  final String? source;
  final Status status;
  final String timeType;
  final String dayOfWeek;
  final Function? onOperatingTimeRangeChanged;
  final bool backendUpdateInProgress;

  OperatingTimeWidget(this.editable, this.hours, this.mins, this.source, this.status, this.onOperatingTimeRangeChanged,
      this.timeType, this.dayOfWeek, this.backendUpdateInProgress,
      {super.key, this.updatedHrs, this.updatedMins});
  @override
  State<OperatingTimeWidget> createState() => _OperatingTimeWidgetState();
}

class _OperatingTimeWidgetState extends State<OperatingTimeWidget> {
  static const _tag = 'OperatingTimeWidget';
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = _getOperatingTime();
  }

  String _getOperatingTime() {
    final int? selectedHour = widget.updatedHrs ?? widget.hours;
    final int? selectedMin = widget.updatedMins ?? widget.mins;
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
            LogUtil.debug(_tag, 'Background task is in progress');
          } else {
            if (widget.editable) {
              _pickTime(context, widget.hours, widget.mins, true);
            } else {
              WidgetUtils.showToastMessage(context, 'Cannot change this operating time');
              LogUtil.debug(_tag, 'Cannot mutate operating time provided by ${widget.source}');
            }
          }
        },
        child: SizedBox(
            height: 35,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const SizedBox(width: 5),
              Text(selectedTime!, style: Theme.of(context).textTheme.bodyLarge,
                  textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
            ])));
  }

  Duration? onTimeChangedDuration;

  void _pickTime(final BuildContext context, final int? hrs, final int? mins, final bool isOpenHr) async {
    final TimeOfDay? timeOfDay =
        await showTimePicker(context: context, initialTime: TimeOfDay(hour: hrs ?? 0, minute: mins ?? 0));
    onTimeChangedDuration =
        Duration(hours: timeOfDay != null ? timeOfDay.hour : 0, minutes: timeOfDay != null ? timeOfDay.minute : 0);
    widget.updatedHrs = onTimeChangedDuration?.inHours;
    if (onTimeChangedDuration != null) {
      widget.updatedMins = onTimeChangedDuration!.inMinutes % 60;
    } else {
      widget.updatedMins = 0;
    }
    selectedTime = _getOperatingTime();
    Map<String, dynamic> operatingTimeParams;
    if (widget.timeType == 'OT') {
      operatingTimeParams = {
        'OPEN_HOUR': widget.updatedHrs,
        'OPEN_MINS': widget.updatedMins,
        'OPERATING_TIME_RANGE': OperatingTimeRange.hasClosingHours
      };
    } else {
      operatingTimeParams = {
        'CLOSING_HOUR': widget.updatedHrs,
        'CLOSING_MINS': widget.updatedMins,
        'OPERATING_TIME_RANGE': OperatingTimeRange.hasClosingHours
      };
    }
    if (widget.onOperatingTimeRangeChanged != null) {
      widget.onOperatingTimeRangeChanged!(operatingTimeParams, widget.dayOfWeek);
    }
  }
}
