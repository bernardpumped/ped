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

enum FuelStationDetailsAttributes { STATION_BASIC_DETAILS, MERCHANT_DETAILS, QUOTES, OPERATING_TIMES }

extension FuelStationDetailsAttributesExtension on FuelStationDetailsAttributes {
  static String _value(final FuelStationDetailsAttributes value) {
    switch (value) {
      case FuelStationDetailsAttributes.OPERATING_TIMES:
        return 'OPERATING_TIMES';
      case FuelStationDetailsAttributes.MERCHANT_DETAILS:
        return 'MERCHANT_DETAILS';
      case FuelStationDetailsAttributes.QUOTES:
        return 'QUOTES';
      case FuelStationDetailsAttributes.STATION_BASIC_DETAILS:
        return 'STATION_BASIC_DETAILS';
    }
    return null;
  }

  String get value => _value(this);
}
