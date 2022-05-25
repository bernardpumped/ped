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

import 'package:pumped_end_device/data/remote/http_post_executor.dart';
import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/request/end_device_update_fuel_station_request.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/end_device_update_fuel_station_response.dart';

class PostEndDeviceFuelStationUpdate
    extends HttpPostExecutor<EndDeviceUpdateFuelStationRequest, EndDeviceUpdateFuelStationResponse> {
  PostEndDeviceFuelStationUpdate(final ResponseParser<EndDeviceUpdateFuelStationResponse> responseParser)
      : super('PostEndDeviceFuelStationUpdate', responseParser);

  @override
  EndDeviceUpdateFuelStationResponse getDefaultResponse(final String responseCode, final String responseDetails,
      final int responseEpoch, final EndDeviceUpdateFuelStationRequest request) {
    return EndDeviceUpdateFuelStationResponse(
        responseCode: responseCode,
        responseDetails: responseDetails,
        invalidArguments: {},
        responseEpoch: responseEpoch,
        exceptionCodes: [],
        updateResult: {},
        updateEpoch: responseEpoch,
        uuid: request.uuid,
        successfulUpdate: false,
        fuelStationId: request.fuelStationId,
        fuelStationSource: request.fuelStationSource);
  }

  @override
  String getUrl() {
    return "/enddevice/updateFuelStation";
  }
}
