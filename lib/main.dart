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
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pumped_end_device/data/local/dao2/ui_settings_dao.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/user-interface/ped_base_page_view.dart';
import 'package:pumped_end_device/user-interface/splash/screen/splash_screen.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/util/app_theme.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:pumped_end_device/util/text_scale.dart';
import 'package:pumped_end_device/util/theme_notifier.dart';
import 'package:pumped_end_device/util/ui_themes.dart';

import 'data/local/location/geo_location_wrapper.dart';
import 'data/local/model/ui_settings.dart';

GetIt getIt = GetIt.instance;
// Set this variable to false when in release mode.
bool enrichOffers = true;
const appVersion = "38.IVI_PRD";
const getLocationWrapperInstanceName = 'geoLocationWrapper';
const locationDataSourceInstanceName = 'locationDataSource';
const underMaintenanceServiceName = 'underMaintenanceService';

const firebaseServiceInstanceName = 'firebaseService';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UiSettings? uiSettings = await UiSettingsDao.instance.getUiSettings();
  ThemeMode themeMode;
  if (uiSettings.uiTheme != null) {
    themeMode = UiThemes.getThemeMode(uiSettings.uiTheme!);
  } else {
    themeMode = ThemeMode.light;
  }

  double textScaleValue;
  if (uiSettings.textScale != null) {
    textScaleValue = TextScale.getTextScaleValue(uiSettings.textScale!) as double;
  } else {
    textScaleValue = TextScale.systemTextScaleValue;
  }
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) {
          return ThemeNotifier(themeMode, textScaleValue);
        },
        child: const PumpedApp()),
  );
}

class PumpedApp extends StatelessWidget {
  static const _tag = 'PumpedApp';
  const PumpedApp({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _registerBeansWithGetIt();
    LogUtil.debug("main", "Value of textScale found as ${themeNotifier.getTextScale()}");
    return TextScaler(
      initialScaleFactor: TextScalingFactor(scaleFactor: themeNotifier.getTextScale()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme().lightTheme,
          darkTheme: AppTheme().darkTheme,
          themeMode: themeNotifier.getThemeMode(),
          home: const SplashScreen(),
          routes: {PedBasePageView.routeName: (context) => const PedBasePageView()}),
    );
  }

  void _registerBeansWithGetIt() {
    if (!getIt.isRegistered<GeoLocationWrapper>(instanceName: getLocationWrapperInstanceName)) {
      LogUtil.debug(_tag, 'Registering instance of $getLocationWrapperInstanceName');
      getIt.registerSingleton<GeoLocationWrapper>(GeoLocationWrapper(), instanceName: getLocationWrapperInstanceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $getLocationWrapperInstanceName is already registered');
    }

    if (!getIt.isRegistered<LocationDataSource>(instanceName: locationDataSourceInstanceName)) {
      LogUtil.debug(_tag, 'Registering instance of $locationDataSourceInstanceName');
      getIt.registerSingleton(
          LocationDataSource(getIt.get<GeoLocationWrapper>(instanceName: getLocationWrapperInstanceName)),
          instanceName: locationDataSourceInstanceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $locationDataSourceInstanceName is already registered');
    }

    if (!getIt.isRegistered<UnderMaintenanceService>(instanceName: underMaintenanceServiceName)) {
      LogUtil.debug(_tag, 'Registering instance of $underMaintenanceServiceName');
      getIt.registerSingleton<UnderMaintenanceService>(UnderMaintenanceService.instance,
          instanceName: underMaintenanceServiceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $underMaintenanceServiceName is already registered');
    }
  }
}
