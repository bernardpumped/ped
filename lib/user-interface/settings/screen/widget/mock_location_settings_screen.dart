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
import 'package:pumped_end_device/user-interface/settings/screen/widget/add_mock_location_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/delete_mock_location.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/pin_location_widget.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/log_util.dart';

class MockLocationSettingsScreen extends StatefulWidget {
  const MockLocationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<MockLocationSettingsScreen> createState() => _MockLocationSettingsScreenState();
}

class _MockLocationSettingsScreenState extends State<MockLocationSettingsScreen> {
  static const _tag = 'MockLocationSettingsScreen';

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  child: Row(children: [
                    const Icon(Icons.push_pin_outlined, size: 30),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('Mock Location of Device',
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                          style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.left)
                    )
                  ])),
              Card(
                  child:
                      Padding(padding: const EdgeInsets.all(15.0), child: AddMockLocationWidget(callback: _callback))),
              Card(child: DeleteMockLocation(callback: _callback)),
              Card(child: PinLocationWidget(callback: _callback))
            ])));
  }

  _callback() {
    setState(() {
      LogUtil.debug(_tag, 'Refreshing MockLocationSettingsScreen');
    });
  }
}
