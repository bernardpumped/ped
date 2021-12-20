/*
 *     Copyright (c) 2021.
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
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/user-interface/pumped_base_tab_view.dart';
import 'package:pumped_end_device/user-interface/tabs/splash/screen/splash_screen.dart';
import 'package:pumped_end_device/util/platform_wrapper.dart';

import 'data/local/location/geo_location_wrapper.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PumpedApp());
}

class PumpedApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    
    getIt.registerSingleton<GeoLocationWrapper>(new GeoLocationWrapper());
    getIt.registerSingleton<PlatformWrapper>(new PlatformWrapper());
    getIt.registerSingleton(new LocationDataSource(
        getIt.get<GeoLocationWrapper>(), getIt.get<PlatformWrapper>()));
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSwatch(accentColor: Colors.indigoAccent),
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'SF-Pro-Display')),
      home: SplashScreen(),
      routes: {PumpedBaseTabView.routeName: (context) => PumpedBaseTabView()},
    );
  }
}
