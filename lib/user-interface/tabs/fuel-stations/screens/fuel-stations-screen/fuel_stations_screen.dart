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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/market_region_zone_config_dao.dart';
import 'package:pumped_end_device/data/local/location/geo_location_wrapper.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/data/local/location/location_service_subscription.dart';
import 'package:pumped_end_device/data/local/location_utils.dart';
import 'package:pumped_end_device/data/local/model/market_region_zone_config.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/service/favorite_fuel_stations_service.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/service/fuel_type_switcher_service.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/service/near_by_fuel_stations_service.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/favorite_fuel_stations.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/fuel_type_switcher_data.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/nearby_fuel_stations.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/utils/fuel_stations_sorter.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/widgets/fuel_station_list_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/widgets/no_favourite_stations_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/widgets/no_near_by_stations_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/widget/fuel_type_switcher_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_text_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationsScreen extends StatefulWidget {

  static const _tag = 'FuelStationsScreenIos';

  FuelStationsScreen({Key? key}) : super(key: key) {
    LogUtil.debug(_tag, "FuelStationsScreenIos::constructor");
  }

  @override
  State<StatefulWidget> createState() => _FuelStationsScreenState();
}

class _FuelStationsScreenState extends State<FuelStationsScreen> {
  static const _tag = '_FuelStationsScreenIosState';
  static const Map<int, Widget> logoWidgets = <int, Widget>{
    0: Text('Nearby Stations'),
    1: Text('Favourite Stations'),
  };

  static const Map<int, Widget> sortHeaders = {
    0: Text('Brand'),
    1: Text('Price'),
    2: Text('Distance'),
    3: Text('Offers'),
  };

  final NearByFuelStationsService _nearByFuelStationsDataSource = NearByFuelStationsService(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  final FavoriteFuelStationsService _favoriteFuelStationsDataSource = FavoriteFuelStationsService(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  final FuelTypeSwitcherService _fuelTypeSwitcherDataSource = FuelTypeSwitcherService();
  final FuelStationsSorter _fuelStationsSorter = FuelStationsSorter();
  final LocationUtils _locationUtils = LocationUtils(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));

  GlobalKey<_FuelStationsScreenState> globalKey = GlobalKey();

  List<FuelStation> _nearByFuelStations = [];
  List<FuelStation> _favouriteStations = [];
  List<bool> _expandedNearByFuelStations = [];
  List<bool> _expandedFavoriteFuelStations = [];

  _FuelStationsScreenState();

  FuelType? _selectedFuelType;
  FuelCategory? _selectedFuelCategory;

  int selectedSegment = 0;
  int sortOrder = 1;

  ScrollController _scrollController = ScrollController();

  int _userSettingsVersion = 0;

  Future<NearByFuelStations>? _nearbyFuelStationsFuture;
  Future<FavoriteFuelStations>? _favoriteFuelStationsFuture;
  late StreamController<FuelTypeSwitcherData> _fuelTypeSwitcherDataStreamController;

  int timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
  int minTimeBetweenSearches = 2 * 60 * 1000; // Default value, should be overwritten by response from backend.
  double minDistanceBetweenSearches = 500; //500 meters, to be overwritten by the response from backend
  double? lastQueryLatitude;
  double? lastQueryLongitude;

  static const tenSec = 10000;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    LogUtil.debug(_tag, 'initState');
    _nearbyFuelStationsFuture = _nearByFuelStationsDataSource.getFuelStations();
    _fuelTypeSwitcherDataStreamController = StreamController<FuelTypeSwitcherData>.broadcast();
    timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
    _favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();
    _nearbyFuelStationsFuture?.whenComplete(() {
      whenNearbyFuelStationFutureComplete();
    });
  }

