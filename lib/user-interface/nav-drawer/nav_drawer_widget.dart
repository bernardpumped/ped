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
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'nav_drawer_item_widget.dart';

class NavDrawerWidget extends StatefulWidget {
  final double width;
  final PageController pageController;

  const NavDrawerWidget({super.key, required this.width, required this.pageController});

  @override
  State<NavDrawerWidget> createState() => _NavDrawerWidgetState();
}

int selectedIndex = 0;

class _NavDrawerWidgetState extends State<NavDrawerWidget> {
  static const _tag = 'NavigationDrawer';

  @override
  Widget build(final BuildContext context) {
    LogUtil.debug(_tag, 'Building NavigationDrawer drawer : selected = $selectedIndex');
    return Container(
        width: widget.width,
        color: Theme.of(context).colorScheme.background,
        child: Card(
            child: ListView(children: [
              const Divider(),
              const SizedBox(height: 10),
              NavDrawerItemWidget(
                  itemIndex: 0,
                  label: 'Nearby Fuel Stations',
                  selectedIcon: Icons.near_me,
                  icon: Icons.near_me_outlined,
                  callback: () => _selectItem(context, 0),
                  selected: selectedIndex == 0),
              NavDrawerItemWidget(
                  itemIndex: 1,
                  label: 'Favourite Fuel Stations',
                  selectedIcon: Icons.favorite,
                  icon: Icons.favorite_border_outlined,
                  callback: () => _selectItem(context, 1),
                  selected: selectedIndex == 1),
              const SizedBox(height: 10),
              const Divider(),
              NavDrawerItemWidget(
                  itemIndex: 2,
                  label: 'Settings',
                  selectedIcon: Icons.settings,
                  icon: Icons.settings_outlined,
                  callback: () => _selectItem(context, 2),
                  selected: selectedIndex == 2),
              const SizedBox(height: 10),
              NavDrawerItemWidget(
                  itemIndex: 3,
                  label: 'About',
                  selectedIcon: Icons.info,
                  icon: Icons.info_outline,
                  callback: () => _selectItem(context, 3),
                  selected: selectedIndex == 3),
              const SizedBox(height: 10),
              const Divider(),
              NavDrawerItemWidget(
                  itemIndex: 4,
                  label: 'Send Feedback',
                  selectedIcon: Icons.feedback,
                  icon: Icons.feedback_outlined,
                  callback: () => _helpScreen(),
                  selected: selectedIndex == 4),
              const SizedBox(height: 10),
              NavDrawerItemWidget(
                  itemIndex: 6,
                  label: 'Help',
                  selectedIcon: Icons.help,
                  icon: Icons.help_outline,
                  callback: () => _helpScreen(),
                  selected: selectedIndex == 6),
              const Divider()
            ])));
  }

  _selectItem(final BuildContext context, final int index) {
    if (selectedIndex == index) {
      return;
    }
    setState(() {
      selectedIndex = index;
    });
    widget.pageController.jumpToPage(index);
  }

  _helpScreen() async {
    String notificationUrl = 'https://pumpedfuel.com';
    try {
      if (await canLaunchUrlString(notificationUrl)) {
        await launchUrlString(notificationUrl, mode: LaunchMode.externalApplication);
      } else {
        LogUtil.debug(_tag, 'Cannot send email $notificationUrl');
      }
    } on Exception catch (e) {
      LogUtil.debug(_tag, 'Exception invoking notificationUrl $notificationUrl $e');
    }
  }
}
