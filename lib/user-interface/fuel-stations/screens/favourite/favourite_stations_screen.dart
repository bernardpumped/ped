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
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-station-sorter/fuel_station_sorter_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-type-switcher/fuel_type_switcher_btn.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-type-switcher/fuel_type_switcher_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_list_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_type.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/model/favorite_fuel_stations.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/model/fuel_type_switcher_data.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/service/favorite_fuel_stations_service.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/no_favourite_stations_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/service/fuel_type_switcher_service.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FavouriteStationsScreen extends StatefulWidget {
  static const routeName = '/ped/fuel-stations/favourite';
  static const viewLabel = 'Favourite Fuel Stations';
  static const viewIcon = Icons.favorite_outline;
  static const viewSelectedIcon = Icons.favorite;

  const FavouriteStationsScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteStationsScreen> createState() => _FavouriteStationsScreenState();
}

class _FavouriteStationsScreenState extends State<FavouriteStationsScreen> {
  static const _tag = 'FavouriteStationsScreen';
  final FavoriteFuelStationsService _favoriteFuelStationsDataSource =
      FavoriteFuelStationsService(getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName));
  final UnderMaintenanceService _underMaintenanceService =
      getIt.get<UnderMaintenanceService>(instanceName: underMaintenanceServiceName);
  ScrollController _scrollController = ScrollController();
  final FuelTypeSwitcherService _fuelTypeSwitcherDataSource = FuelTypeSwitcherService();

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
    _underMaintenanceService.registerSubscription(_tag, context, (event, context) {
      if (!mounted) return;
      WidgetUtils.showPumpedUnavailabilityMessage(event, context);
      LogUtil.debug(_tag, '${event.data}');
    });
  }

  @override
  void dispose() {
    _fuelTypeSwitcherDataStreamController.close();
    _underMaintenanceService.cancelSubscription(_tag);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    _fuelTypeSwitcherDataSource.addFuelTypeSwitcherDataToStream(_fuelTypeSwitcherDataStreamController);
    return Scaffold(
        appBar: const PumpedAppBar(
            title: FavouriteStationsScreen.viewLabel, icon: FavouriteStationsScreen.viewSelectedIcon),
        drawer: const NavDrawerWidget(),
        body: _drawBody());
  }

  void scrollFuelStations(final int sortOrder) {
    setState(() {
      this.sortOrder = sortOrder;
      if (_favouriteStations.isNotEmpty) {
        _scrollController.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 500));
      }
    });
  }

  _drawBody() {
    return Stack(children: [
      _getFavouriteFuelStationsFutureBuilder(),
      Positioned(right: 20, bottom: 20, child: _getFuelTypeSwitcherStreamBuilder())
    ]);
  }

  StreamBuilder<FuelTypeSwitcherData> _getFuelTypeSwitcherStreamBuilder() {
    return StreamBuilder(
        stream: _fuelTypeSwitcherDataStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
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
      return Center(child: Text(locationErrorReason, textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor));
    } else {
      _favouriteStations = data.fuelStations ?? [];
      if (_favouriteStations.isNotEmpty) {
        LogUtil.debug(_tag, '_favoriteFuelStationWidget::fuel type ${_selectedFuelType?.fuelType}');
        return Stack(children: [
          FuelStationListWidget(
              _scrollController, _favouriteStations, _selectedFuelType!, sortOrder, FuelStationType.favourite),
          Positioned(right: 20, bottom: 80, child: FuelStationSorterWidget(parentUpdateFunction: scrollFuelStations))
        ]);
      } else {
        return const NoFavouriteStationsWidget();
      }
    }
  }
}
