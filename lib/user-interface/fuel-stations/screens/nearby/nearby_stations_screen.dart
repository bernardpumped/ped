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
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-station-sorter/fuel_station_sorter_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-type-switcher/fuel_type_switcher_btn.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-type-switcher/fuel_type_switcher_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_list_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_type.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/model/fuel_type_switcher_data.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/model/nearby_fuel_stations.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/service/near_by_fuel_stations_service.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/no_near_by_stations_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/service/fuel_type_switcher_service.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

class NearbyStationsScreen extends StatefulWidget {
  static const routeName = '/ped/fuel-stations/nearby';
  static const viewLabel = 'Nearby Fuel Stations';
  static const viewIcon = Icons.near_me_outlined;
  static const viewSelectedIcon = Icons.near_me;
  const NearbyStationsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NearbyStationsScreenState();
}

class _NearbyStationsScreenState extends State<NearbyStationsScreen> {
  static const _tag = 'NearbyStationsScreen';
  static const tenSec = 10000;

  ScrollController _scrollController = ScrollController();

  final NearByFuelStationsService _nearByFuelStationsService =
      NearByFuelStationsService(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  final UnderMaintenanceService _underMaintenanceService =
      getIt.get<UnderMaintenanceService>(instanceName: underMaintenanceServiceName);
  final LocationUtils _locationUtils =
      LocationUtils(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  final FuelTypeSwitcherService _fuelTypeSwitcherDataSource = FuelTypeSwitcherService();

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
    _scrollController = ScrollController();
    _nearbyFuelStationsFuture = _nearByFuelStationsService.getFuelStations();
    _fuelTypeSwitcherDataStreamController = StreamController<FuelTypeSwitcherData>.broadcast();
    timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
    _nearbyFuelStationsFuture?.whenComplete(() {
      whenNearbyFuelStationFutureComplete();
    });
    _nearbyFuelStationsFuture?.then((value) => showDisclaimer(value));
    _underMaintenanceService.registerSubscription(_tag, context, (event, context) {
      if (!mounted) return;
      WidgetUtils.showPumpedUnavailabilityMessage(event, context);
      LogUtil.debug(_tag, '${event.data}');
    });
  }

  @override
  void dispose() {
    if (_locationServiceSubscription != null) {
      _locationServiceSubscription?.cancel(() => _locationServiceSubscriptionActive = false);
    }
    _fuelTypeSwitcherDataStreamController.close();
    _underMaintenanceService.cancelSubscription(_tag);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController,
        throwError: false);
    return Scaffold(
        appBar: const PumpedAppBar(title: NearbyStationsScreen.viewLabel, icon: NearbyStationsScreen.viewSelectedIcon),
        drawer: const NavDrawerWidget(),
        body: _nearByStationsScreenBody());
  }

