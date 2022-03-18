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

import 'package:pumped_end_device/models/pumped/market_region_config.dart';
import 'package:pumped_end_device/models/pumped/zone_config.dart';

class MarketRegionZoneConfiguration {
  final MarketRegionConfig marketRegionConfig;
  final ZoneConfig zoneConfig;
  final String version;

  MarketRegionZoneConfiguration({
    required this.marketRegionConfig,
    required this.zoneConfig,
    required this.version,
  });

  factory MarketRegionZoneConfiguration.fromJson(final Map<String, dynamic> data) => MarketRegionZoneConfiguration(
        zoneConfig: ZoneConfig.fromJson(data['zone_config']),
        marketRegionConfig: MarketRegionConfig.fromJson(data['market_region_config']),
        version: data['version']
      );

  Map<String, dynamic> toJson() => {
        'market_region_config': marketRegionConfig.toJson(),
        'zone_config': zoneConfig.toJson(),
        'version': version,
      };
}
