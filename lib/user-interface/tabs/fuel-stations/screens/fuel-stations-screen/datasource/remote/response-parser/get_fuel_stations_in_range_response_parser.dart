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

import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/response/get_fuel_stations_in_range_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/response-parser/utils/fuel_station_details_response_parse_utils.dart';
import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped/market_region_config.dart';
import 'package:pumped_end_device/models/pumped/zone_config.dart';
import 'package:pumped_end_device/models/pumped_exception.dart';
import 'package:pumped_end_device/util/log_util.dart';

class GetFuelStationsInRangeResponseParser extends ResponseParser<GetFuelStationsInRangeResponse> {
  static const _tag = 'GetFuelStationsInRangeResponseParser';
  final String? fuelAuthorityId;

  GetFuelStationsInRangeResponseParser(this.fuelAuthorityId);

  @override
  GetFuelStationsInRangeResponse parseResponse(final String response) {
    final Map<String, dynamic> responseJson = convert.jsonDecode(response);
    final String responseCode = responseJson['responseCode'];
    LogUtil.debug(_tag, 'Response Code : $responseCode');
    final String? responseDetails = responseJson['responseDetails'];
    final Map<String, dynamic>? invalidArguments = responseJson['invalidArguments'];
    final int responseEpoch = responseJson['responseEpoch'];
    if (responseCode == 'NODATA_EXCEPTION') {
      return GetFuelStationsInRangeResponse(responseCode, responseDetails, invalidArguments, responseEpoch, null, null, false);
    }
    // TODO Take action based on invalidArgs
    final MarketRegionZoneConfiguration? marketRegionZoneConfiguration = _getMarketRegionZoneConfiguration(responseJson);
    bool configChanged = false;
    if (marketRegionZoneConfiguration != null) {
      configChanged = true;
    }
    if (fuelAuthorityId == null && marketRegionZoneConfiguration == null) {
      throw PumpedException('IllegalState fuelAuthorityId and marketRegion both null');
    }
    final String? resolvedFuelAuthorityId = marketRegionZoneConfiguration != null
        ? marketRegionZoneConfiguration.marketRegionConfig.fuelAuthorityId
        : fuelAuthorityId;
    final Map<String, List<FuelQuote>> stationIdFuelQuotes =
        FuelStationDetailsResponseParseUtils.getStationIdFuelQuotesMap(responseJson, resolvedFuelAuthorityId);
    final Map<String, FuelStation> stationIdStationMap =
        FuelStationDetailsResponseParseUtils.getStationIdStationMap(responseJson, stationIdFuelQuotes);
    LogUtil.debug(_tag, 'stationIdStationMap ${stationIdStationMap.length}');
    return GetFuelStationsInRangeResponse(responseCode, responseDetails, invalidArguments, responseEpoch,
        stationIdStationMap.values.toList(), marketRegionZoneConfiguration, configChanged);
  }

  static MarketRegionZoneConfiguration? _getMarketRegionZoneConfiguration(final Map<String, dynamic> responseJsonVals) {
    final Map<String, dynamic>? configVosJsonVals = responseJsonVals['configVo'];
    if (configVosJsonVals != null && configVosJsonVals.isNotEmpty) {
      LogUtil.debug(_tag, '_getMarketRegionZoneConfiguration version : ${configVosJsonVals['configVersion']}');
      return MarketRegionZoneConfiguration(
          marketRegionConfig: _getMarketRegionConfig(configVosJsonVals),
          version: configVosJsonVals['configVersion'],
          zoneConfig: _getZoneConfig(configVosJsonVals));
    } else {
      return null;
    }
  }

