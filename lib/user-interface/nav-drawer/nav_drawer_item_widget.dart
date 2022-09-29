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
  final IconData selectedStateIcon;
  final VoidCallback callback;
  final bool selected;

  const NavDrawerItemWidget(
      {Key? key,
      required this.itemIndex,
      required this.label,
      required this.icon,
      required this.selectedStateIcon,
      required this.callback,
      required this.selected})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final backgroundColor = selected ? Theme.of(context).secondaryHeaderColor : Theme.of(context).backgroundColor;
    return GestureDetector(
        onTap: () {
          LogUtil.debug(_tag, '$label is currently selected');
          callback();
        },
        child: Container(
            margin: const EdgeInsets.only(right: 25),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(50.0))),
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 20), child: Icon(selected ? selectedStateIcon : icon, size: 25)),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(label, style: Theme.of(context).textTheme.subtitle2))
            ])));
  }
}