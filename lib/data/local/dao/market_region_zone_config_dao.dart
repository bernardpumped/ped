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
 *     along with Pumped End Device  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/market_region_config.dart';
import 'package:pumped_end_device/models/pumped/zone_config.dart';
import 'package:pumped_end_device/util/log_util.dart';

class MarketRegionZoneConfigDao {
  static const _tag = 'MarketRegionZoneConfigDao';

  static const _collectionMarketRegionConfig = 'pumped_market_region_config';
  static const _marketRegionDocId = 'market_region';
  static const _collectionZoneConfig = "pumped_zone_config";
  static const _zoneDocId = 'zone';
  static const _collectionVersion = 'pumped_market_region_zone_config_version';
  static const _versionId = 'version-id';

  static final MarketRegionZoneConfigDao instance = MarketRegionZoneConfigDao._();
  MarketRegionZoneConfigDao._();

  Future<MarketRegionZoneConfiguration?> getMarketRegionZoneConfiguration() async {
    final db = Localstore.instance;
    final Map<String, dynamic>? versionIdMap = await db.collection(_collectionVersion).doc(_versionId).get();
    if (versionIdMap != null && versionIdMap.isNotEmpty) {
      final String versionId = versionIdMap[_versionId];
      LogUtil.debug(_tag, 'versionId $versionId found from db.');
      LogUtil.debug(_tag, 'MarketRegionConfigId key - ${_getMarketRegionConfigDocId(versionId)}');
      final Map<String, dynamic>? mktRegionDataAsMap =
          await db.collection(_collectionMarketRegionConfig).doc(_getMarketRegionConfigDocId(versionId)).get();

      LogUtil.debug(_tag, 'ZoneConfigId key - ${_getZoneConfigDocId(versionId)}');
      final Map<String, dynamic>? zoneDataAsMap =
          await db.collection(_collectionZoneConfig).doc(_getZoneConfigDocId(versionId)).get();

      if (mktRegionDataAsMap != null &&
          mktRegionDataAsMap.isNotEmpty &&
          zoneDataAsMap != null &&
          zoneDataAsMap.isNotEmpty) {
        LogUtil.debug(_tag, 'Returning MarketRegionZoneConfiguration response');
        return MarketRegionZoneConfiguration(
            marketRegionConfig: MarketRegionConfig.fromMap(mktRegionDataAsMap),
            zoneConfig: ZoneConfig.fromJson(zoneDataAsMap),
            version: versionId);
      } else {
        LogUtil.debug(
            _tag, 'Size of mktRegionDataAsMap from db ${mktRegionDataAsMap != null ? mktRegionDataAsMap.length : 0}');
        LogUtil.debug(_tag, 'Size of zoneDataAsMap from db ${zoneDataAsMap != null ? zoneDataAsMap.length : 0}');
      }
    }
    return null;
  }

  insertMarketRegionZoneConfiguration(final MarketRegionZoneConfiguration configuration) async {
    final db = Localstore.instance;
    LogUtil.debug(
        _tag, 'Inserting MarketRegionConfigDoc using key ${_getMarketRegionConfigDocId(configuration.version)}');
    db
        .collection(_collectionMarketRegionConfig)
        .doc(_getMarketRegionConfigDocId(configuration.version))
        .set(configuration.marketRegionConfig.toMap());
    LogUtil.debug(_tag, 'Inserting ZoneConfigDoc using key ${_getZoneConfigDocId(configuration.version)}');
    db
        .collection(_collectionZoneConfig)
        .doc(_getZoneConfigDocId(configuration.version))
        .set(configuration.zoneConfig.toMap());
    LogUtil.debug(_tag, 'Inserting versionId doc using key $_versionId');
    db.collection(_collectionVersion).doc(_versionId).set({_versionId: configuration.version});
  }

  Future<Set<FuelCategory>?> getFuelCategoriesFromMarketRegionZoneConfig() async {
    final db = Localstore.instance;
    final Map<String, dynamic>? versionIdMap = await db.collection(_collectionVersion).doc(_versionId).get();
    if (versionIdMap != null && versionIdMap.isNotEmpty) {
      final String versionId = versionIdMap[_versionId];
      LogUtil.debug(_tag, 'VersionId read from database $versionId');
      final Map<String, dynamic>? mktRegionDataAsMap =
          await db.collection(_collectionMarketRegionConfig).doc(_getMarketRegionConfigDocId(versionId)).get();
      LogUtil.debug(_tag, 'MktRegionDataAsMap size ${mktRegionDataAsMap != null ? mktRegionDataAsMap.length : 0}');
      if (mktRegionDataAsMap != null && mktRegionDataAsMap.isNotEmpty) {
        final MarketRegionConfig mktRegionConfig = MarketRegionConfig.fromMap(mktRegionDataAsMap);
        LogUtil.debug(_tag, 'AllowedFuelCategories size ${mktRegionConfig.allowedFuelCategories.length}');
        return mktRegionConfig.allowedFuelCategories;
      }
    }
    return Future.value(null);
  }

  String _getMarketRegionConfigDocId(final String versionId) {
    return '$_marketRegionDocId-$versionId';
  }

  String _getZoneConfigDocId(final String versionId) {
    return '$_zoneDocId-$versionId';
  }
}