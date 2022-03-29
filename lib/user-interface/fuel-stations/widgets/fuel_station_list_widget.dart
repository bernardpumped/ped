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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/utils/fuel_stations_sorter.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'fuel-station-list-item.dart';

class FuelStationListWidget extends StatefulWidget {
  final ScrollController _scrollController;
  final List<FuelStation> _fuelStations;
  final FuelType _selectedFuelType;
  final int sortOrder;

  const FuelStationListWidget(
      this._scrollController, this._fuelStations, this._selectedFuelType, this.sortOrder, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FuelStationListWidgetState();
  }
}

class _FuelStationListWidgetState extends State<FuelStationListWidget> with TickerProviderStateMixin {
  static const _tag = 'FuelStationListWidget';
  final FuelStationsSorter _fuelStationsSorter = FuelStationsSorter();

  @override
  Widget build(final BuildContext context) {
    _fuelStationsSorter.sortFuelStations(widget._fuelStations, widget._selectedFuelType.fuelType, widget.sortOrder);
    return ImplicitlyAnimatedList<FuelStation>(
        // To provide scrolling behavior to lists
        // which are smaller than screen size.
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
          return FuelStationListItem(fuelStation: fuelStation, selectedFuelType: widget._selectedFuelType);
          // return FuelStationListItem(fuelStation: fuelStation, selectedFuelType: widget._selectedFuelType);
        });
  }

  void rebuildTriggerOnDataUpdate() {
    setState(() {
      LogUtil.debug(_tag, 'Triggering rebuild');
      _goToElement(0, widget._fuelStations.length);
    });
  }

  void _goToElement(final int index, final int totalElements) {
    // 155 is the height of collapsed container
    // index of 6th element is 5
    // 280 is the height of expanded container.
    double scrollToOffset = (155.0 * index);
    double totalHeight = 155.0 * totalElements;
    if (scrollToOffset + 280 > totalHeight) {
      scrollToOffset = totalHeight - 280;
    }
    widget._scrollController
        .animateTo(scrollToOffset, duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
  }
}
