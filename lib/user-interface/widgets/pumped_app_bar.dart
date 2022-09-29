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

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

class PumpedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  const PumpedAppBar({required this.title, this.icon, Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<PumpedAppBar> createState() => _PumpedAppBarState();
}

class _PumpedAppBarState extends State<PumpedAppBar> {
  @override
  Widget build(final BuildContext context) {
    final String title = StringUtils.isNotNullOrEmpty(widget.title) ? widget.title : 'Pumped';
    final Widget titleWidget;
    if (widget.icon != null) {
      titleWidget = Row(children: [
        Icon(widget.icon, size: 30),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: Theme.of(context).textTheme.headline2, overflow: TextOverflow.ellipsis))
      ]);
    } else {
      titleWidget = Text(title, style: Theme.of(context).textTheme.headline1);
    }
    return AppBar(automaticallyImplyLeading: true, title: titleWidget);
  }
}
