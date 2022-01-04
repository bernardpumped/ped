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

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/alter_fuel_quotes_response.dart';
import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';

class AlterFuelQuotesResponseParser extends ResponseParser<AlterFuelQuotesResponse> {
  @override
  AlterFuelQuotesResponse parseResponse(final String response) {
    return AlterFuelQuotesResponse.fromJson(convert.jsonDecode(response));
  }
}
