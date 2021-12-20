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

import 'package:pumped_end_device/data/local/dao/favorite_fuel_stations_dao.dart';
import 'package:pumped_end_device/data/local/dao/market_region_zone_config_dao.dart';
import 'package:pumped_end_device/data/local/location/geo_location_data.dart';
import 'package:pumped_end_device/data/local/location/get_location_result.dart';
import 'package:pumped_end_device/data/local/location/location_access_result_code.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/get_fuel_station_details_batch.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/request/get_fuel_station_details_batch_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/model/response/get_fuel_station_details_batch_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/datasource/remote/response-parser/get_fuel_station_details_batch_response_parser.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/favorite_fuel_stations.dart';
import 'package:pumped_end_device/util/date_time_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class FavoriteFuelStationsService {
  static const _TAG = 'FavoriteFuelStationsService';

  final LocationDataSource _locationDataSource;

  FavoriteFuelStationsService(this._locationDataSource);


  Future<FavoriteFuelStations> getFuelStations() async {
    final FavoriteFuelStations favFuelStationsScreenData = new FavoriteFuelStations();
    try {
      final GetLocationResult locationResult =
            await _locationDataSource.getLocationData(thread: 'favoriteFuelStations');
      final LocationInitResultCode code = locationResult.locationInitResultCode;
      LogUtil.debug(_TAG, 'fetchFavoriteFuelStations::code : ${code.toString()}');
      if (code == LocationInitResultCode.PERMISSION_DENIED) {
        favFuelStationsScreenData.locationSearchSuccessful = false;
        favFuelStationsScreenData.locationErrorReason = 'Location Permission denied';
      } else if (code == LocationInitResultCode.LOCATION_SERVICE_DISABLED) {
        favFuelStationsScreenData.locationSearchSuccessful = false;
        favFuelStationsScreenData.locationErrorReason = 'Location Service is disabled';
      } else {
        final GeoLocationData locationData = await locationResult.geoLocationData;
        LogUtil.debug(_TAG,
            'fetchFavoriteFuelStations:: latitude : ${locationData.latitude}, longitude : ${locationData.longitude}');
        final List<FavoriteFuelStation> allFavoriteFuelStations =
            await FavoriteFuelStationsDao.instance.getAllFavoriteFuelStations();
        favFuelStationsScreenData.latitude = locationData.latitude;
        favFuelStationsScreenData.longitude = locationData.longitude;
        if (allFavoriteFuelStations != null && allFavoriteFuelStations.length > 0) {
          LogUtil.debug(_TAG, 'Found ${allFavoriteFuelStations.length} fuel stations');
          final List<int> fuelStationIds = allFavoriteFuelStations
              .where((favFuelStation) => favFuelStation.fuelStationSource == 'G')
              .map((e) => e.favoriteFuelStationId)
              .toList();
          final List<int> fuelAuthStationIds = allFavoriteFuelStations
              .where((favFuelStation) => favFuelStation.fuelStationSource == 'F')
              .map((e) => e.favoriteFuelStationId)
              .toList();
          if (fuelStationIds.isEmpty && fuelAuthStationIds.isEmpty) {
            LogUtil.debug(_TAG, 'No favorite fuelStations found');
            favFuelStationsScreenData.fuelStations = [];
            return favFuelStationsScreenData;
          } else {
            LogUtil.debug(_TAG,
                'FuelStationIds : ${fuelStationIds.length} and FuelAuthorityStationIds : ${fuelAuthStationIds.length}');
            final String weekDay = DateTimeUtils.weekDayIntToShortName[DateTime.now().weekday];
            final GetFuelStationDetailsBatchRequest request = GetFuelStationDetailsBatchRequest(
                requestUuid: Uuid().v1(),
                fuelStationIds: fuelStationIds,
                fuelAuthorityStationIds: fuelAuthStationIds,
                latitude: locationData.latitude,
                longitude: locationData.longitude,
                dayOfWeek: weekDay);
            final GetFuelStationDetailsBatchResponse response = await _fetchFavoriteFuelStations(request);
            favFuelStationsScreenData.fuelStations = response.fuelStations;
            favFuelStationsScreenData.responseCode = response.responseCode;
            favFuelStationsScreenData.responseDetails = response.responseDetails;
            return favFuelStationsScreenData;
          }
        } else {
          LogUtil.debug(_TAG, 'No Favorite fuel stations found');
        }
      }
    } catch (e, s) {
      favFuelStationsScreenData.responseCode = 'FAILURE';
      favFuelStationsScreenData.responseDetails = 'Failed while retrieving the geolocation';
      LogUtil.debug(_TAG, 'Exceptions occurred while fetching favorite fuel stations $s');
    }
    return Future.value(favFuelStationsScreenData);
  }

  Future<GetFuelStationDetailsBatchResponse> _fetchFavoriteFuelStations(
      final GetFuelStationDetailsBatchRequest request) async {
    try {
      final MarketRegionZoneConfiguration marketRegionZoneConfiguration =
          await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
      return GetFuelStationDetailsBatch(GetFuelStationDetailsBatchResponseParser(marketRegionZoneConfiguration != null
              ? marketRegionZoneConfiguration.marketRegionConfig.fuelAuthorityId
              : null))
          .execute(request);
    } on Exception catch (e) {
      LogUtil.debug(_TAG, 'Exception happened in _fetchFavoriteFuelStations $e');
      return GetFuelStationDetailsBatchResponse(
          'FAILURE', 'Error loading data for favorite fuel station', null, DateTime.now().millisecondsSinceEpoch, []);
    }
  }
}
