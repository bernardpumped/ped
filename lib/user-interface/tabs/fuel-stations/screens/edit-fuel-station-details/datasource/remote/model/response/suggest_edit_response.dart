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

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/update_response.dart';

class SuggestEditResponse extends UpdateResponse {
  SuggestEditResponse(
      {final String responseCode,
      final String responseDetails,
      final Map<String, dynamic> invalidArguments,
      final int responseEpoch,
      final List<dynamic> exceptionCodes,
      final Map<String, dynamic> updateResult,
      final int fuelStationId,
      final String fuelStationSource,
      final int updateEpoch,
      final String uuid,
      final bool successfulUpdate})
      : super(responseCode, responseDetails, invalidArguments, responseEpoch, exceptionCodes, updateResult,
            fuelStationId, fuelStationSource, updateEpoch, uuid, successfulUpdate);

  factory SuggestEditResponse.fromJson(final Map<String, dynamic> json) {
    return SuggestEditResponse(
        responseCode: json['responseCode'],
        responseDetails: json['responseDetails'],
        invalidArguments: json['invalidArguments'],
        responseEpoch: json['responseEpoch'],
        exceptionCodes: json['exceptionCodes'],
        updateResult: json['updateResult'],
        fuelStationId: json['fuelStationId'],
        fuelStationSource: json['fuelStationSource'],
        updateEpoch: json['updateEpoch'],
        uuid: json['uuid'],
        successfulUpdate: json['successfulUpdate']);
  }
}
