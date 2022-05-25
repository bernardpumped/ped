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

import 'package:pumped_end_device/models/pumped/operating_hours.dart';

class FuelStationOperatingHrs {
  final int stationId;
  final List<OperatingHours> weeklyOperatingHrs;

  FuelStationOperatingHrs({required this.stationId, required this.weeklyOperatingHrs});

  void updateOperatingHoursForDay(final String dayOfWeek, final OperatingHours operatingHours) {
    int j = -1;
    for (int i = 0; i < weeklyOperatingHrs.length; i++) {
      if (weeklyOperatingHrs[i].dayOfWeek == dayOfWeek) {
        j = i;
        break;
      }
    }
    if (j != -1) {
      weeklyOperatingHrs[j] = operatingHours;
    } else {
      weeklyOperatingHrs.add(operatingHours);
    }
  }

  OperatingHours? getOperatingHoursForDay(final String dayOfWeek) {
    for (int i = 0; i < weeklyOperatingHrs.length; i++) {
      if (weeklyOperatingHrs[i].dayOfWeek == dayOfWeek) {
        return weeklyOperatingHrs[i];
      }
    }
    return null;
  }
}
