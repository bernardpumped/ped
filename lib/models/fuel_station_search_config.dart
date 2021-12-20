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

import 'package:pumped_end_device/models/pumped/fuel_type.dart';

class FuelStationSearchConfig {

  final FuelType fuelType;
  final double range;
  final String defaultUnit;
  final String clientConfigVersion;
  final num numOfResults;
  final String sortOrder;

  FuelStationSearchConfig(
      {this.fuelType,
      this.range,
      this.defaultUnit,
      this.clientConfigVersion,
      this.numOfResults,
      this.sortOrder});

  Map<String, dynamic> toJson() => {
        'fuel_type': fuelType,
        'range': range,
        'default_unit': defaultUnit,
        'client_config_version': clientConfigVersion,
        'num_of_results': numOfResults,
        'sort_order' : sortOrder
      };
}
