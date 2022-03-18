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
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/utils/fuel_stations_sorter.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/widgets/fuel_station_list_item_collapsed_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/widgets/fuel_station_list_item_expanded_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationListWidget extends StatefulWidget {
  final ScrollController _scrollController;
  final List<FuelStation> _fuelStations;
  final List<bool> _expandedChildren;
  final FuelType _selectedFuelType;
  final int sortOrder;

  const FuelStationListWidget(
      this._scrollController, this._fuelStations, this._expandedChildren, this._selectedFuelType, this.sortOrder, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FuelStationListWidgetState();
  }
}

class _FuelStationListWidgetState extends State<FuelStationListWidget> with TickerProviderStateMixin {
  static const _tag = 'FuelStationListWidget';
  final FuelStationsSorter _fuelStationsSorter = FuelStationsSorter();
  int currentExpandedIndex = -1;

  void changeStateOfRow(int index) {
    currentExpandedIndex == index ? currentExpandedIndex = -1 : currentExpandedIndex = index;
    for (int i = 0; i < widget._expandedChildren.length; i++) {
      widget._expandedChildren[i] = false;
    }
    if (currentExpandedIndex >= 0) {
      widget._expandedChildren[currentExpandedIndex] = true;
    }
  }

  Animation? collapsedAnimation;
  AnimationController? collapsedAnimationController;
  Animation? expandedAnimation;
  AnimationController? expandedAnimationController;

  @override
  void initState() {
    collapsedAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    collapsedAnimation = Tween(begin: 0.0, end: 1.0).animate(collapsedAnimationController!);
    expandedAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    expandedAnimation = Tween(begin: 0.0, end: 1.0).animate(expandedAnimationController!);
    super.initState();
  }

  @override
  void dispose() {
    collapsedAnimationController?.dispose();
    expandedAnimationController?.dispose();
    super.dispose();
  }

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
          if (widget._fuelStations != null && index > (widget._fuelStations.length - 1)) {
            return const SizedBox(height: 0);
          }
          final bool expanded = widget._expandedChildren[index];
          final FuelStation fuelStation = widget._fuelStations[index];
          if (expanded) {
            expandedAnimationController?.forward();
          } else {
            collapsedAnimationController?.forward();
          }
          return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    changeStateOfRow(index);
                    _goToElement(index, widget._fuelStations.length);
                  });
                },
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: FuelStationListItemCollapsedWidget(fuelStation, widget._selectedFuelType),
                  secondChild: FuelStationListItemExpandedWidget(
                      fuelStation, widget._selectedFuelType, rebuildTriggerOnDataUpdate),
                  crossFadeState: !expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                ),
              ));
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
