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

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_fuel_station_detail_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_fuel_station_details_result.dart';

class UpdatePhoneNumberResult extends UpdateFuelStationDetailsResult {
  UpdatePhoneNumberResult(final bool isUpdateSuccessful, final int updateEpoch,
      {this.phoneTypeUpdateStatusMap, this.phoneTypeNewValueMap})
      : super(UpdateFuelStationDetailType.PHONE_NUMBER, isUpdateSuccessful, updateEpoch);
  final Map<String, bool> phoneTypeUpdateStatusMap;
  final Map<String, dynamic> phoneTypeNewValueMap;
}