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
import 'package:provider/provider.dart';
import 'package:pumped_end_device/data/local/dao/ui_settings_dao.dart';
import 'package:pumped_end_device/data/local/model/ui_settings.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:pumped_end_device/util/theme_notifier.dart';
import 'package:pumped_end_device/util/ui_themes.dart';

class ThemeMenuItemWidget extends StatefulWidget {
  const ThemeMenuItemWidget({Key? key}) : super(key: key);

  @override
  State<ThemeMenuItemWidget> createState() => _ThemeMenuItemWidgetState();
}

class _ThemeMenuItemWidgetState extends State<ThemeMenuItemWidget> {
  static const _tag = 'ThemeMenuItemWidget';

  @override
  Widget build(final BuildContext context) {
    return Card(
        child: FutureBuilder(
            future: getUiSettings(),
            builder: (context, snapShot) {
              String? selectedTheme;
              if (snapShot.hasData) {
                UiSettings? uiSettings = snapShot.data as UiSettings?;
                if (uiSettings != null) {
                  LogUtil.debug(_tag, 'Read UiSettings : ${uiSettings.uiTheme}');
                  if (uiSettings.uiTheme != null) {
                    selectedTheme = uiSettings.uiTheme;
                  } else {
                    // No theme was yet set in UiSettings
                    // setting the default values
                    selectedTheme = UiThemes.lightTheme;
                  }
                } else {
                  // Ui Settings is not set yet
                  // Creating instance now with default value
                  selectedTheme = UiThemes.lightTheme;
                }
                return _getExpansionTile(selectedTheme!);
              } else if (snapShot.hasError) {
                LogUtil.debug(_tag, 'Error found while loading UiSettings ${snapShot.error}');
                return Text('Error Loading',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).errorColor));
              } else {
                return Text('Loading', style: Theme.of(context).textTheme.subtitle1);
              }
            }));
  }

  _getExpansionTile(final String selectedTheme) {
    return ExpansionTile(
        title: Text("Theme - ${UiThemes.themes[selectedTheme]}", style: Theme.of(context).textTheme.subtitle1),
        leading: const Icon(Icons.compare_outlined, size: 30),
        children: [
          _getMenuItem(UiThemes.lightTheme, selectedTheme),
          _getMenuItem(UiThemes.darkTheme, selectedTheme),
          _getMenuItem(UiThemes.systemTheme, selectedTheme)
        ]);
  }

  RadioListTile<String> _getMenuItem(final String themeValue, final String selectedTheme) {
    return RadioListTile<String>(
        value: themeValue,
        selected: themeValue == selectedTheme,
        groupValue: selectedTheme,
        onChanged: (newVal) {
          LogUtil.debug(_tag, 'Selected Theme $newVal');
          UiSettingsDao.instance.insertUiSettings(UiSettings(uiTheme: newVal!)).whenComplete(() {
            final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
            themeNotifier.setThemeMode(UiThemes.getThemeMode(newVal));
            LogUtil.debug(_tag, 'Inserted instance $newVal');
            if (mounted) {
              LogUtil.debug(_tag, 'Still mounted, calling setState');
              setState(() {});
            }
          });
        },
        title: Text(UiThemes.themes[themeValue]!, style: Theme.of(context).textTheme.subtitle2));
  }

  Future<UiSettings?>? getUiSettings() {
    return UiSettingsDao.instance.getUiSettings();
  }
}
