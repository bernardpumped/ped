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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:pumped_end_device/util/theme_notifier.dart';
import 'package:pumped_end_device/util/ui_themes.dart';

class ThemingScreen extends StatefulWidget {
  const ThemingScreen({Key? key}) : super(key: key);

  @override
  State<ThemingScreen> createState() => _ThemingScreenState();
}

class _ThemingScreenState extends State<ThemingScreen> {
  static const _tag = 'ThemingScreen';
  String? selectedTheme;
  bool _loadSelectedThemeFromDb = true;

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
                Expanded(
                  child: Text('Theme ', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.left,
                      textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                )
              ])),
          _getCard(),
          Padding(
              padding: const EdgeInsets.only(top: 20, right: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                WidgetUtils.getRoundedButton(
                    context: context,
                    buttonText: 'Set App Theme',
                    iconData: Icons.compare_outlined,
                    onTapFunction: () {
                      UiSettingsDao.instance.insertUiSettings(UiSettings(uiTheme: selectedTheme!)).whenComplete(() {
                        final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                        themeNotifier.setThemeMode(UiThemes.getThemeMode(selectedTheme!));
                        LogUtil.debug(_tag, 'Inserted instance $selectedTheme');
                        if (mounted) {
                          LogUtil.debug(_tag, 'Still mounted, calling setState');
                          setState(() {
                            _loadSelectedThemeFromDb = true;
                          });
                        }
                      });
                    })
              ]))
        ]));
  }

  Widget _getCard() {
    return _loadSelectedThemeFromDb ? _loadInitialThemeFromDb() : _loadSelectedThemeFromState();
  }

  Card _loadSelectedThemeFromState() {
    return Card(
        child: Column(children: [
      _getMenuItem(UiThemes.lightTheme),
      _getMenuItem(UiThemes.darkTheme),
      _getMenuItem(UiThemes.systemTheme)
    ]));
  }

  Card _loadInitialThemeFromDb() {
    return Card(
        child: FutureBuilder(
            future: getUiSettings(),
            builder: (context, snapShot) {
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
                return Column(children: [
                  _getMenuItem(UiThemes.lightTheme),
                  _getMenuItem(UiThemes.darkTheme),
                  _getMenuItem(UiThemes.systemTheme)
                ]);
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

  RadioListTile<String> _getMenuItem(final String themeValue) {
    return RadioListTile<String>(
        value: themeValue,
        selected: themeValue == selectedTheme,
        groupValue: selectedTheme,
        onChanged: (newVal) {
          LogUtil.debug(_tag, 'Selected Theme $newVal');
          setState(() {
            _loadSelectedThemeFromDb = false;
            selectedTheme = newVal;
          });
        },
        title: Text(UiThemes.themes[themeValue]!, style: Theme.of(context).textTheme.titleSmall,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }

  Future<UiSettings?>? getUiSettings() {
    return UiSettingsDao.instance.getUiSettings();
  }
}
