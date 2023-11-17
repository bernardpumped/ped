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
import 'package:pumped_end_device/data/local/dao/ui_settings_dao.dart';
import 'package:pumped_end_device/data/local/model/ui_settings.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/log_util.dart';

class DeveloperOptions extends StatefulWidget {
  final Function() callback;
  const DeveloperOptions({super.key, required this.callback});

  @override
  State<DeveloperOptions> createState() => _DeveloperOptionsState();
}

class _DeveloperOptionsState extends State<DeveloperOptions> {
  static const _tag = 'DeveloperOptions';

  @override
  Widget build(final BuildContext context) {
    return Card(
        child: FutureBuilder(
            future: _getUiSettings(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                UiSettings? uiSettings = snapShot.data;
                uiSettings ??= UiSettings(developerOptions: false, devOptionsEnrichOffers: false);
                uiSettings.developerOptions ??= false;
                return _getTileForDeveloperOptions(uiSettings);
              } else if (snapShot.hasError) {
                LogUtil.debug(_tag, 'Error found while loading UiSettings ${snapShot.error}');
                return Text('Error Loading',
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.error));
              } else {
                return Text('Loading', style: Theme.of(context).textTheme.titleMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
              }
            }));
  }

  _getTileForDeveloperOptions(final UiSettings uiSettings) {
    return Column(children: [
      ListTile(
          contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          leading: const Icon(Icons.developer_mode_outlined, size: 30),
          title: Text("Developer Options", style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
          trailing: Switch(
              value: uiSettings.developerOptions!,
              onChanged: (bool value) {
                uiSettings.developerOptions = value;
                UiSettingsDao.instance.insertUiSettings(uiSettings);
                setState(() {});
              })),
      uiSettings.developerOptions! ? const Divider() : const SizedBox(height: 0),
      uiSettings.developerOptions!
          ? GestureDetector(
              onTap: () {
                widget.callback();
              },
              child: (ListTile(
                  contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  leading: const Icon(Icons.push_pin_outlined, size: 30),
                  title: Text("Mock Location of Device", style: Theme.of(context).textTheme.headlineMedium,
                      textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  trailing: const Icon(Icons.chevron_right, size: 24))),
            )
          : const SizedBox(height: 0),
      uiSettings.developerOptions! ? const Divider() : const SizedBox(height: 0),
      uiSettings.developerOptions! ? ListTile(
          contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          leading: const Icon(Icons.local_offer_outlined, size: 30),
          title: Text("Enrich Offers", style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
          trailing: Switch(
              value: uiSettings.devOptionsEnrichOffers!,
              onChanged: (bool value) {
                uiSettings.devOptionsEnrichOffers = value;
                UiSettingsDao.instance.insertUiSettings(uiSettings);
                setState(() {});
              })) : const SizedBox(height: 0),
    ]);
  }

  Future<UiSettings?>? _getUiSettings() {
    return UiSettingsDao.instance.getUiSettings();
  }
}
