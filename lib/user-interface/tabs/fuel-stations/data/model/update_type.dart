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

enum UpdateType { operatingTime, price, addressDetails, phoneNumber, suggestEdit, fuelStationFeatures }

extension UpdateTypeExt on UpdateType {
  static const _updateTypeNames = {
    UpdateType.operatingTime: 'OPERATING_TIME',
    UpdateType.price: 'PRICE',
    UpdateType.addressDetails: 'ADDRESS_DETAILS',
    UpdateType.phoneNumber: 'PHONE_NUMBER',
    UpdateType.suggestEdit: 'SUGGEST_EDIT',
    UpdateType.fuelStationFeatures: 'FUEL_STATION_FEATURES'
  };

  String? get updateTypeName => _updateTypeNames[this];
}
