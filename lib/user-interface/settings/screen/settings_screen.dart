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
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_direction_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_locale_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_scaling_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/theme_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/server_version_widget.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
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
    return Scaffold(
        appBar: const PumpedAppBar(),
        drawer: const NavDrawerWidget(),
        body: Container(
            color: const Color(0xFFF0EDFF),
            child: SingleChildScrollView(
                child: Container(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    color: const Color(0xFFF0EDFF),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                              child: Text('Settings',
                                  style: TextStyle(fontSize: 24, color: Colors.indigo, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center)),
                          _customizeSearchMenuItem(),
                          _clearCacheMenuItem(),
                          const TextScalingMenuItemWidget(),
                          const ThemeMenuItemWidget(),
                          const TextDirectionMenuItemWidget(),
                          const TextLocaleMenuItemWidget(),
                          _appVersionWidget(),
                          const ServerVersionWidget()
                        ])))));
  }

  Widget _customizeSearchMenuItem() {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, CustomizeSearchSettingsScreen.routeName),
        child: const Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: ListTile(
                contentPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: Icon(Icons.settings_outlined, color: Colors.indigo, size: 30),
                title: Text("Customize Search",
                    style: TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.chevron_right, color: Colors.indigo, size: 24))));
  }

  Widget _clearCacheMenuItem() {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, CleanupLocalCacheScreen.routeName),
        child: const Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: ListTile(
                contentPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: Icon(Icons.delete_outline, color: Colors.indigo, size: 30),
                title: Text("Clear local cache",
                    style: TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.w500)),
                trailing: Icon(Icons.chevron_right, color: Colors.indigo, size: 24))));
  }

  Widget _appVersionWidget() {
    return const Padding(
        padding: EdgeInsets.only(top: 25),
        child: ListTile(
            title: Text("Pumped App Release - $appVersion",
                style: TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center)));
  }
}
