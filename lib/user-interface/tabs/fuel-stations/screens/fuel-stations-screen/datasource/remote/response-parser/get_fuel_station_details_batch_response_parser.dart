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

import 'dart:convert' as convert;

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/response/get_fuel_station_details_batch_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/response-parser/utils/fuel_station_details_response_parse_utils.dart';
import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped_exception.dart';
import 'package:pumped_end_device/util/log_util.dart';

class GetFuelStationDetailsBatchResponseParser extends ResponseParser<GetFuelStationDetailsBatchResponse> {
  static const _tag = 'GetFuelStationDetailsBatchResponseParser';
  final String? authorityId;

  GetFuelStationDetailsBatchResponseParser(this.authorityId);

  @override
  GetFuelStationDetailsBatchResponse parseResponse(final String response) {
    final Map<String, dynamic> responseJson = convert.jsonDecode(response);
    final String responseCode = responseJson['responseCode'];
    final String responseDetails = responseJson['responseDetails'];
    final Map<String, dynamic> invalidArguments = responseJson['invalidArguments'];
    final int responseEpoch = responseJson['responseEpoch'];
    LogUtil.debug(_tag, 'Response Code : $responseCode');
    if (authorityId == null) {
      throw PumpedException('FuelAuthorityId is null');
    }
    final Map<String, List<FuelQuote>> stationIdFuelQuotes =
        FuelStationDetailsResponseParseUtils.getStationIdFuelQuotesMap(responseJson, authorityId);
    final Map<String, FuelStation> stationIdStationMap =
        FuelStationDetailsResponseParseUtils.getStationIdStationMap(responseJson, stationIdFuelQuotes);
    LogUtil.debug(_tag, 'stationIdStationMap ${stationIdStationMap.length}');
    return GetFuelStationDetailsBatchResponse(
        responseCode, responseDetails, invalidArguments, responseEpoch, stationIdStationMap.values.toList());
  }
}
