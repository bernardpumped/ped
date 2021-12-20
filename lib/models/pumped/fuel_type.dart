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

class FuelType {
  final String fuelType;
  final String fuelName;

  FuelType({this.fuelType, this.fuelName});

  factory FuelType.fromJson(Map<String, dynamic> data) => new FuelType(
    fuelType : data['fuel_type'],
    fuelName : data['fuel_name'],
  );

  Map<String, dynamic> toJson() => {
    'fuel_type': fuelType,
    'fuel_name': fuelName,
  };

  bool operator == (o) => o is FuelType && fuelType == o.fuelType;
  int get hashCode => fuelType.hashCode;
}
