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

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/operating_time_range.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';

class OperatingHoursResponseParseUtils {
  static OperatingHours? getOperatingHours(final Map<String, dynamic>? operatingHoursJsonVal, final bool? holidayToday) {
    OperatingHours? operatingHours;
    if (operatingHoursJsonVal != null) {
      final String? openingTime = operatingHoursJsonVal['openingTime'];
      final String? closingTime = operatingHoursJsonVal['closingTime'];
      final int? openingHrs = _getHoursFromTimeString(openingTime);
      final int? openingMinutes = _getMinutesFromTimeString(openingTime);
      int? closingHrs = _getHoursFromTimeString(closingTime);
      if (closingHrs == 0 || closingHrs == null) {
        closingHrs = 23;
      }
      int? closingMinutes = _getMinutesFromTimeString(closingTime);
      if (closingMinutes == 0 || closingMinutes == null) {
        closingMinutes = 59;
      }
      var operatingHours = operatingHoursJsonVal['publishDate'];
      final DateTime? publishDateTime = operatingHours != null ? DateTime.fromMillisecondsSinceEpoch(operatingHours * 1000) : null;
      operatingHours = OperatingHours(
          dayOfWeek: operatingHoursJsonVal['dayOfWeek'],
          openingHrs: openingHrs,
          openingMins: openingMinutes,
          closingHrs: closingHrs,
          closingMins: closingMinutes,
          operatingTimeRange: _getOperatingTimeRange(operatingHoursJsonVal, openingTime, closingTime),
          operatingTimeSource: operatingHoursJsonVal['operatingTimeSource'],
          operatingTimeSourceName: operatingHoursJsonVal['operatingTimeSourceName'],
          publishDate: publishDateTime,
          isHolidayToday: holidayToday);
      operatingHours.status = getStatus(operatingHours, holidayToday: holidayToday);
    }
    return operatingHours;
  }

  static _getOperatingTimeRange(
      final Map<String, dynamic>? operatingHoursJsonVal, final String? openingTime, final String? closingTime) {
    String? operatingTimeRangeVal;
    if (operatingHoursJsonVal == null && openingTime != null && closingTime != null) {
      operatingTimeRangeVal = openingTime + '-' + closingTime;
    } else if (operatingHoursJsonVal != null) {
      operatingTimeRangeVal = operatingHoursJsonVal['operatingTimeRange'];
    }
    return operatingTimeRangeVal;
  }

  static int? _getHoursFromTimeString(final String? timeString) {
    if (timeString != null) {
      final int len = timeString.length;
      return int.parse(timeString.substring(0, len == 3 ? 1 : 2));
    }
    return null;
  }

  static int? _getMinutesFromTimeString(final String? timeString) {
    if (timeString != null) {
      final int len = timeString.length;
      return int.parse(timeString.substring(len - 2));
    }
    return null;
  }

  static Status getStatus(final OperatingHours? operatingHours, {bool? holidayToday = false}) {
    Status status = Status.unknown;
    if (holidayToday != null && holidayToday) {
      status = Status.closed;
    } else {
      if (operatingHours != null) {
        final String operatingTimeRange = operatingHours.operatingTimeRange ?? "";
        if (OperatingTimeRange.alwaysOpen == operatingTimeRange) {
          status = Status.open24Hrs;
        } else if (OperatingTimeRange.closed == operatingTimeRange) {
          status = Status.closed;
        } else {
          final int? openingHrs = operatingHours.openingHrs;
          final int? openingMins = operatingHours.openingMins;
          int? closingHrs = operatingHours.closingHrs;
          int? closingMins = operatingHours.closingMins;

          if (closingHrs == 0 && closingMins == 0 || (closingHrs == null && closingMins == null)) {
            closingHrs = 23;
            closingMins = 59;
          }
          if (openingHrs != null && openingMins != null && closingHrs != null && closingMins != null) {
            final int todaysTotalMinutes = DateTime.now().hour * 60 + DateTime.now().minute;
            final int openingTimeInMinutes = openingHrs * 60 + openingMins;
            int closingTimeInMinutes = closingHrs * 60 + closingMins;
            if (openingTimeInMinutes > closingTimeInMinutes) {
              closingTimeInMinutes += (23 * 60 + 59);
            }
            if (todaysTotalMinutes < openingTimeInMinutes && openingTimeInMinutes - todaysTotalMinutes <= 15) {
              status = Status.openingSoon;
            } else if (todaysTotalMinutes < closingTimeInMinutes && closingTimeInMinutes - todaysTotalMinutes <= 30) {
              status = Status.closingSoon;
            } else {
              status = todaysTotalMinutes >= openingTimeInMinutes && todaysTotalMinutes < closingTimeInMinutes
                  ? Status.open
                  : Status.closed;
            }
          }
        }
      }
    }
    return status;
  }
}
