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
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/dto/fuel_quote_vo.dart';

class AlterFuelQuotesRequest extends Request {
  final int fuelStationId;
  final String fuelStationSource;
  final String? oauthToken;
  final String oauthTokenSecret;
  final String oauthValidatorType;
  final String identityProvider;
  final List<FuelQuoteVo> fuelQuoteVos;

  AlterFuelQuotesRequest(
      {uuid,
      required this.fuelStationId,
      required this.fuelStationSource,
      this.oauthToken,
      required this.oauthTokenSecret,
      required this.oauthValidatorType,
      required this.identityProvider,
      required this.fuelQuoteVos})
      : super(uuid);

  @override
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
