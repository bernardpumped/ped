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
  final bool expandFuelPrices;
  final bool expandSuggestEdit;
  final bool expandPhoneNumber;
  final bool expandAddressDetails;
  final bool expandOperatingHours;
  final bool expandFuelStationFeatures;
  // If this is true, then edit screen needs to pull the operating time from backend.
  final bool lazyLoadOperatingHrs;
  // If this is true, then edit screen needs to pull the fuel quotes from backend.
  bool lazyLoadFuelQuotes = false;

  EditFuelStationDetailsParams(
      {required this.fuelStation,
      this.expandFuelPrices = false,
      this.expandSuggestEdit = false,
      this.expandPhoneNumber = false,
      this.expandAddressDetails = false,
      this.expandOperatingHours = false,
      this.expandFuelStationFeatures = false,
      this.lazyLoadOperatingHrs = false});
}
