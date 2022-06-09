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

import 'package:pumped_end_device/models/pumped/fuel_station.dart';

class EditFuelStationDetailsParams {
  final FuelStation fuelStation;
  final bool editFuelPrices;
  final bool editOperatingTime;
  final bool editDetails;
  final bool editFeatures;
  final bool suggestEdit;
  final String oauthToken;
  final String userId;

  EditFuelStationDetailsParams(
      {required this.oauthToken,
      required this.userId,
      required this.fuelStation,
      this.editFuelPrices = false,
      this.editOperatingTime = false,
      this.editDetails = false,
      this.editFeatures = false,
      this.suggestEdit = false});
}
