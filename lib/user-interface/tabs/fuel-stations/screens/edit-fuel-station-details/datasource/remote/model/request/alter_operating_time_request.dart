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

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/dto/operating_time_vo.dart';
import 'package:pumped_end_device/data/remote/model/request/request.dart';

class AlterOperatingTimeRequest extends Request {
  final int fuelStationId;
  final String authValidatorType;
  final String oauthToken;
  final String oauthTokenSecret;
  final List<OperatingTimeVo> operatingTimeVos;
  final String featureType;
  final String fuelStationSource;
  final String identityProvider;

  AlterOperatingTimeRequest(
      {uuid,
      this.fuelStationId,
      this.authValidatorType,
      this.oauthToken,
      this.oauthTokenSecret,
      this.operatingTimeVos,
      this.featureType,
      this.fuelStationSource,
      this.identityProvider})
      : super(uuid);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'fuelStationId': fuelStationId,
        'authValidatorType': authValidatorType,
        'oauthToken': oauthToken,
        'oauthTokenSecret': oauthTokenSecret,
        'featureType': featureType,
        'fuelStationSource': fuelStationSource,
        'operatingTimeVos': operatingTimeVos,
        'identityProvider': identityProvider
      };
}
