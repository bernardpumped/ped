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
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/utils/fuel_stations_sorter.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'fuel-station-list-item.dart';

class FuelStationListWidget extends StatefulWidget {
  final ScrollController _scrollController;
  final List<FuelStation> _fuelStations;
  final FuelType _selectedFuelType;
  final int sortOrder;

  const FuelStationListWidget(this._scrollController, this._fuelStations, this._selectedFuelType, this.sortOrder,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FuelStationListWidgetState();
  }
}

class _FuelStationListWidgetState extends State<FuelStationListWidget> with TickerProviderStateMixin {
  final FuelStationsSorter _fuelStationsSorter = FuelStationsSorter();

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
              child: _getFocusedMenu(
                  FuelStationListItem(fuelStation: fuelStation, selectedFuelType: widget._selectedFuelType)));
        });
  }

  Widget _getFocusedMenu(final Widget child) {
    return FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.40,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration:
            const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: const Duration(milliseconds: 100),
        animateMenuItems: false,
        blurBackgroundColor: Colors.black54,
        // openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
        menuOffset: 10.0, // Offset value to show menuItem from the selected item
        // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
        bottomOffsetHeight: 80.0,
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options
          FocusedMenuItem(title: const Text("Enter"), trailingIcon: const Icon(Icons.open_in_new), onPressed: () {}),
          FocusedMenuItem(
              title: const Text("Favorite"), trailingIcon: const Icon(Icons.bookmark_add_outlined), onPressed: () {}),
          FocusedMenuItem(
              title: const Text("Hide"), trailingIcon: const Icon(Icons.hide_source_outlined), onPressed: () {})
        ],
        onPressed: () {},
        child: child);
  }
}
