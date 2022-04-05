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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/location/geo_location_data.dart';
import 'package:pumped_end_device/data/local/location/get_location_result.dart';
import 'package:pumped_end_device/data/local/location/location_access_result_code.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
// import 'package:pumped_end_device/user-interface/pumped_base_tab_view.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/nearby/nearby-stations-screen.dart';
import 'package:pumped_end_device/user-interface/tabs/splash/screen/splash-screen-color-scheme.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _tag = 'SplashScreen';
  final SplashScreenColorScheme colorScheme =
      getIt.get<SplashScreenColorScheme>(instanceName: splashScreenColorSchemeName);

  bool _locationDetectionTriggered = false;
  bool _checkingPumpedAvailabilityTextVisible = false;
  bool _checkingPumpedAvailabilityIconVisible = false;
  bool _detectingLocationIconVisible = false;

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(final BuildContext context) {
    _getLocation();
    final double widthOfScaffold = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: colorScheme.backgroundColor,
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Wave-2.png"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                      image: AssetImage('assets/images/ic_splash.png'), width: 153, height: 133, fit: BoxFit.fill),
                  const SizedBox(height: 30),
                  Center(
                      child: Text('Your friendly \n neighbourhood fuel finder',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 22, color: colorScheme.appDescColor, fontWeight: FontWeight.w500))),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 150,
                      child: CupertinoTheme(
                          data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark),
                          child: const CupertinoActivityIndicator(radius: 20))),
                  const SizedBox(height: 100),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    AnimatedOpacity(
                        opacity: _locationDetectionTriggered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                            padding: EdgeInsets.only(left: widthOfScaffold / 2 - 135, right: 5),
                            child: Icon(const IconData(IconCodes.locationDetectedIconCode, fontFamily: 'MaterialIcons'),
                                color: colorScheme.notificationsColor))),
                    AnimatedOpacity(
                        opacity: _locationDetectionTriggered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                            width: 200,
                            child: Text('Detecting Location',
                                style: TextStyle(fontSize: 16, color: colorScheme.notificationsColor)))),
                    AnimatedOpacity(
                        opacity: _detectingLocationIconVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Icon(const IconData(IconCodes.doneIconCode, fontFamily: 'MaterialIcons'),
                            color: colorScheme.notificationsColor))
                  ]),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityIconVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                            padding: EdgeInsets.only(left: widthOfScaffold / 2 - 135, right: 7),
                            child: Icon(const IconData(IconCodes.findFuelStationIconCode, fontFamily: 'MaterialIcons'),
                                color: colorScheme.notificationsColor))),
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityIconVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                            width: 200,
                            child: Text('Fetching Fuel Stations',
                                style: TextStyle(fontSize: 16, color: colorScheme.notificationsColor)))),
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityTextVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Icon(const IconData(IconCodes.doneIconCode, fontFamily: 'MaterialIcons'),
                            color: colorScheme.notificationsColor))
                  ])
                ])));
  }

  void _getLocation() {
    if (!_locationDetectionTriggered) {
      setState(() {
        _locationDetectionTriggered = true;
        _getLocationFromOnDeviceLocationService();
      });
    }
  }

  void _getLocationFromOnDeviceLocationService() {
    final Future<GetLocationResult> getLocationDataFuture =
        getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName).getLocationData();
    getLocationDataFuture.then((locationResult) {
      final LocationInitResultCode code = locationResult.locationInitResultCode;
      switch (code) {
        case LocationInitResultCode.locationServiceDisabled:
          ScaffoldMessenger.of(context)
              .showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Service is disabled', 2, '', () {}));
          break;
        case LocationInitResultCode.permissionDenied:
          ScaffoldMessenger.of(context)
              .showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Service is disabled', 2, '', () {}));
          break;
        case LocationInitResultCode.notFound:
          WidgetUtils.buildSnackBar(context, 'Location Not Found', 2, '', () {});
          break;
        case LocationInitResultCode.failure:
          WidgetUtils.buildSnackBar(context, 'Location Failure', 2, '', () {});
          break;
        case LocationInitResultCode.success:
          _takeActionOnLocation(locationResult);
          break;
      }
    });
  }

  void _takeActionOnLocation(final GetLocationResult locationResult) {
    final Future<GeoLocationData>? locationDataFuture = locationResult.geoLocationData;
    if (locationDataFuture != null) {
      locationDataFuture.then((locationData) {
        LogUtil.debug(_tag, 'latitude : ${locationData.latitude}, longitude : ${locationData.longitude}');
        setState(() {
          _detectingLocationIconVisible = true;
        });
        // Below should actually get replaced with call to Firebase app availability
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            _checkingPumpedAvailabilityIconVisible = true;
          });
        });
        Future.delayed(const Duration(milliseconds: 3500), () {
          setState(() {
            _checkingPumpedAvailabilityTextVisible = true;
          });
        });
        Future.delayed(const Duration(milliseconds: 5000), () {
          setState(() {
            _checkingPumpedAvailabilityTextVisible = true;
          });
          Navigator.pushReplacementNamed(context, NearbyStationsScreen.routeName);
        });
      }, onError: (error) {
        LogUtil.error(_tag, 'Error happened on detecting location : $error');
      });
    }
  }
}
