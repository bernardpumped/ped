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

class FuelCategory {
  final String categoryId;
  final String categoryName;
  final FuelType defaultFuelType;
  final Set<FuelType> allowedFuelTypes;

  FuelCategory({
    @required this.categoryId,
    this.categoryName,
    this.defaultFuelType,
    this.allowedFuelTypes,
  });

  factory FuelCategory.fromJson(Map<String, dynamic> data) {
    Set<FuelType> allowedFuelTypesSet;
    if (data['allowed_fuel_types'] != null) {
      var allowedFuelTypesJson = data['allowed_fuel_types'] as List;
      allowedFuelTypesSet = allowedFuelTypesJson.map((i) => FuelType.fromJson(i)).toSet();
    }
    return new FuelCategory(
        categoryId: data['category_id'],
        categoryName: data['category_name'],
        defaultFuelType: FuelType.fromJson(data['default_fuel_type']),
        allowedFuelTypes: allowedFuelTypesSet);
  }

  Map<String, dynamic> toJson() {
    var allowedFuelTypesSetStr;
    if (allowedFuelTypes != null && allowedFuelTypes.isNotEmpty) {
      allowedFuelTypesSetStr = allowedFuelTypes.map((i) => i.toJson()).toList();
    }
    Map<String, dynamic> map = {
      'category_id': categoryId,
      'category_name': categoryName,
      'default_fuel_type': defaultFuelType.toJson(),
      'allowed_fuel_types': allowedFuelTypesSetStr
    };
    return map;
  }

  bool operator ==(o) => o is FuelCategory && o.categoryId == categoryId;

  int get hashCode => categoryId.hashCode;
}