  void scrollFuelStations(final int sortOrder) {
    setState(() {
      this.sortOrder = sortOrder;
      if (_nearByFuelStations.isNotEmpty) {
        _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 500));
      }
    });
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
    LogUtil.debug(
        _tag,
        'whenNearbyFuelStationFutureComplete :: timeOfLastNearbySearch : $timeOfLastNearbySearch '
        'and minTimeBetweenSearches $minTimeBetweenSearches');
  }

  _nearByStationsScreenBody() {
    return Stack(children: [
      _getNearbyFuelStationsFutureBuilder(),
      Positioned(right: 20, bottom: 20, child: _getFuelTypeSwitcherStreamBuilder())
    ]);
  }

  NearByFuelStations? data;

  Widget _getNearbyFuelStationsFutureBuilder() {
    return FutureBuilder<NearByFuelStations>(
        future: _nearbyFuelStationsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return _getIntermediateUI(data);
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                LogUtil.debug(_tag, 'Error loading nearby fuel stations ${snapshot.error}');
                return const NoNearByStationsWidget();
              } else if (snapshot.hasData) {
                data = snapshot.data!;
                lastQueryLatitude = data!.latitude;
                lastQueryLongitude = data!.longitude;
                return RefreshIndicator(
                    onRefresh: () async {
                      if ((DateTime.now().millisecondsSinceEpoch - timeOfLastNearbySearch) > minTimeBetweenSearches) {
                        setState(() {
                          timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
                          _nearbyFuelStationsFuture = _nearByFuelStationsService.getFuelStations();
                          _nearbyFuelStationsFuture?.then((value) => showDisclaimer(value));
                          _nearbyFuelStationsFuture?.whenComplete(() {
                            whenNearbyFuelStationFutureComplete();
                          });
                        });
                      } else {
                        LogUtil.debug(_tag, 'Not triggering the search as time has not yet passed');
                      }
                    },
                    child: _nearbyFuelStationsWidget(data!));
              } else {
                return _getIntermediateUI(data);
              }
          }
        });
  }

  RenderObjectWidget _getIntermediateUI(final NearByFuelStations? data) {
    if (data != null) {
      return Stack(children: [_nearbyFuelStationsWidget(data), const Center(child: RefreshProgressIndicator())]);
    } else {
      return const Center(child: RefreshProgressIndicator());
    }
  }

  void _locationChangeListener(final double latitude, final double longitude) async {
    if (lastQueryLatitude == null || lastQueryLongitude == null) {
      LogUtil.debug(
          _tag,
          'lastQueryLatitude : $lastQueryLatitude lastQueryLongitude : $lastQueryLongitude '
          'not in state to query. Returning');
      return;
    }
    // Null check exists on lastQueryLatitude and lastQueryLongitude above, so here
    final double distanceBetween =
        GeoLocationWrapper().distanceBetween(lastQueryLatitude!, lastQueryLongitude!, latitude, longitude);
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
        _nearbyFuelStationsFuture = _nearByFuelStationsService.getFuelStations();
        _nearbyFuelStationsFuture?.then((value) => showDisclaimer(value));
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
      LogUtil.debug(_tag, 'Setting _nearByFuelStations variable');
      if (_nearByFuelStations.isEmpty) {
        return const NoNearByStationsWidget();
      } else {
        if (data.defaultFuelType != null) {
          _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
          _selectedFuelType = data.defaultFuelType;
        }
        return Stack(children: [
          FuelStationListWidget(
              _scrollController, _nearByFuelStations, _selectedFuelType!, sortOrder, FuelStationType.nearby),
          Positioned(right: 20, bottom: 80, child: FuelStationSorterWidget(parentUpdateFunction: scrollFuelStations))
        ]);
      }
    }
  }

  void showDisclaimer(final NearByFuelStations value) {
    if (value.hiddenResultsFilteredCount != 0) {
      WidgetUtils.showToastMessage(
          context,
          '${value.hiddenResultsFilteredCount} hidden fuel stations filtered for result. '
          'To view clear hidden list in settings.');
    }
  }

  StreamBuilder<FuelTypeSwitcherData> _getFuelTypeSwitcherStreamBuilder() {
    return StreamBuilder(
        stream: _fuelTypeSwitcherDataStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error is ${snapshot.error}');
            return FuelTypeSwitcherButton('Error Loading', () => {});
          } else if (snapshot.hasData) {
            return _getFuelTypeSwitcherButton(snapshot.data!);
          } else {
            return FuelTypeSwitcherButton('Loading', () => {});
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
    return FuelTypeSwitcherWidget(
        selectedFuelType: _selectedFuelType!,
        selectedFuelCategory: _selectedFuelCategory!,
        onChangeCallback: _handleFuelTypeSwitch);
  }

  void _handleFuelTypeSwitch(final FuelTypeSwitcherResponseParams? params) {
    if (params != null) {
      LogUtil.debug(_tag, 'Params received : ${params.fuelType} ${params.fuelType}');
      setState(() {
        _selectedFuelCategory = params.fuelCategory;
        _selectedFuelType = params.fuelType;
      });
    } else {
      LogUtil.debug(_tag, 'handleFuelTypeSwitch::No response returned from FuelTypeSwitcher');
    }
  }
}
