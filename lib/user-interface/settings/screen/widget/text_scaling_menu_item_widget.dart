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

class TextScalingMenuItemWidget extends StatefulWidget {
  const TextScalingMenuItemWidget({Key? key}) : super(key: key);

  @override
  State<TextScalingMenuItemWidget> createState() => _TextScalingMenuItemWidgetState();
}

class _TextScalingMenuItemWidgetState extends State<TextScalingMenuItemWidget> {
  static const _systemTextScale = 'SYSTEM_TEXT_SCALE';
  static const _smallTextScale = 'SMALL_TEXT_SCALE';
  static const _mediumTextScale = 'MEDIUM_TEXT_SCALE';
  static const _largeTextScale = 'LARGE_TEXT_SCALE';
  static const _hugeTextScale = 'HUGE_TEXT_SCALE';

  static const _textScales = {
    _systemTextScale: 'System',
    _smallTextScale: 'Small',
    _mediumTextScale: 'Medium',
    _largeTextScale: 'Large',
    _hugeTextScale: 'Huge'
  };

  String selectedTextScale = _systemTextScale;

  @override
  Widget build(final BuildContext context) {
    return Card(
        child: ExpansionTile(
            title: Text("Text Scale - ${_textScales[selectedTextScale]}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
            leading: const Icon(Icons.linear_scale_rounded, size: 35),
            children: [
              _getMenuItem(_systemTextScale),
              _getMenuItem(_smallTextScale),
              _getMenuItem(_mediumTextScale),
              _getMenuItem(_largeTextScale),
              _getMenuItem(_hugeTextScale)
            ]));
  }

  RadioListTile<String> _getMenuItem(final String value) {
    return RadioListTile<String>(
        value: value,
        groupValue: selectedTextScale,
        onChanged: (newVal) {
          setState(() {
            selectedTextScale = newVal!;
          });
        },
        title: Text(_textScales[value]!, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20)));
  }
}
