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

enum UpdateType { OPERATING_TIME, PRICE, ADDRESS_DETAILS, PHONE_NUMBER, SUGGEST_EDIT, FUEL_STATION_FEATURES }

extension UpdateTypeExt on UpdateType {
  static const _updateTypeNames = {
    UpdateType.OPERATING_TIME: 'OPERATING_TIME',
    UpdateType.PRICE: 'PRICE',
    UpdateType.ADDRESS_DETAILS: 'ADDRESS_DETAILS',
    UpdateType.PHONE_NUMBER: 'PHONE_NUMBER',
    UpdateType.SUGGEST_EDIT: 'SUGGEST_EDIT',
    UpdateType.FUEL_STATION_FEATURES: 'FUEL_STATION_FEATURES'
  };

  String get updateTypeName => _updateTypeNames[this];
}
