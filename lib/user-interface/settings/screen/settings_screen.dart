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
import 'package:pumped_end_device/user-interface/settings/screen/widget/developer_options.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_direction_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_locale_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/text_scaling_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/theme_menu_item_widget.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/server_version_widget.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'cleanup_local_cache_screen.dart';
import 'customize_search_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/ped/settings';
  static const viewLabel = 'Settings';
  static const viewIcon = Icons.settings_outlined;
  static const viewSelectedIcon = Icons.settings;

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
        appBar: const PumpedAppBar(title: SettingsScreen.viewLabel, icon: SettingsScreen.viewSelectedIcon),
        drawer: const NavDrawerWidget(),
        body: SingleChildScrollView(
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
                      const DeveloperOptions(),
                      _appVersionWidget(),
                      const ServerVersionWidget()
                    ]))));
  }

  Widget _customizeSearchMenuItem() {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, CustomizeSearchSettingsScreen.routeName),
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.settings_outlined, size: 30),
                title: Text("Customize Search", style: Theme.of(context).textTheme.titleMedium,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _clearCacheMenuItem() {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, CleanupLocalCacheScreen.routeName),
        child: Card(
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                leading: const Icon(Icons.delete_outline, size: 30),
                title: Text("Clear local cache", style: Theme.of(context).textTheme.titleMedium,
                  textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                trailing: const Icon(Icons.chevron_right, size: 24))));
  }

  Widget _appVersionWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ListTile(
            title: Text("Pumped App Release - $appVersion",
                style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)));
  }
}
