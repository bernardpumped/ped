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

import 'package:pumped_end_device/data/remote/http_get_executor.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/request/get_fuel_station_details_batch_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/response/get_fuel_station_details_batch_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/response-parser/get_fuel_station_details_batch_response_parser.dart';

class GetFuelStationDetailsBatch
    extends HttpGetExecutor<GetFuelStationDetailsBatchRequest, GetFuelStationDetailsBatchResponse> {
  GetFuelStationDetailsBatch(final GetFuelStationDetailsBatchResponseParser responseParser)
      : super(responseParser, 'GetFuelStationDetailsBatch');

  @override
  String getUrl(final GetFuelStationDetailsBatchRequest request) {
    String url = '/getFuelStationDetailsBatch' + '?';
    String param1;
    if (request.fuelStationIds != null && request.fuelStationIds.length > 0) {
      param1 = 'fuelStationId=' + request.fuelStationIds.join('&fuelStationId=');
    }
    String param2;
    if (request.fuelAuthorityStationIds != null && request.fuelAuthorityStationIds.length > 0) {
      param2 = 'fuelAuthorityStationId=' + request.fuelAuthorityStationIds.join('&fuelAuthorityStationId=');
    }
    if (param1 != null) {
      url = url + param1;
    }
    if (param2 != null) {
      if (param1 != null) {
        url = url + '&' + param2;
      } else {
        url = url + param2;
      }
    }
    return '$url&latitude=${request.latitude}&longitude=${request.longitude}&dayOfWeek=${request.dayOfWeek}';
  }

  @override
  GetFuelStationDetailsBatchResponse getDefaultResponse(final String responseCode, final String responseDetails,
      final int responseEpoch, final GetFuelStationDetailsBatchRequest request) {
    return GetFuelStationDetailsBatchResponse(responseCode, responseDetails, {}, responseEpoch, []);
  }
}
