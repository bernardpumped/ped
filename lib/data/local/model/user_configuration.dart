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

import 'package:flutter/cupertino.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';

class UserConfiguration {

  static const DEFAULT_USER_CONFIG_ID = 'default-user-config-id';

  final String id;
  final int version;
  @required
  final num numSearchResults;
  @required
  final FuelType defaultFuelType;
  @required
  final FuelCategory defaultFuelCategory;
  @required
  final num searchRadius;
  @required
  final String searchCriteria;

  UserConfiguration(
      {this.id, this.numSearchResults, this.defaultFuelType, this.defaultFuelCategory, this.searchRadius, this.searchCriteria, this.version});

  Map<String, dynamic> toMap() => {
        'id': id,
        'version': version,
        'num_search_results': numSearchResults,
        'default_fuel_type': defaultFuelType != null ? defaultFuelType.toJson() : defaultFuelType,
        'default_fuel_category': defaultFuelCategory != null ? defaultFuelCategory.toJson() : defaultFuelCategory,
        'search_radius': searchRadius,
        'search_criteria': searchCriteria
      };

  factory UserConfiguration.fromMap(final Map<String, dynamic> data) => UserConfiguration.fromJson(data);

  factory UserConfiguration.fromJson(final Map<String, dynamic> data) {
    return new UserConfiguration(
        numSearchResults: data['num_search_results'],
        defaultFuelType: FuelType.fromJson(data['default_fuel_type']),
        defaultFuelCategory: FuelCategory.fromJson(data['default_fuel_category']),
        searchRadius: data['search_radius'],
        searchCriteria: data['search_criteria'],
        version: data['version'],
        id: data['id']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'version': version,
        'num_search_results': numSearchResults,
        'default_fuel_type': defaultFuelType != null ? defaultFuelType.toJson() : defaultFuelType,
        'default_fuel_category': defaultFuelCategory != null ? defaultFuelCategory.toJson() : defaultFuelCategory,
        'search_radius': searchRadius,
        'search_criteria': searchCriteria
      };
}
