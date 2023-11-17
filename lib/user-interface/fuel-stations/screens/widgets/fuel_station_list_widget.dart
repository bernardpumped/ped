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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_type.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/utils/fuel_stations_sorter.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/user-interface/utils/animated-reorderable-list/implicitly_animated_list.dart';
import 'package:pumped_end_device/user-interface/utils/animated-reorderable-list/size_fade_transition.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'fuel_station_list_item_widget.dart';

class FuelStationListWidget extends StatefulWidget {
  final ScrollController _scrollController;
  final List<FuelStation> _fuelStations;
  final FuelType _selectedFuelType;
  final int sortOrder;
  final FuelStationType fuelStationType;
  final Function setSelectedFuelStation;

  const FuelStationListWidget(this._scrollController, this._fuelStations, this._selectedFuelType, this.sortOrder,
      this.fuelStationType, this.setSelectedFuelStation,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return _FuelStationListWidgetState();
  }
}

class _FuelStationListWidgetState extends State<FuelStationListWidget> with TickerProviderStateMixin {
  static const _tag = 'FuelStationListWidget';
  final FuelStationsSorter _fuelStationsSorter = FuelStationsSorter();

  @override
  void initState() {
    super.initState();
  }

  fuelStationListRefresh() {
    setState(() {
      LogUtil.debug(_tag, 'Refreshing screen for ${widget.fuelStationType}');
    });
  }

  @override
  Widget build(final BuildContext context) {
    _fuelStationsSorter.sortFuelStations(widget._fuelStations, widget._selectedFuelType.fuelType, widget.sortOrder);
    return ImplicitlyAnimatedList<FuelStation>(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: widget._scrollController,
        items: widget._fuelStations,
        areItemsTheSame: (a, b) {
          return a.stationId == b.stationId && a.isFaStation == b.isFaStation;
        },
        itemBuilder: (context, animation, item, index) {
          if (widget._fuelStations.isNotEmpty && index > (widget._fuelStations.length - 1)) {
            return const SizedBox(height: 0);
          }
          final FuelStation fuelStation = widget._fuelStations[index];
          return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: FuelStationListItemWidget(
                  fuelStation: fuelStation,
                  selectedFuelType: widget._selectedFuelType,
                  parentRefresh: fuelStationListRefresh,
                  setSelectedFuelStation: (fuelStation) => widget.setSelectedFuelStation(fuelStation)));
        });
  }
}
