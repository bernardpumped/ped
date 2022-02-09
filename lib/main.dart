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
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/user-interface/pumped_base_tab_view.dart';
import 'package:pumped_end_device/user-interface/tabs/splash/screen/splash_screen.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:pumped_end_device/util/platform_wrapper.dart';

import 'data/local/location/geo_location_wrapper.dart';

GetIt getIt = GetIt.instance;
const appVersion = "23";
const getLocationWrapperInstanceName = 'geoLocationWrapper';
const platformWrapperInstanceName = 'platformWrapper';
const locationDataSourceInstanceName = 'locationDataSource';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PumpedApp());
}

class PumpedApp extends StatelessWidget {
  static const _tag = 'PumpedApp';
  const PumpedApp({Key key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    _deviceIngo();
    _registerBeansWithGetIt();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSwatch(accentColor: Colors.indigoAccent),
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'SF-Pro-Display')),
      home: const SplashScreen(),
      routes: {PumpedBaseTabView.routeName: (context) => const PumpedBaseTabView()},
    );
  }

  void _deviceIngo() async {
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
      getIt.registerSingleton(LocationDataSource(
          getIt.get<GeoLocationWrapper>(instanceName: getLocationWrapperInstanceName),
          getIt.get<PlatformWrapper>(instanceName: platformWrapperInstanceName)),
          instanceName: locationDataSourceInstanceName);
    } else {
      LogUtil.debug(_tag, 'Instance of $platformWrapperInstanceName is already registered');
    }
  }
}
