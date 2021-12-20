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
import 'package:pumped_end_device/data/local/dao/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/location/geo_location_data.dart';
import 'package:pumped_end_device/data/local/location/get_location_result.dart';
import 'package:pumped_end_device/data/local/location/location_access_result_code.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/get_fuel_stations_in_range.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/request/get_fuel_stations_in_range_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/response/get_fuel_stations_in_range_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/response-parser/get_fuel_stations_in_range_response_parser.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/nearby_fuel_stations.dart';
import 'package:pumped_end_device/models/fuel_station_search_config.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped/market_region_config.dart';
import 'package:pumped_end_device/models/pumped/zone_config.dart';
import 'package:pumped_end_device/models/quote_sort_order.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class NearByFuelStationsService {
  static const _TAG = 'NearByFuelStationsService';

  final LocationDataSource _locationDataSource;

  NearByFuelStationsService(this._locationDataSource);


  Future<NearByFuelStations> getFuelStations() async {
    final NearByFuelStations nearByFuelStationsScreenData = new NearByFuelStations();
    try {
      LogUtil.debug(_TAG, 'NearByFuelStationsDataSource::getFuelStations');
      final GetLocationResult locationResult = await _locationDataSource.getLocationData();
      LogUtil.debug(_TAG, 'NearByFuelStationsDataSource::getFuelStations LocationDataSourceV4.getLocationData');
      final LocationInitResultCode code = locationResult.locationInitResultCode;
      LogUtil.debug(_TAG, 'fetchNearByFuelStationData::code : ${code.toString()}');
      if (code == LocationInitResultCode.PERMISSION_DENIED) {
        nearByFuelStationsScreenData.locationSearchSuccessful = false;
        nearByFuelStationsScreenData.locationErrorReason = 'Location Permission denied';
      } else if (code == LocationInitResultCode.LOCATION_SERVICE_DISABLED) {
        nearByFuelStationsScreenData.locationSearchSuccessful = false;
        nearByFuelStationsScreenData.locationErrorReason = 'Location Service is disabled';
      } else {
        final GeoLocationData locationData = await locationResult.geoLocationData;
        nearByFuelStationsScreenData.latitude = locationData.latitude;
        nearByFuelStationsScreenData.longitude = locationData.longitude;
        LogUtil.debug(_TAG,
            'fetchNearByFuelStationData :: latitude : ${locationData.latitude}, longitude : ${locationData.longitude}');
        final FuelStationSearchConfig searchConfig = await _getFuelStationSearchConfig();
        final GetFuelStationsInRangeResponse response =
            await _fetchFuelStations(locationData.latitude, locationData.longitude, searchConfig);
        nearByFuelStationsScreenData.fuelStations = response.fuelStations;
        if (response.configChanged) {
          nearByFuelStationsScreenData.defaultFuelType = await _getDefaultFuelType();
        }
        LogUtil.debug(_TAG, 'Number of fuelStations fetched : ${nearByFuelStationsScreenData.fuelStations.length}');
        nearByFuelStationsScreenData.userSettingsVersion = await UserConfigurationDao.instance
            .getUserConfigurationVersion(UserConfiguration.DEFAULT_USER_CONFIG_ID);
        LogUtil.debug(_TAG, 'User settings version is : ${nearByFuelStationsScreenData.userSettingsVersion}');
      }
    } catch (error, s) {
      LogUtil.error(_TAG, 'Error happened in searching the fuel stations : $s, error is $error');
      nearByFuelStationsScreenData.searchResultFailureReason = 'Unknown reason $s';
    }
    return nearByFuelStationsScreenData;
  }

  Future<GetFuelStationsInRangeResponse> _fetchFuelStations(
      final double latitude, final double longitude, final FuelStationSearchConfig searchConfig) async {
    try {
      final String weekDay = DateTimeUtils.weekDayIntToShortName[DateTime.now().weekday];
      final GetFuelStationsInRangeParams request = GetFuelStationsInRangeParams.get(
          searchConfig, latitude, longitude, weekDay, true, true);
      final GetFuelStationsInRangeResponse response = await _getFuelStationsInRange(request);
      return response;
    } catch (error, s) {
      var message = 'Error happened in searching the fuel stations : $s, error is $error';
      LogUtil.error(_TAG, message);
      return new GetFuelStationsInRangeResponse(
          'FAILURE', message, null, DateTime.now().millisecondsSinceEpoch, [], null, false);
    }
  }

  Future<GetFuelStationsInRangeResponse> _getFuelStationsInRange(final GetFuelStationsInRangeParams request) async {
    MarketRegionZoneConfiguration existingMarketRegionZoneConfiguration =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    String fuelAuthorityId;
    if (existingMarketRegionZoneConfiguration != null) {
      fuelAuthorityId = existingMarketRegionZoneConfiguration.marketRegionConfig.fuelAuthorityId;
    }
    LogUtil.debug(_TAG, "About to fire the GetFuelStationsInRange request");
    final GetFuelStationsInRangeResponse response =
        await GetFuelStationsInRange(GetFuelStationsInRangeResponseParser(fuelAuthorityId)).execute(request);
    if (response.marketRegionZoneConfiguration != null) {
      final int persistenceResult = await MarketRegionZoneConfigDao.instance
          .insertMarketRegionZoneConfiguration(response.marketRegionZoneConfiguration);
      LogUtil.debug(_TAG, 'MarketRegionZoneConfig persistence result $persistenceResult');
    } else {
      LogUtil.debug(_TAG, 'Existing marketRegionZoneConfig set in GetFuelStationsInRangeResponse');
      response.marketRegionZoneConfiguration = existingMarketRegionZoneConfiguration;
    }
    return response;
  }

  double _getSearchRadius(final ZoneConfig zoneConfig, final UserConfiguration userConfiguration) {
    if (userConfiguration == null || userConfiguration.searchRadius == null) {
      return zoneConfig.maxRadius;
    }
    return userConfiguration.searchRadius.toDouble();
  }

  String _getSortOrder(final UserConfiguration userConfiguration) {
    if (userConfiguration != null) {
      return userConfiguration.searchCriteria;
    } else {
      return 'CHEAPEST_CLOSEST';
    }
  }

  num _getMaxNumberOfResults(final MarketRegionConfig marketRegionConfig, final UserConfiguration userConfiguration) {
    if (userConfiguration == null || userConfiguration.numSearchResults == null) {
      return marketRegionConfig.maxNumberOfResults;
    }
    return userConfiguration.numSearchResults;
  }

  Future<FuelStationSearchConfig> _getFuelStationSearchConfig() async {
    LogUtil.debug(_TAG, '_getFuelStationSearchConfig::start');
    final MarketRegionZoneConfigDao marketRegionZoneConfigDao = MarketRegionZoneConfigDao.instance;
    LogUtil.debug(_TAG, '_getFuelStationSearchConfig::MarketRegionZoneConfigDao.instance');
    final UserConfigurationDao userConfigurationDao = UserConfigurationDao.instance;
    LogUtil.debug(_TAG, '_getFuelStationSearchConfig::UserConfigurationDao.instance');
    final UserConfiguration userConfiguration = await userConfigurationDao
        .getUserConfiguration(UserConfiguration.DEFAULT_USER_CONFIG_ID);
    LogUtil.debug(_TAG, '_getFuelStationSearchConfig::userConfigurationDao.getUserConfiguration()');
    final MarketRegionZoneConfiguration marketRegionZoneConfig =
        await marketRegionZoneConfigDao.getMarketRegionZoneConfiguration();
    LogUtil.debug(_TAG, '_getFuelStationSearchConfig::marketRegionZoneConfigDao.getMarketRegionZoneConfiguration()');
    if (marketRegionZoneConfig != null) {
      LogUtil.debug(_TAG, 'Stored marketRegionZoneConfig is not null');
      final MarketRegionConfig marketRegionConfig = marketRegionZoneConfig.marketRegionConfig;
      if (marketRegionConfig != null) {
        final FuelType fuelType =
            _getDefaultFuelTypeForMarketRegionAndUserConfig(marketRegionConfig, userConfiguration);
        final double searchRadius = _getSearchRadius(marketRegionZoneConfig.zoneConfig, userConfiguration);
        final String distanceMeasure = marketRegionConfig.distanceMeasure;
        final String configVersion = marketRegionZoneConfig.version;
        final String sortOrder = _getSortOrder(userConfiguration);
        final num maxNumberOfResults = _getMaxNumberOfResults(marketRegionConfig, userConfiguration);
        return new FuelStationSearchConfig(
            fuelType: fuelType,
            range: searchRadius,
            defaultUnit: distanceMeasure,
            sortOrder: sortOrder,
            clientConfigVersion: configVersion,
            numOfResults: maxNumberOfResults);
      }
    }
    LogUtil.debug(_TAG, "Stored FuelStationSearchConfig not found.. returning default");
    return new FuelStationSearchConfig(
        fuelType: _getDefaultFuelTypeForMarketRegionAndUserConfig(null, userConfiguration),
        range: 5.0,
        sortOrder: SortOrder.CHEAPEST_CLOSEST.sortOrderStr,
        defaultUnit: "kilometre",
        clientConfigVersion: "-1",
        numOfResults: 5);
  }

  Future<FuelType> _getDefaultFuelType() async {
    final MarketRegionZoneConfiguration marketRegionZoneConfig =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    final UserConfiguration userConfiguration = await UserConfigurationDao.instance
        .getUserConfiguration(UserConfiguration.DEFAULT_USER_CONFIG_ID);
    return _getDefaultFuelTypeForMarketRegionAndUserConfig(
        marketRegionZoneConfig != null ? marketRegionZoneConfig.marketRegionConfig : null, userConfiguration);
  }

  FuelType _getDefaultFuelTypeForMarketRegionAndUserConfig(
      final MarketRegionConfig marketRegionConfig, final UserConfiguration userConfiguration) {
    if (userConfiguration != null) {
      return userConfiguration.defaultFuelType;
    }
    if (marketRegionConfig != null) {
      return marketRegionConfig.defaultFuelCategory.defaultFuelType;
    }
    return null;
  }
}