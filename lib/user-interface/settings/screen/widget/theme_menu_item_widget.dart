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

class ThemeMenuItemWidget extends StatefulWidget {
  const ThemeMenuItemWidget({Key? key}) : super(key: key);

  @override
  State<ThemeMenuItemWidget> createState() => _ThemeMenuItemWidgetState();
}

class _ThemeMenuItemWidgetState extends State<ThemeMenuItemWidget> {
  static const _lightTheme = 'LIGHT_THEME';
  static const _darkTheme = 'DARK_THEME';
  static const _systemTheme = 'SYSTEM_THEME';

  static const _themes = {_lightTheme: 'Light Theme', _darkTheme: 'Dark Theme', _systemTheme: 'System Theme'};

  String selectedTheme = _lightTheme;

  @override
  Widget build(final BuildContext context) {
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: ExpansionTile(
            title: Text("Theme - ${_themes[selectedTheme]}",
                style: const TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.w500)),
            leading: const Icon(Icons.compare_outlined, color: Colors.indigo, size: 30),
            children: [_getMenuItem(_lightTheme), _getMenuItem(_darkTheme), _getMenuItem(_systemTheme)]));
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
        title: Text(_themes[themeValue]!, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.indigo)));
  }
}