  LocationServiceSubscription? _locationServiceSubscription;
  bool _locationServiceSubscriptionActive = false;

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
    LogUtil.debug(_tag, 'Build method invoked!!');
    return Scaffold(
        appBar: CupertinoNavigationBar(
            leading: const Padding(padding: EdgeInsets.only(top: 5), child: ApplicationTitleTextWidget()),
            backgroundColor: Colors.white,
            trailing: _getFuelTypeSwitcherStreamBuilder()),
        body: Container(
            // decoration: const BoxDecoration(color: FontsAndColors.pumpedBoxDecorationColor),
            // padding: const EdgeInsets.all(7),
            child: Column(children: <Widget>[
              // Row(children: <Widget>[
              //   Expanded(
              //       child: CupertinoSegmentedControl(
              //           borderColor: FontsAndColors.pumpedSecondaryIconColor,
              //           selectedColor: FontsAndColors.pumpedSecondaryIconColor,
              //           children: logoWidgets,
              //           onValueChanged: (int val) {
              //             setState(() => selectedSegment = val);
              //           },
              //           groupValue: selectedSegment))
              // ]),
              // const SizedBox(height: 10),
              // _getSortationHeaderWidget(),
              _getFuelStationSearchFilterBar(),
              const SizedBox(height: 6),
              _getFuelStationList(),
            ])));
  }

  StreamBuilder<FuelTypeSwitcherData> _getFuelTypeSwitcherStreamBuilder() {
    return StreamBuilder(
        stream: _fuelTypeSwitcherDataStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // final FuelTypeSwitcherDataError error = snapshot.error as FuelTypeSwitcherDataError;
            return const Material(color: Colors.white, child: Text('Error Loading'));
          } else if (snapshot.hasData) {
            return Material(color: Colors.white, child: _getFuelTypeSwitcherButton(snapshot.data!));
          } else {
            return const Material(color: Colors.white, child: Text('Loading'));
          }
        });
  }

  Widget _getFuelStationSearchFilterBar() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getFuelFavouriteNearbyFuelStationSwitcher(),
            _getSortationHeaderWidget2()
      ]),
    );
  }

  RenderObjectWidget _getSortationHeaderWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      CupertinoSlidingSegmentedControl<int>(
          thumbColor: Colors.white,
          children: sortHeaders,
          padding: const EdgeInsets.only(left: 1, right: 1),
          onValueChanged: (newValue) {
            setState(() {
              sortOrder = newValue!;
              _shrinkAllFuelStations();
              _sortFuelStations();
              _scrollToTopPosition();
            });
          },
          groupValue: sortOrder)
    ]);
  }

  Widget _getFuelFavouriteNearbyFuelStationSwitcher() {
    return DropdownButton<String>(
        onChanged: (value) {

        },
        value: 'Nearby Stations',
        // items: sortHeaders.values.map((value) => DropdownMenuItem(child: value)).toList()
        items: [
          DropdownMenuItem(child: Text('Favourite Stations'), value: 'Favourite Stations'),
          DropdownMenuItem(child: Text('Nearby Stations'), value: 'Nearby Stations')
        ]
    );
  }

  Widget _getSortationHeaderWidget2() {
    return DropdownButton<String>(
      onChanged: (value) {

      },
      value: 'Price',
      // items: sortHeaders.values.map((value) => DropdownMenuItem(child: value)).toList()
      items: const [
        DropdownMenuItem(child: Text('Brand'), value: 'Brand'),
        DropdownMenuItem(child: Text('Price'), value: 'Price'),
        DropdownMenuItem(child: Text('Distance'), value: 'Distance'),
        DropdownMenuItem(child: Text('Offers'), value: 'Offers')
      ]
    );

  }

  void _sortFuelStations() {
    if (selectedSegment == 0) {
      _fuelStationsSorter.sortFuelStations(_nearByFuelStations, _selectedFuelType?.fuelType, sortOrder);
    } else {
      _fuelStationsSorter.sortFuelStations(_favouriteStations, _selectedFuelType?.fuelType, sortOrder);
    }
  }

  void _scrollToTopPosition() {
    if (selectedSegment == 0 && _nearByFuelStations.isNotEmpty || selectedSegment == 1 && _favouriteStations.isNotEmpty) {
      _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 500));
    }
  }

  void _shrinkAllFuelStations() {
    if (selectedSegment == 0) {
      for (int i = 0; _nearByFuelStations.isNotEmpty && i < _nearByFuelStations.length; i++) {
        _expandedNearByFuelStations[i] = false;
      }
    } else {
      for (int i = 0; _favouriteStations.isNotEmpty && i < _favouriteStations.length; i++) {
        _expandedFavoriteFuelStations[i] = false;
      }
    }
  }

  Expanded _getFuelStationList() {
    return selectedSegment == 0
        ? Expanded(child: _getNearbyFuelStationsFutureBuilder())
        : Expanded(child: _getFavoriteFuelStationsFutureBuilder());
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
        _expandedNearByFuelStations = _nearByFuelStations.map((e) {
          return false;
        }).toList();
        if (data.defaultFuelType != null) {
          // This is the case, when the backend marketRegionZoneConfig has changed
          _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
          _selectedFuelType = data.defaultFuelType;
        }
        // Building an expectation that _selectedFuelType is not null here. And it should be non-null.
        return FuelStationListWidget(
            _scrollController, _nearByFuelStations, _expandedNearByFuelStations, _selectedFuelType!, sortOrder);
      }
    }
  }

  Widget _getFavoriteFuelStationsFutureBuilder() {
    return FutureBuilder<FavoriteFuelStations>(
        future: _favoriteFuelStationsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading Favorite fuel stations ${snapshot.error}');
            return RefreshIndicator(color: Colors.blue,
                onRefresh: () {
                  setState(() {_favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();});
                  return Future<void>(() {});
                }, child: const NoFavouriteStationsWidget());
          } else if (snapshot.hasData) {
              return RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: () async {
                    setState(() {
                      timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
                      _favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();
                    });
                  },
                  child: _favoriteFuelStationWidget(snapshot.data!));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _favoriteFuelStationWidget(final FavoriteFuelStations data) {
    if (!data.locationSearchSuccessful) {
      final String locationErrorReason = data.locationErrorReason ?? 'Unknown Location Error Reason';
      return Center(child: Text(locationErrorReason));
    } else {
      _favouriteStations = data.fuelStations ?? [];
      if (_favouriteStations.isNotEmpty) {
        LogUtil.debug(_tag, '_favoriteFuelStationWidget::fuel type ${_selectedFuelType?.fuelType}');
        _expandedFavoriteFuelStations = _favouriteStations.map((e) {
          return false;
        }).toList();
        return FuelStationListWidget(_scrollController, _favouriteStations, _expandedFavoriteFuelStations, _selectedFuelType!, sortOrder);
      } else {
        return const NoFavouriteStationsWidget();
      }
    }
  }

  static const _fuelTypeSwitcherIcon = Icon(IconData(59713, fontFamily: 'MaterialIcons'), size: 22, color: Colors.black87);

  Widget _getFuelTypeSwitcherButton(final FuelTypeSwitcherData data) {
    if (data.userSettingsVersion > _userSettingsVersion) {
      _userSettingsVersion = data.userSettingsVersion;
      _selectedFuelType = data.defaultFuelType;
      _selectedFuelCategory = data.defaultFuelCategory;
    } else {
      _selectedFuelType = _selectedFuelType ?? data.defaultFuelType;
      _selectedFuelCategory = _selectedFuelCategory ?? data.defaultFuelCategory;
    }

    return TextButton(onPressed: () {
      final Future<FuelTypeSwitcherResponseParams?> fuelTypeSwitcherDialog = showCupertinoDialog<FuelTypeSwitcherResponseParams>(
          context: context, builder: (context) => FuelTypeSwitcher(_selectedFuelType!, _selectedFuelCategory!));
      fuelTypeSwitcherDialog.then((output) => _handleFuelTypeSwitch(output),
          onError: (errorOutput, s) => LogUtil.error(_tag, '_getFuelTypeSwitcherButton::error output $s'));
    }, child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              child: Text(_selectedFuelType!.fuelName, style: const TextStyle(fontSize: 18, color: Colors.black)),
              padding: const EdgeInsets.only(right: 10)),
          _fuelTypeSwitcherIcon
        ]));
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
