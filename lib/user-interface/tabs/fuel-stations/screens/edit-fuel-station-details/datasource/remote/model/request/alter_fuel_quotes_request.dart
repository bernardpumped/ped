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

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/dto/fuel_quote_vo.dart';
import 'package:pumped_end_device/data/remote/model/request/request.dart';

class AlterFuelQuotesRequest extends Request {
  final int fuelStationId;
  final String fuelStationSource;
  final String oauthToken;
  final String oauthTokenSecret;
  final String oauthValidatorType;
  final String identityProvider;
  final List<FuelQuoteVo> fuelQuoteVos;

  AlterFuelQuotesRequest(
      {uuid,
      this.fuelStationId,
      this.fuelStationSource,
      this.oauthToken,
      this.oauthTokenSecret,
      this.oauthValidatorType,
      this.identityProvider,
      this.fuelQuoteVos})
      : super(uuid);

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'fuelStationId': fuelStationId,
        'fuelStationSource': fuelStationSource,
        'authValidatorType': oauthValidatorType,
        'oauthToken': oauthToken,
        'oauthTokenSecret': oauthTokenSecret,
        'identityProvider': identityProvider,
        'fuelQuoteVos': fuelQuoteVos
      };
}