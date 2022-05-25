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

class FavoriteFuelStation {
  @required
  final int favoriteFuelStationId;
  @required
  final String fuelStationSource;

  FavoriteFuelStation({required this.favoriteFuelStationId, required this.fuelStationSource});

  factory FavoriteFuelStation.fromJson(final Map<String, dynamic> data) {
    return FavoriteFuelStation(
      favoriteFuelStationId: data['favorite_fuel_station_id'],
      fuelStationSource: data['fuel_station_source'],
    );
  }

  Map<String, dynamic> toMap() =>
      {'favorite_fuel_station_id': favoriteFuelStationId, 'fuel_station_source': fuelStationSource};

  Map<String, dynamic> toJson() =>
      {'favorite_fuel_station_id': favoriteFuelStationId, 'fuel_station_source': fuelStationSource};
}
