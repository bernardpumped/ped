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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/market_region_zone_config_dao.dart';
import 'package:pumped_end_device/data/local/location/geo_location_wrapper.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/data/local/location/location_service_subscription.dart';
import 'package:pumped_end_device/data/local/location_utils.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/fuel-station-screen-color-scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/widgets/fuel-type-switcher-widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/widgets/fuel-stations-sort-fab.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/widgets/fuel_station_list_widget.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav-drawer.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/fuel_type_switcher_data.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/nearby_fuel_stations.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/service/near_by_fuel_stations_service.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/widgets/no_near_by_stations_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/service/fuel_type_switcher_service.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_widget.dart';
import 'package:pumped_end_device/util/log_util.dart';

class NearbyStationsScreen extends StatefulWidget {
  static const routeName = '/nearby-stations';
  const NearbyStationsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NearbyStationsScreenState();
}

class _NearbyStationsScreenState extends State<NearbyStationsScreen> {
  static const _tag = 'NearbyStationsScreen';
  static const tenSec = 10000;

  ScrollController _scrollController = ScrollController();

  final NearByFuelStationsService _nearByFuelStationsDataSource = NearByFuelStationsService(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  final LocationUtils _locationUtils = LocationUtils(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  final FuelTypeSwitcherService _fuelTypeSwitcherDataSource = FuelTypeSwitcherService();

  final FuelStationsScreenColorScheme colorScheme = getIt.get<FuelStationsScreenColorScheme>(instanceName: fsScreenColorSchemeName);
  late StreamController<FuelTypeSwitcherData> _fuelTypeSwitcherDataStreamController;
  Future<NearByFuelStations>? _nearbyFuelStationsFuture;

  int timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
  int minTimeBetweenSearches = 2 * 60 * 1000; // Default value, should be overwritten by response from backend.
  double minDistanceBetweenSearches = 500; //500 meters, to be overwritten by the response from backend
  double? lastQueryLatitude;
  double? lastQueryLongitude;
  int _userSettingsVersion = 0;
  int sortOrder = 1;
  FuelType? _selectedFuelType;
  FuelCategory? _selectedFuelCategory;

  List<FuelStation> _nearByFuelStations = [];

  LocationServiceSubscription? _locationServiceSubscription;
  bool _locationServiceSubscriptionActive = false;

  @override
  void initState() {
    super.initState();
    LogUtil.debug(_tag, 'initState');
    _scrollController = ScrollController();
    _nearbyFuelStationsFuture = _nearByFuelStationsDataSource.getFuelStations();
    _fuelTypeSwitcherDataStreamController = StreamController<FuelTypeSwitcherData>.broadcast();
    timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
    _nearbyFuelStationsFuture?.whenComplete(() {
      whenNearbyFuelStationFutureComplete();
    });
  }

  @override
  void dispose() {
    if (_locationServiceSubscription != null) {
      _locationServiceSubscription?.cancel(() => _locationServiceSubscriptionActive = false);
    }
    _fuelTypeSwitcherDataStreamController.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xFFF0EDFF),
            iconTheme: IconThemeData(color: Colors.indigo),
            centerTitle: false,
            foregroundColor: Colors.indigo,
            title: ApplicationTitleWidget(title: 'Pumped', titleColor: Colors.indigo)),
        drawer: const NavDrawer(),
        body: _drawBody(),
        floatingActionButton: const FuelStationsSortFab());
  }

  void whenNearbyFuelStationFutureComplete() async {
    if (_locationServiceSubscription == null || !_locationServiceSubscriptionActive) {
      _locationServiceSubscription = await _locationUtils.configureLocationService(_locationChangeListener);
      _locationServiceSubscriptionActive = true;
    }
    final MarketRegionZoneConfiguration? config =
    await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    if (config != null) {
      minTimeBetweenSearches = config.zoneConfig.minTimeLocationUpdates;
      minDistanceBetweenSearches = config.zoneConfig.minDistanceLocationUpdates;
    }
    if (minTimeBetweenSearches == 0) {
      minTimeBetweenSearches = tenSec;
    }
    LogUtil.debug(_tag, 'whenNearbyFuelStationFutureComplete :: timeOfLastNearbySearch : $timeOfLastNearbySearch '
      'and minTimeBetweenSearches $minTimeBetweenSearches');
  }

  _drawBody() {
    return Container(
      color: Color(0xFFF0EDFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20),
            child: _getStationTypeFuelTypeSwitcher()
          ),
          Expanded(child: _getNearbyFuelStationsFutureBuilder()),
        ]),
    );
  }

  Widget _getStationTypeFuelTypeSwitcher() {
    return Material(color: Color(0xFFF0EDFF), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_fuelStationTypeSwitcher(), _getFuelTypeSwitcherStreamBuilder()]));
  }

  Widget _getNearbyFuelStationsFutureBuilder() {
    return FutureBuilder<NearByFuelStations>(
        future: _nearbyFuelStationsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                LogUtil.debug(_tag, 'Error loading nearby fuel stations ${snapshot.error}');
                return const NoNearByStationsWidget();
              } else if (snapshot.hasData) {
                final NearByFuelStations data = snapshot.data!;
                lastQueryLatitude = data.latitude;
                lastQueryLongitude = data.longitude;
                return RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      if ((DateTime.now().millisecondsSinceEpoch - timeOfLastNearbySearch) > minTimeBetweenSearches) {
                        setState(() {
                          timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
                          _nearbyFuelStationsFuture = _nearByFuelStationsDataSource.getFuelStations();
                          _nearbyFuelStationsFuture?.whenComplete(() {
                            whenNearbyFuelStationFutureComplete();
                          });
                        });
                      } else {
                        LogUtil.debug(_tag, 'Not triggering the search as time has not yet passed');
                      }
                    },
                    child: _nearbyFuelStationsWidget(data));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          }
        });
  }

  void _locationChangeListener(final double latitude, final double longitude) async {
    if (lastQueryLatitude == null || lastQueryLongitude == null) {
      LogUtil.debug(_tag, 'lastQueryLatitude : $lastQueryLatitude lastQueryLongitude : $lastQueryLongitude not in state to query. Returning');
      return;
    }
    // Null check exists on lastQueryLatitude and lastQueryLongitude above, so here
    final double distanceBetween = GeoLocationWrapper().distanceBetween(
        lastQueryLatitude!, lastQueryLongitude!, latitude, longitude);
    final bool distanceThresholdBreached = distanceBetween >= minDistanceBetweenSearches;
    final int timeElapsed = DateTime.now().millisecondsSinceEpoch - timeOfLastNearbySearch;
    final bool timeThresholdBreached = timeElapsed > minTimeBetweenSearches;
    /*
      This logic is to prevent un-necessary builds, at the time of registration with the location engine.
      At the time of registration, there are duplicate events. This logic depends on minTime and minDistance.
     */
    if (distanceThresholdBreached || timeThresholdBreached) {
      LogUtil.debug(_tag, 'distanceThresholdBreached $distanceBetween timeThresholdBreached $timeElapsed');
      setState(() {
        timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
        _nearbyFuelStationsFuture = _nearByFuelStationsDataSource.getFuelStations();
        _nearbyFuelStationsFuture?.whenComplete(() {
          whenNearbyFuelStationFutureComplete();
        });
      });
    } else {
      LogUtil.debug(_tag, 'locationChangeListener::distance not sufficient to trigger next query');
    }
  }

  Widget _nearbyFuelStationsWidget(final NearByFuelStations data) {
    _userSettingsVersion = data.userSettingsVersion ?? 0;
    if (!data.locationSearchSuccessful) {
      final String locationErrorReason = data.locationErrorReason ?? 'Unknown Location Error Reason';
      return Center(child: Text(locationErrorReason));
    } else {
      _nearByFuelStations = data.fuelStations ?? [];
      if (_nearByFuelStations.isEmpty) {
        return const NoNearByStationsWidget();
      } else {
        if (data.defaultFuelType != null) {
          // This is the case, when the backend marketRegionZoneConfig has changed
          _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
          _selectedFuelType = data.defaultFuelType;
        }
        // Building an expectation that _selectedFuelType is not null here. And it should be non-null.
        return FuelStationListWidget(_scrollController, _nearByFuelStations, _selectedFuelType!, sortOrder);
      }
    }
  }

  StreamBuilder<FuelTypeSwitcherData> _getFuelTypeSwitcherStreamBuilder() {
    return StreamBuilder(
        stream: _fuelTypeSwitcherDataStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // final FuelTypeSwitcherDataError error = snapshot.error as FuelTypeSwitcherDataError;
            return const Material(color: Colors.white, child: Text('Error Loading'));
          } else if (snapshot.hasData) {
            return _getFuelTypeSwitcherButton(snapshot.data!);
          } else {
            return Text('Loading');
          }
        });
  }

  Widget _getFuelTypeSwitcherButton(final FuelTypeSwitcherData data) {
    if (data.userSettingsVersion > _userSettingsVersion) {
      _userSettingsVersion = data.userSettingsVersion;
      _selectedFuelType = data.defaultFuelType;
      _selectedFuelCategory = data.defaultFuelCategory;
    } else {
      _selectedFuelType = _selectedFuelType ?? data.defaultFuelType;
      _selectedFuelCategory = _selectedFuelCategory ?? data.defaultFuelCategory;
    }
    return FuelTypeSwitcherWidget(selectedFuelType: _selectedFuelType!, selectedFuelCategory: _selectedFuelCategory!);
    // return TextButton(onPressed: () {
    //   final Future<FuelTypeSwitcherResponseParams?> fuelTypeSwitcherDialog = showCupertinoDialog<FuelTypeSwitcherResponseParams>(
    //       context: context, builder: (context) => FuelTypeSwitcher(_selectedFuelType!, _selectedFuelCategory!));
    //   fuelTypeSwitcherDialog.then((output) => _handleFuelTypeSwitch(output),
    //       onError: (errorOutput, s) => LogUtil.error(_tag, '_getFuelTypeSwitcherButton::error output $s'));
    // }, child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //           child: Text(_selectedFuelType!.fuelName, style: const TextStyle(fontSize: 18, color: Colors.black)),
    //           padding: const EdgeInsets.only(right: 10)),
    //       _fuelTypeSwitcherIcon
    //     ]));
  }

  Widget _fuelStationTypeSwitcher() {
    return Chip(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        avatar: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.near_me, color: Theme.of(context).primaryColor)),
        label: const Text('Nearby Fuel'),
        labelPadding: const EdgeInsets.all(3),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        onDeleted: (){},
        deleteIcon: const Icon(Icons.chevron_right, color: Colors.white));
  }
}

