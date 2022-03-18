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

import 'package:pumped_end_device/data/remote/model/request/request.dart';
import 'package:pumped_end_device/models/fuel_station_search_config.dart';
import 'package:uuid/uuid.dart';

class GetFuelStationsInRangeParams extends Request {
  final double lat;
  final double lng;
  final double range;
  final String unit;
  final String fuelType;
  final num numResults;
  final String quoteSortOrder;
  final bool searchIncrementally;
  final String dayOfWeek;
  final String clientConfigVersion;
  final bool excludeVetoFuelStations;

  GetFuelStationsInRangeParams(
      {requestUuid,
        required this.lat,
        required this.lng,
        required this.range,
        required this.unit,
        required this.fuelType,
        required this.numResults,
        required this.quoteSortOrder,
        required this.searchIncrementally,
        required this.dayOfWeek,
        required this.clientConfigVersion,
        required this.excludeVetoFuelStations})
      : super(requestUuid);

  factory GetFuelStationsInRangeParams.get(final FuelStationSearchConfig config, final double lat, final double lng,
      final String day, final bool searchIncrementally, final bool excludeVetoFuelStations) {
    return GetFuelStationsInRangeParams(
        requestUuid: const Uuid().v1(),
        lat: lat,
        lng: lng,
        range: config.range,
        unit: config.defaultUnit,
        fuelType: 'ALL',
        clientConfigVersion: config.clientConfigVersion,
        numResults: config.numOfResults,
        quoteSortOrder: config.sortOrder,
        dayOfWeek: day,
        searchIncrementally: searchIncrementally,
        excludeVetoFuelStations: excludeVetoFuelStations);
  }

  String toQueryString() {
    return 'lat=$lat&lng=$lng&range=$range&unit=$unit&fuelType=$fuelType&'
        'numResults=$numResults&sortOrder=$quoteSortOrder&searchIncrementally=$searchIncrementally&'
        'dayOfWeek=$dayOfWeek&clientConfigVersion=$clientConfigVersion&excludeVetoFuelStations=$excludeVetoFuelStations';
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
