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

import 'package:pumped_end_device/data/local/dao/market_region_zone_config_dao.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';

class MarketRegionZoneConfigUtils {
  Future<List<FuelType>> getFuelTypesForMarketRegion() async {
    final List<FuelType> allowedFuelTypes = [];
    final MarketRegionZoneConfiguration config =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    for (final FuelCategory fuelCategory in config.marketRegionConfig.allowedFuelCategories) {
      allowedFuelTypes.addAll(fuelCategory.allowedFuelTypes);
    }
    return allowedFuelTypes;
  }
}
