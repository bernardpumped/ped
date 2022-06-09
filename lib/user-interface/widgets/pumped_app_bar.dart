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
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar_color_scheme.dart';

class PumpedAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PumpedAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<PumpedAppBar> createState() => _PumpedAppBarState();
}

class _PumpedAppBarState extends State<PumpedAppBar> {
  final PumpedAppBarColorScheme colorScheme = getIt.get<PumpedAppBarColorScheme>(instanceName: appBarColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    return AppBar(
        surfaceTintColor: colorScheme.backgroundColor,
        elevation: 0,
        backgroundColor: colorScheme.backgroundColor,
        iconTheme: IconThemeData(color: colorScheme.iconThemeColor),
        centerTitle: false,
        foregroundColor: colorScheme.foregroundColor,
        automaticallyImplyLeading: true,
        title:
            Text('Pumped', style: TextStyle(fontSize: 28, color: colorScheme.titleColor, fontWeight: FontWeight.bold)));
  }
}
