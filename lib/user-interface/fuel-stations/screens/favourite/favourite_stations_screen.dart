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
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/fuel_station_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/nearby/nearby_stations_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_switcher_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/floating_panel_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_type_switcher_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_list_widget.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/favorite_fuel_stations.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/fuel_type_switcher_data.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/service/favorite_fuel_stations_service.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/no_favourite_stations_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/service/fuel_type_switcher_service.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped-app-bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FavouriteStationsScreen extends StatefulWidget {
  static const routeName = '/favourite-stations';
  const FavouriteStationsScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteStationsScreen> createState() => _FavouriteStationsScreenState();
}

class _FavouriteStationsScreenState extends State<FavouriteStationsScreen> {
  static const _tag = 'FavouriteStationsScreen';
  final FavoriteFuelStationsService _favoriteFuelStationsDataSource =
      FavoriteFuelStationsService(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  ScrollController _scrollController = ScrollController();
  final FuelTypeSwitcherService _fuelTypeSwitcherDataSource = FuelTypeSwitcherService();
  static const Map<int, IconData> sortHeaders = {
    0: Icons.label,
    1: Icons.attach_money,
    2: Icons.navigation,
    3: Icons.shopping_cart
  };

  final FuelStationsScreenColorScheme colorScheme =
      getIt.get<FuelStationsScreenColorScheme>(instanceName: fsScreenColorSchemeName);
  late StreamController<FuelTypeSwitcherData> _fuelTypeSwitcherDataStreamController;

  Future<FavoriteFuelStations>? _favoriteFuelStationsFuture;

  int _userSettingsVersion = 0;
  int sortOrder = 1;
  List<FuelStation> _favouriteStations = [];
  FuelType? _selectedFuelType;
  FuelCategory? _selectedFuelCategory;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();
    _fuelTypeSwitcherDataStreamController = StreamController<FuelTypeSwitcherData>.broadcast();
  }

  @override
  void dispose() {
    _fuelTypeSwitcherDataStreamController.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
    return Scaffold(
        appBar: const PumpedAppBar(),
        drawer: const NavDrawerWidget(),
        body: _drawBody(),
        floatingActionButton: FloatBoxPanelWidget(
            panelIcon: Icons.sort_outlined,
            backgroundColor: colorScheme.floatingBoxPanelBackgroundColor,
            contentColor: colorScheme.floatingBoxPanelSelectedColor,
            nonSelColor: colorScheme.floatingBoxPanelNonSelectedColor,
            buttons: sortHeaders.values.toList(),
            selIndex: sortOrder,
            onPressed: (index) {
              setState(() {
                sortOrder = index;
                if (_favouriteStations.isNotEmpty) {
                  _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 500));
                }
              });
            }));
  }

  _drawBody() {
    return Container(
        color: colorScheme.bodyBackgroundColor,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20), child: _getStationTypeFuelTypeSwitcher()),
          Expanded(child: _getFavouriteFuelStationsFutureBuilder()),
        ]));
  }

  Widget _getStationTypeFuelTypeSwitcher() {
    return Material(
        color: colorScheme.stationFuelTypeSwitcherColor,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FuelStationSwitcherWidget(
              fuelStationType: 'favourite-fuel-station', onChangeCallback: _handleFuelStationSwitch),
          _getFuelTypeSwitcherStreamBuilder()
        ]));
  }

  StreamBuilder<FuelTypeSwitcherData> _getFuelTypeSwitcherStreamBuilder() {
    return StreamBuilder(
        stream: _fuelTypeSwitcherDataStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Material(color: Colors.white, child: Text('Error Loading'));
          } else if (snapshot.hasData) {
            return _getFuelTypeSwitcherButton(snapshot.data!);
          } else {
            return const Text('Loading');
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

  void _handleFuelStationSwitch(final String? fuelStationType) {
    LogUtil.debug(_tag, 'fuelStationType found as $fuelStationType');
    if (fuelStationType != null && fuelStationType == 'near-by-fuel-station') {
      LogUtil.debug(_tag, 'Named Replacement for ${NearbyStationsScreen.routeName}');
      Navigator.pushReplacementNamed(context, NearbyStationsScreen.routeName);
    }
  }

  _getFavouriteFuelStationsFutureBuilder() {
    return FutureBuilder<FavoriteFuelStations>(
        future: _favoriteFuelStationsFuture,
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
                return const NoFavouriteStationsWidget();
              } else if (snapshot.hasData) {
                final FavoriteFuelStations data = snapshot.data!;
                return RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      setState(() {
                        _favoriteFuelStationsFuture = _favoriteFuelStationsDataSource.getFuelStations();
                      });
                    },
                    child: _favoriteFuelStationWidget(data));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
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
        return FuelStationListWidget(_scrollController, _favouriteStations, _selectedFuelType!, sortOrder);
      } else {
        return const NoFavouriteStationsWidget();
      }
    }
  }
}
