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
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
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

  static const _TAG = 'FuelStationsScreenIos';

  FuelStationsScreen() {
    LogUtil.debug(_TAG, "FuelStationsScreenIos::constructor");
  }

  @override
  State<StatefulWidget> createState() => _FuelStationsScreenState();
}

class _FuelStationsScreenState extends State<FuelStationsScreen> {
  static const _TAG = '_FuelStationsScreenIosState';
  static final Map<int, Widget> logoWidgets = const <int, Widget>{
    0: Text('Nearby Stations'),
    1: Text('Favourite Stations'),
  };

  static final Map<int, Widget> sortHeaders = const {
    0: Text('Brand'),
    1: Text('Price'),
    2: Text('Distance'),
    3: Text('Offers'),
  };

  final NearByFuelStationsService _nearByFuelStationsDataSource = new NearByFuelStationsService(getIt.get<LocationDataSource>());
  final FavoriteFuelStationsService _favoriteFuelStationsDataSource = new FavoriteFuelStationsService(getIt.get<LocationDataSource>());
  final FuelTypeSwitcherService _fuelTypeSwitcherDataSource = new FuelTypeSwitcherService();
  final FuelStationsSorter _fuelStationsSorter = new FuelStationsSorter();
  final LocationUtils _locationUtils = new LocationUtils(getIt.get<LocationDataSource>());

  GlobalKey<_FuelStationsScreenState> globalKey = new GlobalKey();

  List<FuelStation> _nearByFuelStations;
  List<FuelStation> _favouriteStations;
  List<bool> _expandedNearByFuelStations;
  List<bool> _expandedFavoriteFuelStations;

  _FuelStationsScreenState() {
    _favouriteStations = [];
  }

  FuelType _selectedFuelType;
  FuelCategory _selectedFuelCategory;

  int selectedSegment = 0;
  int sortOrder = 1;

  ScrollController _scrollController;

  int _userSettingsVersion = 0;

  Future<NearByFuelStations> _nearbyFuelStationsFuture;
  Future<FavoriteFuelStations> _favoriteFuelStationsFuture;
  StreamController<FuelTypeSwitcherData> _fuelTypeSwitcherDataStreamController;

  int timeOfLastNearbySearch;
  int minTimeBetweenSearches;
  double minDistanceBetweenSearches;
  double lastQueryLatitude;
  double lastQueryLongitude;

