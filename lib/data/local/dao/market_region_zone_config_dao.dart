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
 *     along with Pumped End Device  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/market_region_config.dart';
import 'package:pumped_end_device/models/pumped/zone_config.dart';
import 'package:pumped_end_device/util/log_util.dart';

class MarketRegionZoneConfigDao {
  static const _TAG = 'MarketRegionZoneConfigDao';

  static const _COLLECTION_MARKET_REGION_CONFIG = 'pumped_market_region_config';
  static const _MARKET_REGION_DOC_ID = 'market_region';
  static const _COLLECTION_ZONE_CONFIG = "pumped_zone_config";
  static const _ZONE_DOC_ID = 'zone';
  static const _COLLECTION_VERSION = 'pumped_market_region_zone_config_version';
  static const _VERSION_ID = 'version-id';

  static final MarketRegionZoneConfigDao instance = MarketRegionZoneConfigDao._();
  MarketRegionZoneConfigDao._();

  Future<MarketRegionZoneConfiguration> getMarketRegionZoneConfiguration() async {
    final db = Localstore.instance;
    final Map<String, dynamic> versionIdMap = await db.collection(_COLLECTION_VERSION).doc(_VERSION_ID).get();
    if (versionIdMap != null && versionIdMap.length > 0) {
      final String versionId = versionIdMap[_VERSION_ID];
      LogUtil.debug(_TAG, 'versionId $versionId found from db.');
      LogUtil.debug(_TAG, 'MarketRegionConfigId key - ${_getMarketRegionConfigDocId(versionId)}');
      final Map<String, dynamic> mktRegionDataAsMap = await db.collection(_COLLECTION_MARKET_REGION_CONFIG)
          .doc(_getMarketRegionConfigDocId(versionId)).get();

      LogUtil.debug(_TAG, 'ZoneConfigId key - ${_getZoneConfigDocId(versionId)}');
      final Map<String, dynamic> zoneDataAsMap = await db.collection(_COLLECTION_ZONE_CONFIG)
          .doc(_getZoneConfigDocId(versionId)).get();

      if (mktRegionDataAsMap != null && mktRegionDataAsMap.length > 0 && zoneDataAsMap != null && zoneDataAsMap.length > 0) {
        LogUtil.debug(_TAG, 'Creating MarketRegionZoneConfiguration response');
        return MarketRegionZoneConfiguration(marketRegionConfig: MarketRegionConfig.fromMap(mktRegionDataAsMap),
            zoneConfig: ZoneConfig.fromJson(zoneDataAsMap), version: versionId);
      } else {
        LogUtil.debug(_TAG, 'Size of mktRegionDataAsMap from db ${mktRegionDataAsMap != null ? mktRegionDataAsMap.length : 0}');
        LogUtil.debug(_TAG, 'Size of zoneDataAsMap from db ${zoneDataAsMap != null ? zoneDataAsMap.length : 0}');
      }
    }
    return null;
  }

  Future<dynamic> insertMarketRegionZoneConfiguration(final MarketRegionZoneConfiguration configuration) async {
    final db = Localstore.instance;
    LogUtil.debug(_TAG, 'Inserting MarketRegionConfigDoc using key ${_getMarketRegionConfigDocId(configuration.version)}');
    db.collection(_COLLECTION_MARKET_REGION_CONFIG).doc(_getMarketRegionConfigDocId(configuration.version)).set(configuration.marketRegionConfig.toMap());
    LogUtil.debug(_TAG, 'Inserting ZoneConfigDoc using key ${_getZoneConfigDocId(configuration.version)}');
    db.collection(_COLLECTION_ZONE_CONFIG).doc(_getZoneConfigDocId(configuration.version)).set(configuration.zoneConfig.toMap());
    LogUtil.debug(_TAG, 'Inserting versionId doc using key $_VERSION_ID');
    db.collection(_COLLECTION_VERSION).doc(_VERSION_ID).set({_VERSION_ID : configuration.version});
  }

  Future<Set<FuelCategory>> getFuelCategoriesFromMarketRegionZoneConfig() async {
    final db = Localstore.instance;
    final Map<String, dynamic> versionIdMap = await db.collection(_COLLECTION_VERSION).doc(_VERSION_ID).get();
    if (versionIdMap != null && versionIdMap.length > 0) {
      final String versionId = versionIdMap[_VERSION_ID];
      LogUtil.debug(_TAG, 'VersionId read from database $versionId');
      final Map<String, dynamic> mktRegionDataAsMap = await db.collection(_COLLECTION_MARKET_REGION_CONFIG)
          .doc(_getMarketRegionConfigDocId(versionId)).get();
      LogUtil.debug(_TAG, 'MktRegionDataAsMap size ${mktRegionDataAsMap != null ? mktRegionDataAsMap.length : 0}');
      if (mktRegionDataAsMap != null && mktRegionDataAsMap.length > 0) {
        final MarketRegionConfig mktRegionConfig = MarketRegionConfig.fromMap(mktRegionDataAsMap);
        LogUtil.debug(_TAG, 'AllowedFuelCategories size '
            '${mktRegionConfig.allowedFuelCategories != null ? mktRegionConfig.allowedFuelCategories.length : 0}');
        return mktRegionConfig.allowedFuelCategories;
      }
    }
    return null;
  }

  String _getMarketRegionConfigDocId(final String versionId) {
    return '$_MARKET_REGION_DOC_ID-$versionId';
  }

  String _getZoneConfigDocId(final String versionId) {
    return '$_ZONE_DOC_ID-$versionId';
  }
}