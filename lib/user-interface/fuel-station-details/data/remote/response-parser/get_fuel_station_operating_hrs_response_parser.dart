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

import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/model/response/get_fuel_station_operating_hrs_response.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/response-parser/operating_hours_response_parse_utils.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class GetFuelStationOperatingHrsResponseParser extends ResponseParser<GetFuelStationOperatingHrsResponse> {
  static const _tag = 'GetFuelStationOperatingHrsResponseParser';

  @override
  GetFuelStationOperatingHrsResponse parseResponse(final String response) {
    final Map<String, dynamic> responseJson = convert.jsonDecode(response);
    final String responseCode = responseJson['responseCode'];
    LogUtil.debug(_tag, 'Response Code : $responseCode');
    final Map<String, dynamic> invalidArguments = responseJson['invalidArguments'];
    final int responseEpoch = responseJson['responseEpoch'];
    final String? responseDetails = responseJson['responseDetails'];
    return GetFuelStationOperatingHrsResponse(
        responseCode, responseDetails, invalidArguments, responseEpoch, _getFuelStationOperatingHrs(responseJson));
  }

  static FuelStationOperatingHrs _getFuelStationOperatingHrs(final Map<String, dynamic> responseJson) {
    final fuelStationId = responseJson['fuelStationId'];
    final List<OperatingHours> weeklyOperatingHrs = [];
    final detailsVoJson = responseJson['detailsVo'];
    if (detailsVoJson != null) {
      final Map<String, dynamic>? operatingTimeJson = detailsVoJson['operatingTimeVoMap'];
      if (operatingTimeJson != null) {
        final List<dynamic> fuelFullOperatingTimes = operatingTimeJson['FUEL-FILL'];
        for (final Map<String, dynamic> jsonVal in fuelFullOperatingTimes) {
          final OperatingHours? operatingHours = OperatingHoursResponseParseUtils.getOperatingHours(jsonVal, null);
          if (operatingHours != null) {
            weeklyOperatingHrs.add(operatingHours);
          }
        }
      }
    }
    weeklyOperatingHrs.sort((o1, o2) {
      final int? dayOneInt = DateTimeUtils.shortNameToWeekDayInt[o1.dayOfWeek];
      final int? dayTwoInt = DateTimeUtils.shortNameToWeekDayInt[o2.dayOfWeek];
      if (dayOneInt == null && dayTwoInt != null) {
        return -1;
      } else if (dayOneInt != null && dayTwoInt == null) {
        return 1;
      } else {
        return (dayOneInt as int).compareTo(dayTwoInt as int);
      }
    });
    return FuelStationOperatingHrs(stationId: fuelStationId, weeklyOperatingHrs: weeklyOperatingHrs);
  }
}
