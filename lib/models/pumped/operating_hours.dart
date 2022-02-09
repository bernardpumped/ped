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

import 'package:pumped_end_device/models/status.dart';

class OperatingHours {
  Status status;
  final String dayOfWeek;
  int openingHrs;
  int openingMins;
  int closingHrs;
  int closingMins;
  String operatingTimeSource;
  String operatingTimeRange;
  DateTime publishDate;
  final bool isHolidayToday;
  OperatingHours(
      {this.dayOfWeek,
      this.openingHrs,
      this.openingMins,
      this.closingHrs,
      this.closingMins,
      this.operatingTimeRange,
      this.operatingTimeSource,
      this.publishDate,
      this.isHolidayToday = false,
      this.status = Status.open});

  Map<String, dynamic> toJson() => {
        'status': status.statusStr,
        'dayOfWeek': dayOfWeek,
        'openingHrs': openingHrs,
        'openingMins': openingMins,
        'closingHrs': closingHrs,
        'closingMins': closingMins,
        'operatingTimeSource': operatingTimeSource,
        'operatingTimeRange': operatingTimeRange,
        'publishDate': publishDate?.millisecondsSinceEpoch,
        'isHolidayToday': isHolidayToday
      };

  factory OperatingHours.fromJson(final Map<String, dynamic> data) {
    return OperatingHours(
        dayOfWeek: data['dayOfWeek'],
        openingHrs: data['openingHrs'],
        openingMins: data['openingMins'],
        closingHrs: data['closingHrs'],
        closingMins: data['closingMins'],
        operatingTimeRange: data['operatingTimeRange'],
        operatingTimeSource: data['operatingTimeSource'],
        isHolidayToday: data['isHolidayToday'],
        publishDate: data['publishDate'] != null ? DateTime.fromMillisecondsSinceEpoch(data['publishDate']) : null);
  }
}