  static const TEN_SEC = 10000;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    LogUtil.debug(_TAG, 'initState');
    _nearbyFuelStationsFuture = _nearByFuelStationsDataSource.getFuelStations();
    _fuelTypeSwitcherDataStreamController = StreamController<FuelTypeSwitcherData>.broadcast();
    timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
    _favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();
    _nearbyFuelStationsFuture.whenComplete(() {
      whenNearbyFuelStationFutureComplete();
    });
  }

  LocationServiceSubscription _locationServiceSubscription;
  bool _locationServiceSubscriptionActive = false;

  void whenNearbyFuelStationFutureComplete() async {
    if (_locationServiceSubscription == null || !_locationServiceSubscriptionActive) {
      _locationServiceSubscription = await _locationUtils.configureLocationService(locationChangeListener);
      _locationServiceSubscriptionActive = true;
    }
    final MarketRegionZoneConfiguration config =
        await MarketRegionZoneConfigDao.instance.getMarketRegionZoneConfiguration();
    if (config != null) {
      minTimeBetweenSearches = config.zoneConfig.minTimeLocationUpdates;
      minDistanceBetweenSearches = config.zoneConfig.minDistanceLocationUpdates;
    }
    if (minTimeBetweenSearches == 0) {
      minTimeBetweenSearches = TEN_SEC;
    }
    LogUtil.debug(
        _TAG,
        'whenNearbyFuelStationFutureComplete :: timeOfLastNearbySearch : $timeOfLastNearbySearch ' +
            'and minTimeBetweenSearches $minTimeBetweenSearches');
  }

  @override
  void dispose() {
    if (_locationServiceSubscription != null) {
      _locationServiceSubscription.cancel(() => _locationServiceSubscriptionActive = false);
    }
    _fuelTypeSwitcherDataStreamController.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
    LogUtil.debug(_TAG, 'Build method invoked!!');
    return Scaffold(
        appBar: CupertinoNavigationBar(
            leading: Padding(padding: const EdgeInsets.only(top: 5), child: ApplicationTitleTextWidget()),
            backgroundColor: Colors.white,
            trailing: _getFuelTypeSwitcherStreamBuilder()),
        body: Container(
            decoration: BoxDecoration(color: FontsAndColors.pumpedBoxDecorationColor),
            padding: EdgeInsets.all(7),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    child: CupertinoSegmentedControl(
                        borderColor: FontsAndColors.pumpedSecondaryIconColor,
                        selectedColor: FontsAndColors.pumpedSecondaryIconColor,
                        children: logoWidgets,
                        onValueChanged: (int val) {
                          setState(() => selectedSegment = val);
                        },
                        groupValue: selectedSegment))
              ]),
              SizedBox(height: 10),
              _getSortationHeaderWidget(),
              SizedBox(height: 6),
              _getFuelStationList(),
            ])));
  }

  StreamBuilder<FuelTypeSwitcherData> _getFuelTypeSwitcherStreamBuilder() {
    return StreamBuilder(
        stream: _fuelTypeSwitcherDataStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Material(color: Colors.white, child: Container(child: Text('Error Loading')));
          } else if (snapshot.hasData) {
            final FuelTypeSwitcherData data = snapshot.data;
            if (data.hasFailed) {
              return Material(color: Colors.white, child: Text('Error Loading...'));
            } else {
              return Material(color: Colors.white, child: _getFuelTypeSwitcherButton(snapshot.data));
            }
          } else {
            return Material(color: Colors.white, child: Container(child: Text('Loading')));
          }
        });
  }

  RenderObjectWidget _getSortationHeaderWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      CupertinoSlidingSegmentedControl<int>(
          thumbColor: Colors.white,
          children: sortHeaders,
          padding: EdgeInsets.only(left: 1, right: 1),
          onValueChanged: (newValue) {
            setState(() {
              sortOrder = newValue;
              _shrinkAllFuelStations();
              _sortFuelStations();
              _scrollToTopPosition();
            });
          },
          groupValue: sortOrder)
    ]);
  }

  void _sortFuelStations() {
    if (selectedSegment == 0) {
      _fuelStationsSorter.sortFuelStations(_nearByFuelStations, _selectedFuelType.fuelType, sortOrder);
    } else {
      _fuelStationsSorter.sortFuelStations(_favouriteStations, _selectedFuelType.fuelType, sortOrder);
    }
  }

  void _scrollToTopPosition() {
    if (selectedSegment == 0 && _nearByFuelStations != null || selectedSegment == 1 && _favouriteStations != null)
      _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 500));
  }

  void _shrinkAllFuelStations() {
    if (selectedSegment == 0) {
      for (int i = 0; _nearByFuelStations != null && i < _nearByFuelStations.length; i++) {
        _expandedNearByFuelStations[i] = false;
      }
    } else {
      for (int i = 0; _favouriteStations != null && i < _favouriteStations.length; i++) {
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
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                LogUtil.debug(_TAG, 'Error loading nearby fuel stations ${snapshot.error}');
                return NoNearByStationsWidget();
              } else if (snapshot.hasData) {
                final NearByFuelStations data = snapshot.data;
                lastQueryLatitude = data.latitude;
                lastQueryLongitude = data.longitude;
                return RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      if ((DateTime.now().millisecondsSinceEpoch - timeOfLastNearbySearch) > minTimeBetweenSearches) {
                        setState(() {
                          timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
                          _nearbyFuelStationsFuture = _nearByFuelStationsDataSource.getFuelStations();
                          _nearbyFuelStationsFuture.whenComplete(() {
                            whenNearbyFuelStationFutureComplete();
                          });
                        });
                      } else {
                        LogUtil.debug(_TAG, 'Not triggering the search as time has not yet passed');
                      }
                    },
                    child: _nearbyFuelStationsWidget(data));
              } else {
                return Center(child: CircularProgressIndicator());
              }
          }
        });
  }

  void locationChangeListener(final double latitude, final double longitude) async {
    final double distanceBetween = new GeoLocationWrapper().distanceBetween(
        lastQueryLatitude, lastQueryLongitude, latitude, longitude);
    final bool distanceThresholdBreached = distanceBetween >= minDistanceBetweenSearches;
    final int timeElapsed = DateTime.now().millisecondsSinceEpoch - timeOfLastNearbySearch;
    final bool timeThresholdBreached = timeElapsed > minTimeBetweenSearches;
    /*
      This logic is to prevent un-necessary builds, at the time of registration with the location engine.
      At the time of registration, there are duplicate events. This logic depends on minTime and minDistance.
     */
    if (distanceThresholdBreached || timeThresholdBreached) {
      LogUtil.debug(_TAG, 'distanceThresholdBreached $distanceBetween timeThresholdBreached $timeElapsed');
      setState(() {
        timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
        _nearbyFuelStationsFuture = _nearByFuelStationsDataSource.getFuelStations();
        _nearbyFuelStationsFuture.whenComplete(() {
          whenNearbyFuelStationFutureComplete();
        });
      });
    } else {
      LogUtil.debug(_TAG, 'locationChangeListener::distance not sufficient to trigger next query');
    }
  }

  Widget _nearbyFuelStationsWidget(final NearByFuelStations data) {
    _userSettingsVersion = data.userSettingsVersion;
    if (!data.locationSearchSuccessful) {
      return Center(child: Text(data.locationErrorReason));
    } else {
      _nearByFuelStations = data.fuelStations;
      if (_nearByFuelStations == null || _nearByFuelStations.isEmpty) {
        return NoNearByStationsWidget();
      } else {
        _expandedNearByFuelStations = _nearByFuelStations.map((e) {
          return false;
        }).toList();
        if (data.defaultFuelType != null) {
          // This is the case, when the backend marketRegionZoneConfig has changed
          _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
          _selectedFuelType = data.defaultFuelType;
        }
        return FuelStationListWidget(
            _scrollController, _nearByFuelStations, _expandedNearByFuelStations, _selectedFuelType, sortOrder);
      }
    }
  }

  Widget _getFavoriteFuelStationsFutureBuilder() {
    return FutureBuilder<FavoriteFuelStations>(
        future: _favoriteFuelStationsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_TAG, 'Error loading Favorite fuel stations ${snapshot.error}');
            return RefreshIndicator(
                color: Colors.blue,
                onRefresh: () {
                  setState(() {
                    _favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();
                  });
                  return null;
                },
                child: NoFavouriteStationsWidget());
          } else if (snapshot.hasData) {
            return RefreshIndicator(
                color: Colors.blue,
                onRefresh: () async {
                  setState(() {
                    timeOfLastNearbySearch = DateTime.now().millisecondsSinceEpoch;
                    _favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();
                  });
                },
                child: _favoriteFuelStationWidget(snapshot.data));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _favoriteFuelStationWidget(final FavoriteFuelStations data) {
    if (!data.locationSearchSuccessful) {
      return Center(child: Text(data.locationErrorReason));
    } else {
      _favouriteStations = data.fuelStations;
      if (_favouriteStations != null && _favouriteStations.length > 0) {
        LogUtil.debug(_TAG, '_favoriteFuelStationWidget::fuel type ${_selectedFuelType.fuelType}');
        _expandedFavoriteFuelStations = _favouriteStations.map((e) {
          return false;
        }).toList();
        return FuelStationListWidget(
            _scrollController, _favouriteStations, _expandedFavoriteFuelStations, _selectedFuelType, sortOrder);
      } else
        return NoFavouriteStationsWidget();
    }
  }

  static const _fuelTypeSwitcherIcon = const Icon(IconData(59713, fontFamily: 'MaterialIcons'), size: 22, color: Colors.black87);

  Widget _getFuelTypeSwitcherButton(final FuelTypeSwitcherData data) {
    if (data.userSettingsVersion > _userSettingsVersion) {
      _userSettingsVersion = data.userSettingsVersion;
      _selectedFuelType = data.defaultFuelType;
      _selectedFuelCategory = data.defaultFuelCategory;
    } else {
      _selectedFuelType = _selectedFuelType != null ? _selectedFuelType : data.defaultFuelType;
      _selectedFuelCategory = _selectedFuelCategory != null ? _selectedFuelCategory : data.defaultFuelCategory;
    }

    return TextButton(onPressed: () {
      final Future<FuelTypeSwitcherResponseParams> fuelTypeSwitcherDialog =
      showCupertinoDialog<FuelTypeSwitcherResponseParams>(
          context: context, builder: (context) => FuelTypeSwitcher(_selectedFuelType, _selectedFuelCategory));
      fuelTypeSwitcherDialog.then((output) => handleFuelTypeSwitch(output),
          onError: (errorOutput, s) => LogUtil.error(_TAG, '_getFuelTypeSwitcherButton::error output $s'));
    }, child: Container(
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  child: Text('${_selectedFuelType.fuelName}', style: TextStyle(fontSize: 18, color: Colors.black)),
                  padding: EdgeInsets.only(right: 10)),
              _fuelTypeSwitcherIcon
            ])));
  }

  void handleFuelTypeSwitch(final FuelTypeSwitcherResponseParams params) {
    if (params != null) {
      LogUtil.debug(_TAG, 'Params received : ${params.fuelType} ${params.fuelType}');
      setState(() {
        _selectedFuelCategory = params.fuelCategory;
        _selectedFuelType = params.fuelType;
      });
    } else {
      LogUtil.debug(_TAG, 'handleFuelTypeSwitch::No response returned from FuelTypeSwitcher');
    }
  }
}
