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
import 'package:pumped_end_device/data/remote/model/request/request.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/screens/datasource/remote/model/response/get_backend_metadata_response.dart';
import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';


class GetBackendMetadata extends HttpGetExecutor<Request, GetBackendMetadataResponse> {
  GetBackendMetadata(final ResponseParser<GetBackendMetadataResponse> responseParser)
      : super(responseParser, 'GetBackendMetadata');

  @override
  GetBackendMetadataResponse getDefaultResponse(
      final String responseCode, final String responseDetails, final int responseEpoch, final Request request) {
    return GetBackendMetadataResponse(responseCode, responseDetails, {}, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  String getUrl(final Request request) {
    return "/getBackendMetadata";
  }
}