  static MarketRegionConfig _getMarketRegionConfig(final Map<String, dynamic> configVosJsonVals) {
    final Map<String, dynamic> mrcvo = configVosJsonVals['mrcvo'];
    final Map<String, dynamic> defaultFuelMeasureVoJsonVal = mrcvo['defaultFuelMeasure'];
    final Map<String, dynamic> currencyJsonVal = mrcvo['currency'];
    final String currencyValueFormat = mrcvo['currencyValueFormat'];
    final Map<String, dynamic> defaultDistanceMeasureJsonVal = mrcvo['defaultDistanceMeasure'];
    final FuelCategory defaultFuelCategory = _getFuelCategory(mrcvo['defaultFuelCategoryVo']);
    final List<dynamic>? fuelCategoryVosJsonVal = mrcvo['fuelCategoryVos'];
    final Set<FuelCategory> allowedFuelCategories = {};
    if (fuelCategoryVosJsonVal != null) {
      for (final Map<String, dynamic> fuelCategoryVoJsonVal in fuelCategoryVosJsonVal) {
        allowedFuelCategories.add(_getFuelCategory(fuelCategoryVoJsonVal));
      }
    } else {
      LogUtil.debug(_tag, 'fuelCategoryVos is null');
    }
    if (defaultFuelCategory.allowedFuelTypes.isEmpty) {
      _populateFuelTypesInDefaultFuelCategory(allowedFuelCategories, defaultFuelCategory);
    }
    return MarketRegionConfig(
        fuelMeasure: defaultFuelMeasureVoJsonVal['measure'],
        defaultFuelCategory: defaultFuelCategory,
        allowedFuelCategories: allowedFuelCategories,
        currency: currencyJsonVal['type'],
        currencyValueFormat: currencyValueFormat,
        distanceMeasure: defaultDistanceMeasureJsonVal['measure'],
        fuelAuthorityId: mrcvo['fuelAuthorityId'],
        fuelAuthorityName: mrcvo['fuelAuthorityName'],
        incrementalSearch: mrcvo['incrSearch'],
        incrementalSearchValue: mrcvo['incrSearchValue'],
        marketRegionConfigVersion: mrcvo['configVersion'],
        marketRegionId: mrcvo['id'],
        marketRegionName: mrcvo['name'],
        maxDefaultFuelPrice: mrcvo['maxDefaultFuelPrice'],
        minDefaultFuelPrice: mrcvo['minDefaultFuelPrice'],
        maxNumberOfResults: mrcvo['maxNumberOfResults'],
        searchRange: mrcvo['rangeValue'],
        sortOrder: mrcvo['sortOrder']);
  }

  static FuelCategory _getFuelCategory(final Map<String, dynamic> fuelCategoryVo) {
    final FuelType defaultFuelType = _getFuelType(fuelCategoryVo['defaultFuelTypeVo']);
    final List<dynamic>? allowedFuelTypeVos = fuelCategoryVo['allowedFuelTypes'];
    final Set<FuelType> allowedFuelTypes = {};
    if (allowedFuelTypeVos != null) {
      for (final allowedFuelTypeVo in allowedFuelTypeVos) {
        allowedFuelTypes.add(_getFuelType(allowedFuelTypeVo));
      }
    } else {
      LogUtil.debug(_tag, 'allowedFuelTypeVos is null');
    }
    return FuelCategory(
        categoryId: fuelCategoryVo['categoryId'],
        categoryName: fuelCategoryVo['categoryName'],
        defaultFuelType: defaultFuelType,
        allowedFuelTypes: allowedFuelTypes);
  }

  static FuelType _getFuelType(final Map<String, dynamic> fuelTypeVo) {
    return FuelType(fuelType: fuelTypeVo['type'], fuelName: fuelTypeVo['displayName']);
  }

  static ZoneConfig _getZoneConfig(final Map<String, dynamic> configVosJsonVals) {
    final Map<String, dynamic> zcvo = configVosJsonVals['zcvo'];
    return ZoneConfig(
        zoneType: zcvo['zoneType'],
        rightLongitude: zcvo['rightLongitude'],
        bottomLatitude: zcvo['bottomLatitude'],
        leftLongitude: zcvo['leftLongitude'],
        zoneStatus: zcvo['zoneStatus'],
        topLatitude: zcvo['topLatitude'],
        minTimeLocationUpdates: zcvo['minTimeLocationUpdates'],
        minDistanceLocationUpdates: zcvo['minDistanceLocationUpdates'],
        inProd: zcvo['inProd'],
        configVersion: zcvo['configVersion'],
        maxRadius: zcvo['maxRadius'],
        marketRegion: zcvo['marketRegion'],
        zoneId: zcvo['zoneId']);
  }

  //Backend is not setting the allowed fuelTypes in defaultFuelCategory
  //So populating it in the app.
  static void _populateFuelTypesInDefaultFuelCategory(
      final Set<FuelCategory> allowedFuelCategories, final FuelCategory defaultFuelCategory) {
    for (var fuelCategory in allowedFuelCategories) {
      if (fuelCategory.categoryId == defaultFuelCategory.categoryId) {
        defaultFuelCategory.allowedFuelTypes.addAll(fuelCategory.allowedFuelTypes);
        return;
      }
    }
  }
}
