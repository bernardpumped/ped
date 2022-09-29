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
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/update-results/update_fuel_station_details_result.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/contact_tab.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/offers/widget/no_offers_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/offers/widget/offers_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/context_aware_fab.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/utils/fuel_station_update_merge_util.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/params/fuel_station_details_param.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/fuel_prices_tab.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/collapsed_header_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/expanded_header_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/sliver_app_bar_title.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationDetailsScreen extends StatefulWidget {
  static const routeName = '/ped/fuel-stations/details';

  const FuelStationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FuelStationDetailsScreen> createState() => _FuelStationDetailsScreenState();
}

class _FuelStationDetailsScreenState extends State<FuelStationDetailsScreen> {
  static const _tag = 'FuelStationDetailsScreen';
  static const _fuelPricesTabHeader = "Fuel Prices";
  static const _offersTabHeader = "Offers";
  static const _contactTabHeader = "Contact";

  final UnderMaintenanceService _underMaintenanceService =
      getIt.get<UnderMaintenanceService>(instanceName: underMaintenanceServiceName);

  final FuelStationUpdateMergeUtil _fuelStationUpdateMergeUtil = FuelStationUpdateMergeUtil();

  final List<String> _tabs = [_fuelPricesTabHeader, _offersTabHeader, _contactTabHeader];
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

  /*
    This method is invoked for the results of the updates which
    are sent to the backend.
   */
  void onUpdateResult(
      final FuelStation fuelStation, final UpdateFuelStationDetailsResult updateFuelStationDetailsResult) {
    LogUtil.debug(_tag,
        'onUpdateResult :: Received response from edit screen : ${updateFuelStationDetailsResult.updateFuelStationDetailType}');
    setState(() {
      _fuelStationUpdateMergeUtil.mergeFuelStationUpdateResult(fuelStation, updateFuelStationDetailsResult);
      homeScreenRefreshNeeded = true;
    });
  }

  void onFavouriteStatusChange() {
    homeScreenRefreshNeeded = true;
  }

  @override
  Widget build(final BuildContext context) {
    final FuelStationDetailsParam param = ModalRoute.of(context)?.settings.arguments as FuelStationDetailsParam;
    final FuelStation fuelStation = param.fuelStation;
    return WillPopScope(
        onWillPop: () {
          bool tmp = homeScreenRefreshNeeded;
          homeScreenRefreshNeeded = false;
          LogUtil.debug(_tag, 'Returning value of homeScreenRefreshNeeded as $tmp');
          Navigator.pop(context, tmp);
          return Future.value(false);
        },
        child: Scaffold(
            floatingActionButton: _selectedTabIndex == 2 || _selectedTabIndex == 0
                ? ContextAwareFab(fuelStation, _selectedTabIndex, onUpdateResult)
                : const SizedBox(width: 0),
            appBar: const PumpedAppBar(title: 'Fuel Station Details', icon: Icons.local_gas_station,),
            body: DefaultTabController(
                length: _tabs.length,
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                            pinned: true,
                            expandedHeight: 160,
                            automaticallyImplyLeading: false,
                            elevation: 0,
                            centerTitle: false,
                            collapsedHeight: 65,
                            title: SliverAppBarTitle(child: CollapsedHeaderWidget(fuelStation: fuelStation)),
                            flexibleSpace:
                                FlexibleSpaceBar(background: ExpandedHeaderWidget(fuelStation: fuelStation))),
                        SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverAppBarDelegate(TabBar(
                                onTap: (tapIndex) {
                                  setState(() {
                                    _selectedTabIndex = tapIndex;
                                  });
                                },
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                tabs: _tabs.map((tabName) {
                                  return Tab(
                                      child: Text(tabName,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.subtitle1));
                                }).toList())))
                      ];
                    },
                    body: CustomScrollView(key: PageStorageKey<String>(_tabs[_selectedTabIndex]), slivers: <Widget>[
                      SliverToBoxAdapter(child: _getChildTabContent(param, _tabs[_selectedTabIndex]))
                    ])))));
  }

  Widget? _getChildTabContent(final FuelStationDetailsParam param, final String tabName) {
    dynamic offers;
    Widget? tabWidget;
    switch (tabName) {
      case _contactTabHeader:
        tabWidget = ContactTabWidget(param, onFavouriteStatusChange);
        break;
      case _fuelPricesTabHeader:
        tabWidget = FuelPricesTabWidget(param);
        break;
      case _offersTabHeader:
        tabWidget = offers == null ? const NoOffersWidget() : const OffersWidget();
        break;
    }
    return tabWidget;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(final BuildContext context, final double shrinkOffset, final bool overlapsContent) {
    return Container(color: Theme.of(context).backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(final _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
