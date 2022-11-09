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
import 'package:pumped_end_device/util/log_util.dart';

class DeveloperOptions extends StatefulWidget {
  final Function() callback;
  const DeveloperOptions({Key? key, required this.callback}) : super(key: key);

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
                UiSettings? uiSettings = snapShot.data as UiSettings?;
                uiSettings ??= UiSettings(developerOptions: false);
                uiSettings.developerOptions ??= false;
                return _getTileForDeveloperOptions(uiSettings);
              } else if (snapShot.hasError) {
                LogUtil.debug(_tag, 'Error found while loading UiSettings ${snapShot.error}');
                return Text('Error Loading',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).errorColor));
              } else {
                return Text('Loading', style: Theme.of(context).textTheme.subtitle1);
              }
            }));
  }

  _getTileForDeveloperOptions(final UiSettings uiSettings) {
    return Column(children: [
      ListTile(
          contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          leading: const Icon(Icons.developer_mode_outlined, size: 30),
          title: Text("Developer Options", style: Theme.of(context).textTheme.headline4),
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
                  title: Text("Mock Location of Device", style: Theme.of(context).textTheme.headline4),
                  trailing: const Icon(Icons.chevron_right, size: 24))),
            )
          : const SizedBox(height: 0)
    ]);
  }

  Future<UiSettings?>? _getUiSettings() {
    return UiSettingsDao.instance.getUiSettings();
  }
}