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

import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/dto/fuel_authority_price_metadata_vo.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/get_fuel_authority_price_meta_data_response.dart';
import 'package:pumped_end_device/util/log_util.dart';

class GetFuelAuthorityPriceMetaDataResponseParser extends ResponseParser<GetFuelAuthorityPriceMetaDataResponse> {
  static const _tag = 'GetFuelAuthorityPriceMetaDataResponseParser';

  @override
  GetFuelAuthorityPriceMetaDataResponse parseResponse(final String response) {
    final Map<String, dynamic> responseJson = convert.jsonDecode(response);
    final String responseCode = responseJson['responseCode'];
    LogUtil.debug(_tag, 'Response Code : $responseCode');
    final String? responseDetails = responseJson['responseDetails'];
    final Map<String, dynamic>? invalidArguments = responseJson['invalidArguments'];
    final int responseEpoch = responseJson['responseEpoch'];
    return GetFuelAuthorityPriceMetaDataResponse(responseCode, responseDetails, invalidArguments, responseEpoch,
        _getAuthorityId(responseJson), _getMetadata(responseJson));
  }

  static String _getAuthorityId(final Map<String, dynamic> responseJson) {
    return responseJson['authorityId'];
  }

  static List<FuelAuthorityPriceMetadataVo> _getMetadata(final Map<String, dynamic> responseJson) {
    final metadataVosJson = responseJson['metadataVos'];
    final List<FuelAuthorityPriceMetadataVo> metadataVos = [];
    if (metadataVosJson != null) {
      for (final Map<String, dynamic> metadataVoJson in metadataVosJson) {
        final FuelAuthorityPriceMetadataVo metadataVo = FuelAuthorityPriceMetadataVo(
            metadataVoJson['minPrice'],
            metadataVoJson['maxPrice'],
            metadataVoJson['minTolerancePercent'],
            metadataVoJson['maxTolerancePercent'],
            metadataVoJson['fuelMeasure'],
            metadataVoJson['fuelType'],
            metadataVoJson['fuelAuthority']);
        metadataVo.decimalPositionVo = _getDecimalPositionVo(metadataVoJson);
        metadataVos.add(metadataVo);
      }
    }
    return metadataVos;
  }

  static DecimalPositionVo _getDecimalPositionVo(final Map<String, dynamic> metadataVoJson) {
    final Map<String, dynamic> decimalPositionVoJson = metadataVoJson['decimalPositionVo'];
    return DecimalPositionVo(decimalPositionVoJson['decPosForAllowedMaxForChar'],
        decimalPositionVoJson['allowedMaxFirstChar'], decimalPositionVoJson['alternatePos']);
  }
}
