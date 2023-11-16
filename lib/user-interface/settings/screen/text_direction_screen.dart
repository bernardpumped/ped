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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';

class TextDirectionScreen extends StatefulWidget {
  const TextDirectionScreen({Key? key}) : super(key: key);

  @override
  State<TextDirectionScreen> createState() => _TextDirectionScreenState();
}

class _TextDirectionScreenState extends State<TextDirectionScreen> {
  static const _basedOnLocale = 'BASED_ON_LOCALE';
  static const _ltrDirection = 'LTR';
  static const _rtlDirection = 'RTL';

  static const _textDirection = {_basedOnLocale: 'Based on Locale', _ltrDirection: 'LTR', _rtlDirection: 'RTL'};

  String selectedTextDirection = _basedOnLocale;

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
        height: MediaQuery.of(context).size.height,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Row(children: [
                const Icon(Icons.align_horizontal_left, size: 35),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Text Direction', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.left,
                      textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                )
              ])),
          Card(
              child: Column(
                  children: [_getMenuItem(_basedOnLocale), _getMenuItem(_ltrDirection), _getMenuItem(_rtlDirection)])),
          Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                WidgetUtils.getRoundedButton(
                    context: context,
                    buttonText: 'Set Text Direction',
                    iconData: Icons.align_horizontal_left,
                    onTapFunction: () {})
              ]))
        ]));
  }

  RadioListTile<String> _getMenuItem(final String value) {
    return RadioListTile<String>(
        value: value,
        groupValue: selectedTextDirection,
        onChanged: (newVal) {
          setState(() {
            selectedTextDirection = newVal!;
          });
        },
        title: Text(_textDirection[value]!, style: Theme.of(context).textTheme.titleLarge,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }
}
