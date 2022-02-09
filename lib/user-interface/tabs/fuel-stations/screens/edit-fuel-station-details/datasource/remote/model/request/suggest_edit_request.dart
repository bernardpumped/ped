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

class SuggestEditRequest extends Request {
  final String identityProvider;
  final String oauthToken;
  final String oauthTokenSecret;
  final int fuelStationId;
  final String fuelStationSource;
  final String suggestion;

  SuggestEditRequest(
      {uuid,
      this.identityProvider,
      this.oauthToken,
      this.oauthTokenSecret,
      this.fuelStationId,
      this.fuelStationSource,
      this.suggestion})
      : super(uuid);

  @override
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'identityProvider': identityProvider,
        'oauthToken': oauthToken,
        'oauthTokenSecret': oauthTokenSecret,
        'fuelStationId': fuelStationId,
        'fuelStationSource': fuelStationSource,
        'suggestion': suggestion
      };
}
