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
import 'package:pumped_end_device/user-interface/tabs/about/screen/about_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/edit_fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/fuel_stations_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/screens/cleanup_local_cache_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/screens/customize_search_settings_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/screens/settings_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/update_history_screen.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';

class PumpedBaseTabView extends StatefulWidget {
  static const routeName = '/homeScreen';

  const PumpedBaseTabView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PumpedBaseTabViewState();
  }
}

class _PumpedBaseTabViewState extends State<PumpedBaseTabView> {
  @override
  Widget build(final BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            iconSize: 25,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.black54,
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: PumpedIcons.searchTabIconSize30,
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: PumpedIcons.settingsTabIconSize30,
                  label: 'Settings'),
              BottomNavigationBarItem(
                  icon: PumpedIcons.updateHistoryTabIconSize30,
                  label: 'Update History'),
              BottomNavigationBarItem(
                  icon: PumpedIcons.aboutTabIconSize30,
                  label: 'About', backgroundColor: Colors.white)
            ]),
        // ignore: missing_return
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                  builder: (context) {
                    return CupertinoPageScaffold(child: FuelStationsScreen());
                  },
                  routes: {
                    EditFuelStationDetails.routeName: (context) => const EditFuelStationDetails(),
                    FuelStationDetailsScreen.routeName: (context) => const FuelStationDetailsScreen()
                  });
            case 1:
              return CupertinoTabView(
                  builder: (context) {
                    return const CupertinoPageScaffold(child: SettingsScreen());
                  },
                  routes: {
                    CustomizeSearchSettingsScreen.routeName: (context) => const CustomizeSearchSettingsScreen(),
                    CleanupLocalCacheScreen.routeName: (context) => const CleanupLocalCacheScreen()
                  });
            case 2:
              return CupertinoTabView(builder: (context) {
                return const CupertinoPageScaffold(child: UpdateHistoryScreen());
              });
            default :
              return CupertinoTabView(builder: (context) {
                return const CupertinoPageScaffold(child: AboutScreen());
              });
          }
        });
  }
}
