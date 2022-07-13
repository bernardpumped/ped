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

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/user-interface/about/screen/about_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/about/screen/about_screen.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/edit_fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/fuel_station_details_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/utils/firebase_service.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/fuel_station_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/favourite/favourite_stations_screen.dart';
import 'package:pumped_end_device/user-interface/help/screen/help_screen.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/nearby/nearby_stations_screen.dart';
import 'package:pumped_end_device/user-interface/send-feedback/screens/send_feedback_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/cleanup_local_cache_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/customize_search_settings_screen.dart';
import 'package:pumped_end_device/user-interface/settings/screen/settings_screen.dart';
import 'package:pumped_end_device/user-interface/splash/screen/splash_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/splash/screen/splash_screen.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/update_history_details_screen.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/update_history_screen.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar_color_scheme.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:pumped_end_device/util/platform_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/local/location/geo_location_wrapper.dart';
import 'firebase_options.dart';

GetIt getIt = GetIt.instance;
// Set this variable to false when in release mode.
bool enrichOffers = true;
const appVersion = "7";
const getLocationWrapperInstanceName = 'geoLocationWrapper';
const platformWrapperInstanceName = 'platformWrapper';
const locationDataSourceInstanceName = 'locationDataSource';
const underMaintenanceServiceName = 'underMaintenanceService';

const firebaseServiceInstanceName = 'firebaseService';
const appBarColorSchemeName = 'appBarColorScheme';
const splashScreenColorSchemeName = 'splashScreenColorScheme';
const navDrawerColorSchemeName = 'navDrawerColorScheme';
const fsScreenColorSchemeName = 'fsScreenColorScheme';
const fsCardColorSchemeName = 'fsCardColorScheme';
const aboutScreenColorSchemeName = 'aboutScreenColorScheme';
const fsDetailsScreenColorSchemeName = 'fsDetailsScreenColorScheme';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  runApp(const PumpedApp());
}

