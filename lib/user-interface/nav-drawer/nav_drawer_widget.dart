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
import 'package:pumped_end_device/user-interface/about/screen/about_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/nearby/nearby_stations_screen.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_color_scheme.dart';
import 'package:pumped_end_device/user-interface/settings/screen/settings_screen.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/update_history_screen.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'nav_drawer_item_widget.dart';

class NavDrawerWidget extends StatefulWidget {
  static const _userImage = 'assets/images/ic_user.png';

  const NavDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavDrawerWidget> createState() => _NavDrawerWidgetState();
}

int selectedIndex = 0;

class _NavDrawerWidgetState extends State<NavDrawerWidget> {
  static const _tag = 'NavigationDrawer';
  final NavDrawerColorScheme colorScheme = getIt.get<NavDrawerColorScheme>(instanceName: navDrawerColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    LogUtil.debug(_tag, 'Building NavigationDrawer drawer : selected = $selectedIndex');
    return Drawer(
      child: Material(
        color: colorScheme.backgroundColor,
        child: ListView(
          children: [
            _drawerHeaderWidget(),
            const SizedBox(height: 10),
            Divider(color: colorScheme.dividerColor),
            _userDetailsWidget(),
            Divider(color: colorScheme.dividerColor),
            const SizedBox(height: 10),
            NavDrawerItemWidget(
                itemIndex: 0, label: 'Fuel Stations', icon: Icons.local_gas_station,
                callback: ()=> _selectItem(context, 0, NearbyStationsScreen.routeName),
                selected: selectedIndex == 0),
            const SizedBox(height: 10),
            Divider(color: colorScheme.dividerColor),
            NavDrawerItemWidget(
                itemIndex: 1, label: 'Settings', icon: Icons.settings_outlined,
                callback: ()=> _selectItem(context, 1, SettingsScreen.routeName),
                selected: selectedIndex == 1),
            const SizedBox(height: 10),
            NavDrawerItemWidget(
                itemIndex: 2, label: 'Updates History', icon: Icons.update,
                callback: ()=> _selectItem(context, 2, UpdateHistoryScreen.routeName),
                selected: selectedIndex == 2),
            const SizedBox(height: 10),
            NavDrawerItemWidget(
                itemIndex: 3, label: 'About', icon: Icons.info_outline,
                callback: ()=> _selectItem(context, 3, AboutScreen.routeName),
                selected: selectedIndex == 3),
            const SizedBox(height: 10),
            Divider(color: colorScheme.dividerColor),
            NavDrawerItemWidget(
                itemIndex: 4, label: 'Send Feedback', icon: Icons.feedback_outlined,
                callback: ()=> _selectItem(context, 4, NearbyStationsScreen.routeName),
                selected: selectedIndex == 4),
            const SizedBox(height: 10),
            NavDrawerItemWidget(
                itemIndex: 5, label: 'Help', icon: Icons.help_outline_outlined,
                callback: ()=> _selectItem(context, 5, NearbyStationsScreen.routeName),
                selected: selectedIndex == 5),
            Divider(color: colorScheme.dividerColor),
            NavDrawerItemWidget(
                itemIndex: 6, label: 'Logout', icon: Icons.logout,
                callback: ()=> _selectItem(context, 6, NearbyStationsScreen.routeName),
                selected: selectedIndex == 6)]))
    );
  }

  _drawerHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(children: [
        const Image(image: AssetImage(NavDrawerColorScheme.pumpedImage), height: 65),
        Padding(padding: const EdgeInsets.only(left: 20),
          child: Text('Fuel Finder', style: TextStyle(color: colorScheme.textColor, fontSize: 24, fontWeight: FontWeight.w500)))]));
  }

  _userDetailsWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
        child:
          Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image: AssetImage(NavDrawerWidget._userImage), height: 60),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bernard', style: TextStyle(color: colorScheme.textColor, fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 15),
                    Text('bernard@pumpedfuel.com', style: TextStyle(color: colorScheme.textColor, fontSize: 13, fontWeight: FontWeight.normal))]))]));
  }

  _selectItem(final BuildContext context, final int index, final String route) {
    if (selectedIndex == index) {
      return;
    }
    setState(() {
      selectedIndex = index;
    });
    Navigator.pushReplacementNamed(context, route);
  }
}