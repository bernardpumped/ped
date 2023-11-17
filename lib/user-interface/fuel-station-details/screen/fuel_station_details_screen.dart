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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/contact_tab.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/fuel_prices_tab.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/promos/widget/no_promotions_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/promos/widget/promotions_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/expanded_header_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationDetailsScreen extends StatefulWidget {
  static const routeName = '/ped/fuel-stations/details';
  final FuelStation selectedFuelStation;
  final FuelType selectedFuelType;

  const FuelStationDetailsScreen({super.key, required this.selectedFuelStation, required this.selectedFuelType});

  @override
  State<FuelStationDetailsScreen> createState() => _FuelStationDetailsScreenState();
}

class _FuelStationDetailsScreenState extends State<FuelStationDetailsScreen> {
  static const _tag = 'FuelStationDetailsScreen';
  static const _fuelPricesTabHeader = "Fuel Prices";
  static const _promotionsTabHeader = "Offers";
  static const _contactTabHeader = "Contact";

  final UnderMaintenanceService _underMaintenanceService =
      getIt.get<UnderMaintenanceService>(instanceName: underMaintenanceServiceName);

  final List<String> _tabs = [_fuelPricesTabHeader, _promotionsTabHeader, _contactTabHeader];
  int _selectedTabIndex = 0;
  bool homeScreenRefreshNeeded = false;

  @override
  void initState() {
    super.initState();
    _underMaintenanceService.registerSubscription(_tag, context, (event, context) {
      if (!mounted) return;
      WidgetUtils.showPumpedUnavailabilityMessage(event, context);
      LogUtil.debug(_tag, '${event.data}');
    });
  }

  @override
  void dispose() {
    _underMaintenanceService.cancelSubscription(_tag);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final FuelStation fuelStation = widget.selectedFuelStation;
    return WillPopScope(
        onWillPop: () {
          bool tmp = homeScreenRefreshNeeded;
          homeScreenRefreshNeeded = false;
          LogUtil.debug(_tag, 'Returning value of homeScreenRefreshNeeded as $tmp');
          Navigator.pop(context, tmp);
          return Future.value(false);
        },
        child: _fuelStationDetailsView(fuelStation));
  }

  DefaultTabController _fuelStationDetailsView(final FuelStation fuelStation) {
    double scaleFactorToUse = PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor ?? 1;
    // scaleFactorToUse = scaleFactorToUse > 1 ? scaleFactorToUse * 1.05 : scaleFactorToUse;
    return DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    pinned: true,
                    stretch: true,
                    expandedHeight: 240 * (scaleFactorToUse >= 1? scaleFactorToUse : 1),
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    collapsedHeight: 240 * (scaleFactorToUse >= 1? scaleFactorToUse : 1),
                    flexibleSpace: FlexibleSpaceBar(background: ExpandedHeaderWidget(fuelStation: fuelStation))),
                SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTabBarDelegate(TabBar(
                        onTap: (tapIndex) {
                          setState(() {
                            _selectedTabIndex = tapIndex;
                          });
                        },
                        labelPadding: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                        tabs: _tabs.map((tabName) {
                          return Tab(child: Expanded(child: Text(tabName, textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor, overflow: TextOverflow.ellipsis,)));
                        }).toList())))
              ];
            },
            body: CustomScrollView(
                key: PageStorageKey<String>(_tabs[_selectedTabIndex]),
                slivers: <Widget>[SliverToBoxAdapter(child: _getChildTabContent(_tabs[_selectedTabIndex]))])));
  }

  Widget? _getChildTabContent(final String tabName) {
    dynamic promotions;
    Widget? tabWidget;
    switch (tabName) {
      case _contactTabHeader:
        tabWidget = ContactTabWidget(widget.selectedFuelStation);
        break;
      case _fuelPricesTabHeader:
        tabWidget = FuelPricesTabWidget(widget.selectedFuelStation, widget.selectedFuelType);
        break;
      case _promotionsTabHeader:
        tabWidget = promotions == null ? const NoPromotionsWidget() : const PromotionsWidget();
        break;
    }
    return tabWidget;
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(final BuildContext context, final double shrinkOffset, final bool overlapsContent) {
    return Container(color: Theme.of(context).colorScheme.background, child: _tabBar);
  }

  @override
  bool shouldRebuild(final _SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
