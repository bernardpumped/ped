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
import 'package:pumped_end_device/user-interface/pumped_base_tab_view.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _TAG = 'SplashScreen';
  static const _locationIcon = const Icon(IconData(IconCodes.location_detected_icon_code, fontFamily: 'MaterialIcons'), color: Colors.white);
  static const _checkIcon = const Icon(IconData(IconCodes.done_icon_code, fontFamily: 'MaterialIcons'), color: Colors.white);
  static const _localGasIcon = const Icon(IconData(IconCodes.find_fuel_station_icon_code, fontFamily: 'MaterialIcons'), color: Colors.white);

  bool _locationDetectionTriggered = false;
  bool _checkingPumpedAvailabilityTextVisible = false;
  bool _checkingPumpedAvailabilityIconVisible = false;
  bool _detectingLocationIconVisible = false;

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(final BuildContext context) {
    _getLocation();
    final double widthOfScaffold = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
            alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage('assets/images/ic_splash.png'), width: 153, height: 133, fit: BoxFit.fill),
                  SizedBox(height: 30),
                  Center(
                      child: Text('Your friendly \n neighbourhood fuel finder',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500))),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 150,
                      child: CupertinoTheme(
                          data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark),
                          child: CupertinoActivityIndicator(radius: 20))),
                  SizedBox(height: 100),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    AnimatedOpacity(
                        opacity: _locationDetectionTriggered ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                            padding: EdgeInsets.only(left: widthOfScaffold / 2 - 135, right: 5), child: _locationIcon)),
                    AnimatedOpacity(
                        opacity: _locationDetectionTriggered ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                            width: 200,
                            child: Text('Detecting Location', style: TextStyle(fontSize: 16, color: Colors.white)))),
                    AnimatedOpacity(
                        opacity: _detectingLocationIconVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: _checkIcon)
                  ]),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityIconVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                            padding: EdgeInsets.only(left: widthOfScaffold / 2 - 135, right: 7), child: _localGasIcon)),
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityIconVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                            width: 200,
                            child:
                                Text('Fetching Fuel Stations', style: TextStyle(fontSize: 16, color: Colors.white)))),
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityTextVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: _checkIcon)
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
    final Future<GetLocationResult> getLocationDataFuture = getIt.get<LocationDataSource>().getLocationData();
    getLocationDataFuture.then((locationResult) {
      final LocationInitResultCode code = locationResult.locationInitResultCode;
      switch (code) {
        case LocationInitResultCode.LOCATION_SERVICE_DISABLED:
          ScaffoldMessenger.of(context).showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Service is disabled', 2, '', () {}));
          break;
        case LocationInitResultCode.PERMISSION_DENIED:
          ScaffoldMessenger.of(context).showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Service is disabled', 2, '', () {}));
          break;
        case LocationInitResultCode.NOT_FOUND:
          WidgetUtils.buildSnackBar(context, 'Location Not Found', 2, '', () {});
          break;
        case LocationInitResultCode.FAILURE:
          WidgetUtils.buildSnackBar(context, 'Location Failure', 2, '', () {});
          break;
        case LocationInitResultCode.SUCCESS:
          _takeActionOnLocation(locationResult);
          break;
      }
    });
  }

  void _takeActionOnLocation(final GetLocationResult locationResult) {
    final Future<GeoLocationData> locationDataFuture = locationResult.geoLocationData;
    locationDataFuture.then((locationData) {
      LogUtil.debug(_TAG, 'latitude : ${locationData.latitude}, longitude : ${locationData.longitude}');
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
        Navigator.pushReplacementNamed(context, PumpedBaseTabView.routeName);
      });
    }, onError: (error) {
      LogUtil.error(_TAG, 'Error happened on detecting location : $error');
    });
  }
}
