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
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';

class ThemingScreen extends StatefulWidget {
  const ThemingScreen({Key? key}) : super(key: key);

  @override
  State<ThemingScreen> createState() => _ThemingScreenState();
}

class _ThemingScreenState extends State<ThemingScreen> {
  static const _lightTheme = 'LIGHT_THEME';
  static const _darkTheme = 'DARK_THEME';
  static const _systemTheme = 'SYSTEM_THEME';

  static const _themes = {_lightTheme: 'Light Theme', _darkTheme: 'Dark Theme', _systemTheme: 'System Theme'};

  String selectedTheme = _lightTheme;

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
        height: MediaQuery.of(context).size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Row(children: [
                const Icon(Icons.compare_outlined, size: 35),
                const SizedBox(width: 10),
                Text('Theme ', style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center)
              ])),
          Card(
              child:
                  Column(children: [_getMenuItem(_lightTheme), _getMenuItem(_darkTheme), _getMenuItem(_systemTheme)])),
          Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                WidgetUtils.getRoundedButton(
                    context: context,
                    buttonText: 'Set App Theme',
                    iconData: Icons.compare_outlined,
                    onTapFunction: () {})
              ]))
        ]));
  }

  RadioListTile<String> _getMenuItem(final String themeValue) {
    return RadioListTile<String>(
        value: themeValue,
        groupValue: selectedTheme,
        onChanged: (newVal) {
          setState(() {
            selectedTheme = newVal!;
          });
        },
        title: Text(_themes[themeValue]!, style: Theme.of(context).textTheme.headline6));
  }
}