class PumpedApp extends StatelessWidget {
  static const _tag = 'PumpedApp';
  const PumpedApp({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    _deviceInfo();
    _registerBeansWithGetIt();
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSwatch(accentColor: Colors.indigoAccent),
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'SF-Pro-Display'));
    _registerThemes(themeData);
    return MaterialApp(debugShowCheckedModeBanner: false, theme: themeData, home: const SplashScreen(), routes: {
      NearbyStationsScreen.routeName: (context) => const NearbyStationsScreen(),
      FavouriteStationsScreen.routeName: (context) => const FavouriteStationsScreen(),
      AboutScreen.routeName: (context) => AboutScreen(),
      SettingsScreen.routeName: (context) => const SettingsScreen(),
      FuelStationDetailsScreen.routeName: (context) => const FuelStationDetailsScreen(),
      CustomizeSearchSettingsScreen.routeName: (context) => const CustomizeSearchSettingsScreen(),
      CleanupLocalCacheScreen.routeName: (context) => const CleanupLocalCacheScreen(),
      EditFuelStationDetailsScreen.routeName: (context) => const EditFuelStationDetailsScreen(),
      UpdateHistoryScreen.routeName: (context) => const UpdateHistoryScreen(),
      UpdateHistoryDetailsScreen.routeName: (context) => const UpdateHistoryDetailsScreen(),
      SendFeedbackScreen.routeName: (context) => const SendFeedbackScreen(),
      HelpScreen.routeName: (context) => const HelpScreen()
    });
  }

  void _deviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();
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

    if (!getIt.isRegistered<PlatformWrapper>(instanceName: platformWrapperInstanceName)) {
      LogUtil.debug(_tag, 'Registering instance of $platformWrapperInstanceName');
      getIt.registerSingleton<PlatformWrapper>(PlatformWrapper(), instanceName: platformWrapperInstanceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $platformWrapperInstanceName is already registered');
    }

    if (!getIt.isRegistered<LocationDataSource>(instanceName: locationDataSourceInstanceName)) {
      LogUtil.debug(_tag, 'Registering instance of $locationDataSourceInstanceName');
      getIt.registerSingleton(
          LocationDataSource(getIt.get<GeoLocationWrapper>(instanceName: getLocationWrapperInstanceName),
              getIt.get<PlatformWrapper>(instanceName: platformWrapperInstanceName)),
          instanceName: locationDataSourceInstanceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $platformWrapperInstanceName is already registered');
    }

    if (!getIt.isRegistered<FirebaseService>(instanceName: firebaseServiceInstanceName)) {
      LogUtil.debug(_tag, 'Registering instance of $firebaseServiceInstanceName');
      getIt.registerSingleton<FirebaseService>(FirebaseService(), instanceName: firebaseServiceInstanceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $firebaseServiceInstanceName is already registered');
    }

    if (!getIt.isRegistered<UnderMaintenanceService>(instanceName: underMaintenanceServiceName)) {
      LogUtil.debug(_tag, 'Registering instance of $underMaintenanceServiceName');
      getIt.registerSingleton<UnderMaintenanceService>(UnderMaintenanceService.instance, instanceName: underMaintenanceServiceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $underMaintenanceServiceName is already registered');
    }
  }

  void _registerThemes(final ThemeData themeData) {
    if (!getIt.isRegistered<AboutScreenColorScheme>(instanceName: aboutScreenColorSchemeName)) {
      LogUtil.debug(_tag, 'Registering instance of $aboutScreenColorSchemeName');
      getIt.registerSingleton<AboutScreenColorScheme>(AboutScreenColorScheme(themeData),
          instanceName: aboutScreenColorSchemeName);
    } else {
      LogUtil.debug(_tag, 'Instance of $appBarColorSchemeName is already registered');
    }
    if (!getIt.isRegistered<PumpedAppBarColorScheme>(instanceName: appBarColorSchemeName)) {
      LogUtil.debug(_tag, 'Registering instance of $appBarColorSchemeName');
      getIt.registerSingleton<PumpedAppBarColorScheme>(PumpedAppBarColorScheme(themeData),
          instanceName: appBarColorSchemeName);
    } else {
      LogUtil.debug(_tag, 'Instance of $appBarColorSchemeName is already registered');
    }

    if (!getIt.isRegistered<SplashScreenColorScheme>(instanceName: splashScreenColorSchemeName)) {
      LogUtil.debug(_tag, 'Registering instance of $splashScreenColorSchemeName');
      getIt.registerSingleton<SplashScreenColorScheme>(SplashScreenColorScheme(themeData),
          instanceName: splashScreenColorSchemeName);
    } else {
      LogUtil.debug(_tag, 'Instance of $splashScreenColorSchemeName is already registered');
    }

    if (!getIt.isRegistered<NavDrawerColorScheme>(instanceName: navDrawerColorSchemeName)) {
      LogUtil.debug(_tag, 'Registering instance of $navDrawerColorSchemeName');
      getIt.registerSingleton<NavDrawerColorScheme>(NavDrawerColorScheme(themeData),
          instanceName: navDrawerColorSchemeName);
    } else {
      LogUtil.debug(_tag, 'Instance of $navDrawerColorSchemeName is already registered');
    }

    if (!getIt.isRegistered<FuelStationsScreenColorScheme>(instanceName: fsScreenColorSchemeName)) {
      LogUtil.debug(_tag, 'Registering instance of $fsScreenColorSchemeName');
      getIt.registerSingleton<FuelStationsScreenColorScheme>(FuelStationsScreenColorScheme(themeData),
          instanceName: fsScreenColorSchemeName);
    } else {
      LogUtil.debug(_tag, 'Instance of $fsScreenColorSchemeName is already registered');
    }

    if (!getIt.isRegistered<FuelStationCardColorScheme>(instanceName: fsCardColorSchemeName)) {
      LogUtil.debug(_tag, 'Registering instance of $fsCardColorSchemeName');
      getIt.registerSingleton<FuelStationCardColorScheme>(FuelStationCardColorScheme(themeData),
          instanceName: fsCardColorSchemeName);
    } else {
      LogUtil.debug(_tag, 'Instance of $fsCardColorSchemeName is already registered');
    }

    if (!getIt.isRegistered<FuelStationDetailsScreenColorScheme>(instanceName: fsDetailsScreenColorSchemeName)) {
      LogUtil.debug(_tag, 'Registering instance of $fsDetailsScreenColorSchemeName');
      getIt.registerSingleton<FuelStationDetailsScreenColorScheme>(FuelStationDetailsScreenColorScheme(themeData),
          instanceName: fsDetailsScreenColorSchemeName);
    } else {
      LogUtil.debug(_tag, 'Instance of $fsDetailsScreenColorSchemeName is already registered');
    }
  }
}
