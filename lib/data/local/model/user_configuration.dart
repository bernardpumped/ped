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

import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';

class UserConfiguration {

  static const defaultUserConfigId = 'default-user-config-id';

  final String id;
  final int version;
  final num numSearchResults;
  final FuelType defaultFuelType;
  final FuelCategory defaultFuelCategory;
  final num searchRadius;
  final String searchCriteria;

  UserConfiguration(
      {required this.id, required this.numSearchResults, required this.defaultFuelType,
        required this.defaultFuelCategory, required this.searchRadius,
        required this.searchCriteria, required this.version});

  Map<String, dynamic> toMap() => {
        'id': id,
        'version': version,
        'num_search_results': numSearchResults,
        'default_fuel_type': defaultFuelType.toJson(),
        'default_fuel_category': defaultFuelCategory.toJson(),
        'search_radius': searchRadius,
        'search_criteria': searchCriteria
      };

  factory UserConfiguration.fromMap(final Map<String, dynamic> data) => UserConfiguration.fromJson(data);

  factory UserConfiguration.fromJson(final Map<String, dynamic> data) {
    return UserConfiguration(
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
        'default_fuel_type': defaultFuelType.toJson(),
        'default_fuel_category': defaultFuelCategory.toJson(),
        'search_radius': searchRadius,
        'search_criteria': searchCriteria
      };
}
