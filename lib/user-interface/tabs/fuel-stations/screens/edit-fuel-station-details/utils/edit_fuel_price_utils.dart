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

import 'package:pumped_end_device/data/local/dao/fuel_authority_price_metadata_dao.dart';
import 'package:pumped_end_device/data/local/dao/market_region_zone_config_dao.dart';
import 'package:pumped_end_device/data/local/market_region_zone_config_utils.dart';
import 'package:pumped_end_device/data/local/model/fuel_authority_price_metadata.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/get_fuel_authority_price_meta_data.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/dto/fuel_authority_price_metadata_vo.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/request/get_fuel_authority_price_metadata_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/get_fuel_authority_price_meta_data_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/reponse-parser/get_fuel_authority_price_meta_data_response_parser.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/edit_fuel_price_widget_data.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped_exception.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class EditFuelPriceUtils {
  static const _TAG = 'EditFuelStationDetailsScreenUtils';
  static final MarketRegionZoneConfigUtils _marketRegionZoneConfigUtils = new MarketRegionZoneConfigUtils();

  Future<EditFuelPriceWidgetData> editFuelPriceWidgetData() async {
    final MarketRegionZoneConfiguration marketRegionZoneConfiguration =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    final List<FuelAuthorityPriceMetadata> metadataForFuelAuthority =
        await _getLatestFuelAuthorityPriceMetadata(marketRegionZoneConfiguration.marketRegionConfig.fuelAuthorityId);
    final currencyValueFormat = marketRegionZoneConfiguration.marketRegionConfig.currencyValueFormat;
    final List<FuelType> fuelTypesForMarketRegion = await _marketRegionZoneConfigUtils.getFuelTypesForMarketRegion();
    return new EditFuelPriceWidgetData(metadataForFuelAuthority, fuelTypesForMarketRegion, currencyValueFormat);
  }

  Future<List<FuelAuthorityPriceMetadata>> _getLatestFuelAuthorityPriceMetadata(final String authorityId) async {
    final MarketRegionZoneConfiguration config =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    if (config != null) {
      final List<FuelAuthorityPriceMetadata> currentMetadata =
          await FuelAuthorityPriceMetadataDao.instance.getFuelAuthorityPriceMetadata(authorityId);
      final GetFuelAuthorityPriceMetadataRequest request =
          GetFuelAuthorityPriceMetadataRequest(requestUuid: Uuid().v1(), authorityId: authorityId);
      if (currentMetadata != null && currentMetadata.isNotEmpty) {
        // Assumption is all these marketRegionZoneConfigVersions will be same
        final List<String> marketRegionZoneConfigVersion =
            currentMetadata.map((e) => e.marketRegionZoneConfigVersion).toList();
        LogUtil.debug(
            _TAG,
            'MarketRegionZoneConfiguration.version ${config.version} ' +
                ' and FuelAuthorityPriceMetadata.version ${marketRegionZoneConfigVersion[0]}');
        if (marketRegionZoneConfigVersion[0] != config.version) {
          LogUtil.debug(
              _TAG, 'Current metadata exists but version is different from market region zone config. Querying');
          // MarketRegionZoneConfig has changed. Chances are there is new metadata on server. Querying.
          GetFuelAuthorityPriceMetaDataResponse response;
          try {
            response =
                await GetFuelAuthorityPriceMetaData(GetFuelAuthorityPriceMetaDataResponseParser()).execute(request);
          } on Exception catch (e, s) {
            LogUtil.debug(_TAG, 'Exception occurred while calling GetFuelAuthorityPriceMetaDataNew.execute $s');
            response = GetFuelAuthorityPriceMetaDataResponse(
                'CALL-EXCEPTION', s.toString(), {}, DateTime.now().millisecondsSinceEpoch, request.authorityId, []);
          }
          return _processLatestResponse(response, authorityId, currentMetadata, config.version);
        } else {
          // Current fuelAuthorityPriceMetadata marketRegionZoneConfigVersion is
          // same as MarketRegionZoneConfiguration.version return same data
          return currentMetadata;
        }
      } else {
        LogUtil.debug(_TAG, 'Current metadata does not exist. Querying.');
        GetFuelAuthorityPriceMetaDataResponse response;
        try {
          response =
              await GetFuelAuthorityPriceMetaData(GetFuelAuthorityPriceMetaDataResponseParser()).execute(request);
        } on Exception catch (e, s) {
          LogUtil.debug(_TAG, 'Exception occurred while calling GetFuelAuthorityPriceMetaDataNew.execute $s');
          response = GetFuelAuthorityPriceMetaDataResponse(
              'CALL-EXCEPTION', s.toString(), {}, DateTime.now().millisecondsSinceEpoch, request.authorityId, []);
        }
        return _processLatestResponse(response, authorityId, [], config.version);
      }
    } else {
      /*
        Config being null here is a problem, as the config should get populated as soon as application is loaded
      */
      var message = 'Error processing getLatestFuelAuthorityPriceMetadata as MarketRegionZoneConfig is not present';
      LogUtil.debug(_TAG, message);
      throw PumpedException(message);
    }
  }

  Future<List<FuelAuthorityPriceMetadata>> _processLatestResponse(final GetFuelAuthorityPriceMetaDataResponse response,
      final String authorityId, final List<FuelAuthorityPriceMetadata> currentMetadata, final String version) async {
    if (response.responseCode == 'SUCCESS' && response.metadata.isNotEmpty) {
      for (final FuelAuthorityPriceMetadata currentMetadatum in currentMetadata) {
        final int deleteResult =
            await FuelAuthorityPriceMetadataDao.instance.deleteFuelAuthorityPriceMetadata(currentMetadatum);
        LogUtil.debug(_TAG,
            'Delete result for metadata : ${currentMetadatum.fuelAuthority}-${currentMetadatum.fuelType} is $deleteResult');
      }
      final List<FuelAuthorityPriceMetadata> latestMetadata = _transform(response.metadata, authorityId, version);
      for (final FuelAuthorityPriceMetadata latestMetadatum in latestMetadata) {
        final int insertResult =
            await FuelAuthorityPriceMetadataDao.instance.insertFuelAuthorityPriceMetadata(latestMetadatum);
        LogUtil.debug(_TAG, 'FuelAuthorityPriceMetadata successfully inserted $insertResult');
      }
      return latestMetadata;
    } else {
      var message = 'Proper response not received from server response code : ${response.responseCode} ' +
          'and isEmpty ? ${response.metadata.isEmpty}';
      LogUtil.debug(_TAG, message);
      return Future.value(List.empty());
      // throw PumpedException(message);
    }
  }

  List<FuelAuthorityPriceMetadata> _transform(final List<FuelAuthorityPriceMetadataVo> metadataVo,
      final String authorityId, final String marketRegionZoneConfigVersion) {
    final List<FuelAuthorityPriceMetadata> metadata = [];
    for (final FuelAuthorityPriceMetadataVo metadatumVo in metadataVo) {
      metadata.add(FuelAuthorityPriceMetadata(
          minPrice: metadatumVo.minPrice,
          minTolerancePercent: metadatumVo.minTolerancePercent,
          maxPrice: metadatumVo.maxPrice,
          maxTolerancePercent: metadatumVo.maxTolerancePercent,
          fuelMeasure: metadatumVo.fuelMeasure,
          fuelType: metadatumVo.fuelType,
          marketRegionZoneConfigVersion: marketRegionZoneConfigVersion,
          fuelAuthority: authorityId,
          decPosForAllowedMaxForChar: metadatumVo.decimalPositionVo.decPosForAllowedMaxForChar,
          allowedMaxFirstChar: metadatumVo.decimalPositionVo.allowedMaxFirstChar,
          alternatePos: metadatumVo.decimalPositionVo.alternatePos));
    }
    return metadata;
  }
}
