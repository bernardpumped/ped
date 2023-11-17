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

class TextDirectionMenuItemWidget extends StatefulWidget {
  const TextDirectionMenuItemWidget({Key? key}) : super(key: key);

  @override
  State<TextDirectionMenuItemWidget> createState() => _TextDirectionMenuItemWidgetState();
}

class _TextDirectionMenuItemWidgetState extends State<TextDirectionMenuItemWidget> {
  static const _basedOnLocale = 'BASED_ON_LOCALE';
  static const _ltrDirection = 'LTR';
  static const _rtlDirection = 'RTL';

  static const _textDirection = {_basedOnLocale: 'Based on Locale', _ltrDirection: 'LTR', _rtlDirection: 'RTL'};

  String selectedTextDirection = _basedOnLocale;

  @override
  Widget build(final BuildContext context) {
    return Card(
        child: ExpansionTile(
            title: Text("Text Direction - ${_textDirection[selectedTextDirection]}",
                style: Theme.of(context).textTheme.titleMedium, textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
            leading: const Icon(Icons.align_horizontal_left, size: 30),
            children: [_getMenuItem(_basedOnLocale), _getMenuItem(_ltrDirection), _getMenuItem(_rtlDirection)]));
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
        title: Text(_textDirection[value]!, style: Theme.of(context).textTheme.titleSmall,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }
}
