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
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/request/alter_operating_time_request.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/alter_operating_time_response.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/reponse-parser/alter_operating_time_response_parser.dart';

class PostOperatingTimeUpdate extends HttpPostExecutor<AlterOperatingTimeRequest, AlterOperatingTimeResponse> {
  PostOperatingTimeUpdate(AlterOperatingTimeResponseParser responseParser)
      : super('PostOperatingTimeUpdate', responseParser);

  @override
  AlterOperatingTimeResponse getDefaultResponse(final String responseCode, final String responseDetails,
      final int responseEpoch, final AlterOperatingTimeRequest request) {
    return AlterOperatingTimeResponse(
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
    return "/enddevice/updateOperatingTimes";
  }
}
