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

class NavDrawerItemWidget extends StatelessWidget {
  static const _tag = 'DrawerMenuItem';

  final int itemIndex;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback callback;
  final bool selected;

  const NavDrawerItemWidget(
      {Key? key,
      required this.itemIndex,
      required this.label,
      required this.icon,
      required this.selectedIcon,
      required this.callback,
      required this.selected})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final displayIcon = selected ? selectedIcon : icon;
    return GestureDetector(
        onTap: () {
          LogUtil.debug(_tag, '$label is currently selected');
          callback();
        },
        child: Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
            child: Icon(displayIcon, size: 35)));
  }
}
