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
import 'package:sprintf/sprintf.dart';

class OperatingTimeRange {
  static const alwaysOpen = 'ALWAYS_OPEN';
  static const closed = 'CLOSED';
  static const hasClosingHours = 'HAS_CLOSING_HOURS';

  static String getStringRepresentation(final OperatingHours operatingHours) {
    if (operatingHours != null) {
      if (alwaysOpen == operatingHours.operatingTimeRange) {
        return "Always Open";
      }
      if (closed == operatingHours.operatingTimeRange) {
        return "Closed";
      }
      if (hasClosingHours == operatingHours.operatingTimeRange) {
        return _getTimeRange(operatingHours);
      }
    }
    return "----";
  }

  static String _getTimeRange(final OperatingHours operatingHours) {
    return sprintf('%02d:%02d - %02d:%02d',
        [operatingHours.openingHrs, operatingHours.openingMins, operatingHours.closingHrs, operatingHours.closingMins]);
  }
}
