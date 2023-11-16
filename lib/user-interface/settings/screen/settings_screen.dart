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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/ped_base_page_view.dart';
import 'package:pumped_end_device/user-interface/settings/screen/locale_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/text_direction_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/text_scaling_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/theming_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/developer_options.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/mock_location_settings_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/server_version_widget.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'cleanup_local_cache_screen.dart';
import 'customize_search_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _tag = 'SettingsScreen';
  SettingsMenu? _selectedSettings;

  final UnderMaintenanceService _underMaintenanceService =
      getIt.get<UnderMaintenanceService>(instanceName: underMaintenanceServiceName);

  @override
  void initState() {
    super.initState();
    _underMaintenanceService.registerSubscription(_tag, context, (event, context) {
      if (!mounted) return;
      WidgetUtils.showPumpedUnavailabilityMessage(event, context);
      LogUtil.debug(_tag, '${event.data}');
    });
  }

  @override
  void dispose() {
    _underMaintenanceService.cancelSubscription(_tag);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(body: SafeArea(child: _settingsScreenBody()));
  }

  _settingsScreenBody() {
    return SizedBox(
        width: MediaQuery.of(context).size.width - drawerWidth,
        child: Row(children: [
          Expanded(flex: 2, child: _settingsScreen()),
          Expanded(flex: 3, child: _getSelectedSettingsDetails())
        ]));
  }

  _settingsScreen() {
    return SingleChildScrollView(
        child: Container(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _customizeSearchMenuItem(),
                  _clearCacheMenuItem(),
                  _textScalingMenuItem(),
                  _themingMenuItem(),
                  _textDirectionMenuItem(),
                  _localeMenuItem(),
                  DeveloperOptions(callback: _callback),
                  _appVersionWidget(),
                  const ServerVersionWidget()
                ])));
  }

  _getSelectedSettingsDetails() {
    if (_selectedSettings == null) {
      return _selectASettingsMsg();
    } else {
      switch (_selectedSettings!) {
        case SettingsMenu.customizeSearch:
          return const CustomizeSearchSettingsScreen();
        case SettingsMenu.clearLocalCache:
          return const CleanupLocalCacheScreen();
        case SettingsMenu.textScaling:
          return const TextScalingScreen();
        case SettingsMenu.theming:
          return const ThemingScreen();
        case SettingsMenu.textDirection:
          return const TextDirectionScreen();
        case SettingsMenu.locale:
          return const LocaleScreen();
        case SettingsMenu.mockLocation:
          return const MockLocationSettingsScreen();
      }
    }
  }

  _callback() {
    setState(() {
      _selectedSettings = SettingsMenu.mockLocation;
    });
  }

  Widget _selectASettingsMsg() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('Select a Settings', style: Theme.of(context).textTheme.displayMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))),
    );
  }

  Widget _customizeSearchMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedSettings = SettingsMenu.customizeSearch;
          });
        },
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.settings_outlined, size: 35),
                title: Text("Customize Search", style: Theme.of(context).textTheme.headlineMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _textScalingMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedSettings = SettingsMenu.textScaling;
          });
        },
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.linear_scale_rounded, size: 35),
                title: Text("Text Scaling", style: Theme.of(context).textTheme.headlineMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _themingMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedSettings = SettingsMenu.theming;
          });
        },
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.compare_outlined, size: 35),
                title: Text("Theming", style: Theme.of(context).textTheme.headlineMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _clearCacheMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedSettings = SettingsMenu.clearLocalCache;
          });
        },
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.delete_outline, size: 35),
                title: Text("Clear local cache", style: Theme.of(context).textTheme.headlineMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _textDirectionMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedSettings = SettingsMenu.textDirection;
          });
        },
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.align_horizontal_left, size: 35),
                title: Text("Text Direction", style: Theme.of(context).textTheme.headlineMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _localeMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedSettings = SettingsMenu.locale;
          });
        },
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.language, size: 35),
                title: Text("Locale", style: Theme.of(context).textTheme.headlineMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _appVersionWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ListTile(
            title: Text("Pumped App Release - $appVersion",
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)));
  }
}

enum SettingsMenu { customizeSearch, clearLocalCache, textScaling, theming, textDirection, locale, mockLocation }
