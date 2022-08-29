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
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_direction_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_locale_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_scaling_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/theme_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/server_version_widget.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'cleanup_local_cache_screen.dart';
import 'customize_search_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/ped/settings';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _tag = 'SettingsScreen';
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

  bool _displayCustomizeSearchMenu = false;
  bool _displayClearCachedMenuItem = false;

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
                  const TextScalingMenuItemWidget(),
                  const ThemeMenuItemWidget(),
                  const TextDirectionMenuItemWidget(),
                  const TextLocaleMenuItemWidget(),
                  _appVersionWidget(),
                  const ServerVersionWidget()
                ])));
  }

  _getSelectedSettingsDetails() {
    return _displayCustomizeSearchMenu
        ? const CustomizeSearchSettingsScreen()
        : (_displayClearCachedMenuItem ? const CleanupLocalCacheScreen() : _selectASettingsMsg());
  }

  Widget _selectASettingsMsg() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: const Center(
              child: Text('Select a Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal)))),
    );
  }

  Widget _customizeSearchMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _displayCustomizeSearchMenu = true;
            _displayClearCachedMenuItem = false;
          });
        },
        child: const Card(
            child: ListTile(
                contentPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: Icon(Icons.settings_outlined, size: 35),
                title: Text("Customize Search", style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                trailing: Icon(Icons.chevron_right, size: 24))));
  }

  Widget _clearCacheMenuItem() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _displayCustomizeSearchMenu = false;
            _displayClearCachedMenuItem = true;
          });
        },
        child: const Card(
            child: ListTile(
                contentPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: Icon(Icons.delete_outline, size: 35),
                title: Text("Clear local cache", style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                trailing: Icon(Icons.chevron_right, size: 24))));
  }

  Widget _appVersionWidget() {
    return const Padding(
        padding: EdgeInsets.only(top: 25),
        child: ListTile(
            title: Text("Pumped App Release - $appVersion",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center)));
  }
}
