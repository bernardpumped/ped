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
import 'package:pumped_end_device/user-interface/fuel-station-details/utils/firebase_service.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/favourite/favourite_stations_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/nearby/nearby_stations_screen.dart';
import 'package:pumped_end_device/user-interface/help/screen/help_screen.dart';
import 'package:pumped_end_device/user-interface/send-feedback/screens/send_feedback_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/settings_screen.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/update_history_screen.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/app_theme.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'nav_drawer_item_widget.dart';

class NavDrawerWidget extends StatefulWidget {
  static const _userImage = 'assets/images/ic_user.png';

  const NavDrawerWidget({super.key});

  @override
  State<NavDrawerWidget> createState() => _NavDrawerWidgetState();
}

int selectedIndex = 0;

class _NavDrawerWidgetState extends State<NavDrawerWidget> {
  static const _tag = 'NavigationDrawer';
  final FirebaseService service = getIt.get<FirebaseService>(instanceName: firebaseServiceInstanceName);
  static const _nearbyViewIndex = 0;
  static const _favouriteViewIndex = 1;
  static const _settingsViewIndex = 2;
  static const _updateHistoryViewIndex = 3;
  static const _aboutViewIndex = 4;
  static const _feedbackViewIndex = 5;
  static const _helpViewIndex = 6;
  static const _logoutFunctionIndex = 7;

  @override
  Widget build(final BuildContext context) {
    LogUtil.debug(_tag, 'Building NavigationDrawer drawer : selected = $selectedIndex');
    SignedInUser? signedInUser = service.getSignedInUser();
    return Drawer(
        child: ListView(children: [
      _drawerHeaderWidget(),
      const SizedBox(height: 10),
      const Divider(),
      _userDetailsWidget(signedInUser),
      const Divider(),
      const SizedBox(height: 10),
      NavDrawerItemWidget(
          itemIndex: _nearbyViewIndex,
          label: NearbyStationsScreen.viewLabel,
          icon: NearbyStationsScreen.viewIcon,
          selectedStateIcon: NearbyStationsScreen.viewSelectedIcon,
          callback: () => _selectItem(context, _nearbyViewIndex, NearbyStationsScreen.routeName),
          selected: selectedIndex == _nearbyViewIndex),
      const SizedBox(height: 10),
      NavDrawerItemWidget(
          itemIndex: _favouriteViewIndex,
          label: FavouriteStationsScreen.viewLabel,
          icon: FavouriteStationsScreen.viewIcon,
          selectedStateIcon: FavouriteStationsScreen.viewSelectedIcon,
          callback: () => _selectItem(context, _favouriteViewIndex, FavouriteStationsScreen.routeName),
          selected: selectedIndex == _favouriteViewIndex),
      const SizedBox(height: 10),
      const Divider(),
      NavDrawerItemWidget(
          itemIndex: _settingsViewIndex,
          label: SettingsScreen.viewLabel,
          icon: SettingsScreen.viewIcon,
          selectedStateIcon: SettingsScreen.viewSelectedIcon,
          callback: () => _selectItem(context, _settingsViewIndex, SettingsScreen.routeName),
          selected: selectedIndex == _settingsViewIndex),
      const SizedBox(height: 10),
      NavDrawerItemWidget(
          itemIndex: _updateHistoryViewIndex,
          label: UpdateHistoryScreen.viewLabel,
          icon: UpdateHistoryScreen.viewIcon,
          selectedStateIcon: UpdateHistoryScreen.viewSelectedIcon,
          callback: () => _selectItem(context, _updateHistoryViewIndex, UpdateHistoryScreen.routeName),
          selected: selectedIndex == _updateHistoryViewIndex),
      const SizedBox(height: 10),
      NavDrawerItemWidget(
          itemIndex: _aboutViewIndex,
          label: AboutScreen.viewLabel,
          icon: AboutScreen.viewIcon,
          selectedStateIcon: AboutScreen.viewSelectedIcon,
          callback: () => _selectItem(context, _aboutViewIndex, AboutScreen.routeName),
          selected: selectedIndex == _aboutViewIndex),
      const SizedBox(height: 10),
      const Divider(),
      NavDrawerItemWidget(
          itemIndex: _feedbackViewIndex,
          label: SendFeedbackScreen.viewLabel,
          icon: SendFeedbackScreen.viewIcon,
          selectedStateIcon: SendFeedbackScreen.viewSelectedIcon,
          callback: () => _selectItem(context, _feedbackViewIndex, SendFeedbackScreen.routeName),
          selected: selectedIndex == _feedbackViewIndex),
      const SizedBox(height: 10),
      NavDrawerItemWidget(
          itemIndex: _helpViewIndex,
          label: HelpScreen.viewLabel,
          icon: HelpScreen.viewIcon,
          selectedStateIcon: HelpScreen.viewSelectedIcon,
          callback: () => _selectItem(context, _helpViewIndex, HelpScreen.routeName),
          selected: selectedIndex == _helpViewIndex),
      const Divider(),
      signedInUser != null && signedInUser.isSignedIn()
          ? NavDrawerItemWidget(
              itemIndex: _logoutFunctionIndex,
              label: 'Logout',
              icon: Icons.logout_outlined,
              selectedStateIcon: Icons.logout,
              callback: () => _signOut(signedInUser),
              selected: selectedIndex == _logoutFunctionIndex)
          : const SizedBox(height: 0)
    ]));
  }

  _drawerHeaderWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(children: [
          Image(image: AssetImage(AppTheme.getPumpedLogo(context)), height: 65),
          Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Fuel Finder', style: Theme.of(context).textTheme.displaySmall,
                  textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
        ]));
  }

  _userDetailsWidget(final SignedInUser? signedInUser) {
    String userDisplayName = signedInUser != null && signedInUser.getUserDisplayName() != null
        ? signedInUser.getUserDisplayName()!
        : 'Welcome Guest';
    String? userEmail = signedInUser?.getEmail();
    String? photoURL = signedInUser?.getPhotoUrl();
    return Padding(
        padding: const EdgeInsets.only(left: 30, top: 15, bottom: 15),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          photoURL != null
              ? Image(image: NetworkImage(photoURL), height: 60)
              : const Image(image: AssetImage(NavDrawerWidget._userImage), height: 60),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(userDisplayName, style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
              const SizedBox(height: 10),
              userEmail != null
                  ? Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(userEmail, style: Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
                  : const SizedBox(height: 0)
            ]),
          )
        ]));
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

  _signOut(final SignedInUser signedInUser) async {
    final FirebaseService service = getIt.get<FirebaseService>(instanceName: firebaseServiceInstanceName);
    await service.signOut(signedInUser);
    setState(() {});
  }
}
