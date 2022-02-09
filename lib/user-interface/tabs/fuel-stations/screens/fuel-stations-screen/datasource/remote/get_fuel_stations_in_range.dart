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

import 'package:pumped_end_device/data/remote/http_get_executor.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/request/get_fuel_stations_in_range_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/response/get_fuel_stations_in_range_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/response-parser/get_fuel_stations_in_range_response_parser.dart';

class GetFuelStationsInRange extends HttpGetExecutor<GetFuelStationsInRangeParams, GetFuelStationsInRangeResponse> {
  GetFuelStationsInRange(GetFuelStationsInRangeResponseParser responseParser)
      : super(responseParser, 'GetFuelStationsInRange');

  @override
  GetFuelStationsInRangeResponse getDefaultResponse(final String responseCode, final String responseDetails,
      final int responseEpoch, final GetFuelStationsInRangeParams request) {
    return GetFuelStationsInRangeResponse(responseCode, responseDetails, {}, responseEpoch, [], null, false);
  }

  @override
  String getUrl(GetFuelStationsInRangeParams request) {
    return '/getFuelStationsInRange' '?' + request.toQueryString();
  }
}
