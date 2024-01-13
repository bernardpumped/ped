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

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pumped_end_device/data/local/dao2/ui_settings_dao.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/data/local/model/ui_settings.dart';
import 'package:pumped_end_device/user-interface/about/screen/about_screen.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/edit_fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/utils/firebase_service.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/favourite/favourite_stations_screen.dart';
import 'package:pumped_end_device/user-interface/help/screen/help_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/nearby/nearby_stations_screen.dart';
import 'package:pumped_end_device/user-interface/send-feedback/screens/send_feedback_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/cleanup_local_cache_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/customize_search_settings_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/settings_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/widget/mock_location_settings_screen.dart';
import 'package:pumped_end_device/user-interface/splash/screen/splash_screen.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/update_history_details_screen.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/update_history_screen.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/util/app_theme.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pumped_end_device/util/text_scale.dart';
import 'package:pumped_end_device/util/theme_notifier.dart';
import 'package:pumped_end_device/util/ui_themes.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'data/local/location/geo_location_wrapper.dart';
import 'firebase_options.dart';

GetIt getIt = GetIt.instance;
bool initializeRateMyApp = true;
const appVersion = "49.UI_PRD";
const getLocationWrapperInstanceName = 'geoLocationWrapper';
const platformWrapperInstanceName = 'platformWrapper';
const locationDataSourceInstanceName = 'locationDataSource';
const underMaintenanceServiceName = 'underMaintenanceService';
const firebaseServiceInstanceName = 'firebaseService';
final RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'pedRateMyApp_',
    minDays: 0,
    minLaunches: 8,
    remindDays: 0,
    remindLaunches: 4,
    appStoreIdentifier: '',
    googlePlayIdentifier: 'com.voyagertech.pumped');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // } else {
  //   Firebase.app();
  // }
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
  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (BuildContext context) {
        return ThemeNotifier(themeMode, textScaleValue);
      },
      child: const PumpedApp()));
}

class PumpedApp extends StatelessWidget {
  static const _tag = 'PumpedApp';
  const PumpedApp({super.key});

  @override
  Widget build(final BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _deviceInfo();
    _registerBeansWithGetIt();
    LogUtil.debug("main", "Value of textScale found as ${themeNotifier.getTextScale()}");
    return PedTextScaler(
        initialScaleFactor: TextScalingFactor(scaleFactor: themeNotifier.getTextScale()),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme().lightTheme,
            darkTheme: AppTheme().darkTheme,
            themeMode: themeNotifier.getThemeMode(),
            home: const SplashScreen(),
            routes: {
              NearbyStationsScreen.routeName: (context) => const NearbyStationsScreen(),
              FavouriteStationsScreen.routeName: (context) => const FavouriteStationsScreen(),
              AboutScreen.routeName: (context) => const AboutScreen(),
              SettingsScreen.routeName: (context) => const SettingsScreen(),
              FuelStationDetailsScreen.routeName: (context) => const FuelStationDetailsScreen(),
              CustomizeSearchSettingsScreen.routeName: (context) => const CustomizeSearchSettingsScreen(),
              MockLocationSettingsScreen.routeName: (context) => const MockLocationSettingsScreen(),
              CleanupLocalCacheScreen.routeName: (context) => const CleanupLocalCacheScreen(),
              EditFuelStationDetailsScreen.routeName: (context) => const EditFuelStationDetailsScreen(),
              UpdateHistoryScreen.routeName: (context) => const UpdateHistoryScreen(),
              UpdateHistoryDetailsScreen.routeName: (context) => const UpdateHistoryDetailsScreen(),
              SendFeedbackScreen.routeName: (context) => const SendFeedbackScreen(),
              HelpScreen.routeName: (context) => const HelpScreen()
            }));
  }

  void _deviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.data;
    LogUtil.debug(_tag, map.toString());
    /*
      OUTPUT OF ABOVE IS
      {name: iPhone 13, model: iPhone, systemName: iOS, utsname: {release: 21.3.0,
      version: Darwin Kernel Version 21.3.0: Wed Jan  5 21:37:58 PST 2022; root:xnu-8019.80.24~20/RELEASE_ARM64_T8101,
      machine: arm64, sysname: Darwin, nodename: MacBook-Pro.local}
     */
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

    if (!getIt.isRegistered<FirebaseService>(instanceName: firebaseServiceInstanceName)) {
      LogUtil.debug(_tag, 'Registering instance of $firebaseServiceInstanceName');
      getIt.registerSingleton<FirebaseService>(FirebaseService(), instanceName: firebaseServiceInstanceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $firebaseServiceInstanceName is already registered');
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
