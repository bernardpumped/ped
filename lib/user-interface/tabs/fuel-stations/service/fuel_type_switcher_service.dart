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

import 'dart:async';

import 'package:pumped_end_device/data/local/dao/market_region_zone_config_dao.dart';
import 'package:pumped_end_device/data/local/dao/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/models/pumped_exception.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/fuel_type_switcher_data.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped/market_region_config.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelTypeSwitcherService {
  static const _tag = 'FuelTypeSwitcherService';

  void addFuelTypeSwitcherDataToStream(final StreamController<FuelTypeSwitcherData> streamController) async {
    try {
      final FuelCategory defaultFuelCategory = await _getDefaultFuelCategory();
      final FuelType fuelType = await _getDefaultFuelType() ?? defaultFuelCategory.defaultFuelType;
      final int userSettingsVersion = await UserConfigurationDao.instance
          .getUserConfigurationVersion(UserConfiguration.defaultUserConfigId);
      streamController.add(FuelTypeSwitcherData(fuelType, defaultFuelCategory, userSettingsVersion));
    } catch (error, s) {
      LogUtil.debug(_tag, 'Error fetching the defaultFuelCategory / defaultFuelType $s');
      streamController.addError(FuelTypeSwitcherDataError('Error fetching the defaultFuelCategory / defaultFuelType $s'));
    }
  }

  Future<FuelCategory> _getDefaultFuelCategory() async {
    final MarketRegionZoneConfiguration? marketRegionZoneConfig =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    final UserConfiguration? userConfiguration = await UserConfigurationDao.instance
        .getUserConfiguration(UserConfiguration.defaultUserConfigId);
    if (marketRegionZoneConfig!= null && userConfiguration != null) {
      return _getFuelCategory(marketRegionZoneConfig, userConfiguration);
    } else {
      if (marketRegionZoneConfig != null) {
        return marketRegionZoneConfig.marketRegionConfig.defaultFuelCategory;
      }
    }
    LogUtil.debug(_tag,
        '_getDefaultFuelCategory::neither marketRegion nor userConfiguration fuelCategory found. Returning as null');
    throw PumpedException('Could not derive defaultCategory.');
  }

  Future<FuelType?> _getDefaultFuelType() async {
    final MarketRegionZoneConfiguration? marketRegionZoneConfig =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    final UserConfiguration? userConfiguration = await UserConfigurationDao.instance
        .getUserConfiguration(UserConfiguration.defaultUserConfigId);
    return _getDefaultFuelTypeForMarketRegionAndUserConfig(
        marketRegionZoneConfig?.marketRegionConfig, userConfiguration);
  }

  FuelType? _getDefaultFuelTypeForMarketRegionAndUserConfig(
      final MarketRegionConfig? marketRegionConfig, final UserConfiguration? userConfiguration) {
    if (userConfiguration != null) {
      return userConfiguration.defaultFuelType;
    }
    if (marketRegionConfig != null) {
      return marketRegionConfig.defaultFuelCategory.defaultFuelType;
    }
    return null;
  }

  FuelCategory _getFuelCategory(
      final MarketRegionZoneConfiguration marketRegionZoneConfig, final UserConfiguration userConfiguration) {
    final FuelCategory userFuelCategory = userConfiguration.defaultFuelCategory;
    final List<FuelCategory> allFuelCategories = marketRegionZoneConfig.marketRegionConfig.allowedFuelCategories.toList();
    for (final FuelCategory fuelCategory in allFuelCategories) {
      if (fuelCategory == userFuelCategory) {
        return fuelCategory;
      }
    }
    return userFuelCategory;
  }
}
