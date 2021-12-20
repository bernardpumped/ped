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

import 'package:pumped_end_device/data/remote/model/request/request.dart';

class EndDeviceUpdateFuelStationFeatureRequest extends Request {
  final int fuelStationId;
  final String fuelStationSource;
  final String oauthToken;
  final String oauthTokenSecret;
  final String identityProvider;
  final List<String> enabledFeatures;
  final List<String> disabledFeatures;
  EndDeviceUpdateFuelStationFeatureRequest(
      {uuid,
      this.oauthToken,
      this.oauthTokenSecret,
      this.identityProvider,
      this.fuelStationId,
      this.fuelStationSource,
      this.enabledFeatures,
      this.disabledFeatures})
      : super(uuid);

  @override
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'identityProvider': identityProvider,
        'oauthToken': oauthToken,
        'oauthTokenSecret': oauthTokenSecret,
        'fuelStationId': fuelStationId,
        'fuelStationSource': fuelStationSource,
        'enabledFeatures': enabledFeatures,
        'disabledFeatures': disabledFeatures
      };
}
