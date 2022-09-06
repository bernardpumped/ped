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

class TextScalingScreen extends StatefulWidget {
  const TextScalingScreen({Key? key}) : super(key: key);

  @override
  State<TextScalingScreen> createState() => _TextScalingScreenState();
}

class _TextScalingScreenState extends State<TextScalingScreen> {
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
    return Container(
        padding: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
        height: MediaQuery.of(context).size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Row(children: [
                const Icon(Icons.linear_scale_rounded, size: 35),
                const SizedBox(width: 10),
                Text('Text Scaling', style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center)
              ])),
          Card(
              child: Column(children: [
            _getMenuItem(_systemTextScale),
            _getMenuItem(_smallTextScale),
            _getMenuItem(_mediumTextScale),
            _getMenuItem(_largeTextScale),
            _getMenuItem(_hugeTextScale)
          ])),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              WidgetUtils.getRoundedButton(
                  context: context,
                  buttonText: 'Scale Text',
                  iconData: Icons.linear_scale_rounded,
                  onTapFunction: () {})
            ]),
          )
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
        title: Text(_textScales[value]!, style: Theme.of(context).textTheme.headline6));
  }
}
