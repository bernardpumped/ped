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

import 'package:pumped_end_device/util/log_util.dart';

import 'dao/market_region_zone_config_dao.dart';
import 'location/location_data_source.dart';
import 'location/location_service_subscription.dart';
import 'model/market_region_zone_config.dart';

class LocationUtils {
  static const _tag = 'LocationUtils';

  final LocationDataSource _locationDataSource;

  LocationUtils(this._locationDataSource);

  Future<LocationServiceSubscription> configureLocationService(final Function onLocationChangeListener) async {
    final MarketRegionZoneConfiguration config =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    if (config != null) {
      final double minDistanceInMetres = config.zoneConfig.minDistanceLocationUpdates;
      final int minTimeLocationUpdates = config.zoneConfig.minTimeLocationUpdates * 1000;
      LogUtil.debug(_tag, 'minDistanceInMetres : $minDistanceInMetres minTimeLocationUpdates $minTimeLocationUpdates');
      return _locationDataSource.updateLocationSettings(
          minTimeLocationUpdates, minDistanceInMetres, onLocationChangeListener);
    } else {
      LogUtil.error(_tag, 'Could not configure locationService as marketRegion not found in db');
      return null;
    }
  }
}
