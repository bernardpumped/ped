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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pumped_end_device/data/local/location/geo_location_data.dart';
import 'package:pumped_end_device/data/local/location/get_location_result.dart';
import 'package:pumped_end_device/data/local/location/location_access_result_code.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/nearby/nearby_stations_screen.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _tag = 'SplashScreen';
  final UnderMaintenanceService underMaintenanceService = getIt.get(instanceName: underMaintenanceServiceName);
  final linearProgressIndicator = const LinearProgressIndicator(color: Colors.white, backgroundColor: Colors.indigo);
  LocationInitResultCode? locationInitResultCode;
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
    _checkPumpedAvailability();
    final double widthOfScaffold = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.indigo,
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/Wave-2.png"), fit: BoxFit.cover)),
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
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                  locationInitResultCode == null || locationInitResultCode == LocationInitResultCode.success ?
                    Container(
                      width: 120,
                      margin: const EdgeInsets.only(top: 40),
                      child: linearProgressIndicator)
                  : Container(
                      width: 350,
                      margin: const EdgeInsets.only(top: 40),
                      alignment: Alignment.center,
                      child: Text(locationInitResultCode!.value,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                  const SizedBox(height: 100),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    AnimatedOpacity(
                        opacity: _locationDetectionTriggered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                            padding: EdgeInsets.only(left: widthOfScaffold / 2 - 135, right: 5),
                            child: const Icon(Icons.my_location, color: Colors.white))),
                    AnimatedOpacity(
                        opacity: _locationDetectionTriggered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                            width: 200,
                            child: Text('Detecting Location', style: const TextStyle(fontSize: 16, color: Colors.white),
                                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))),
                    AnimatedOpacity(
                        opacity: _detectingLocationIconVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(Icons.done, color: Colors.white))
                  ]),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityIconVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                            padding: EdgeInsets.only(left: widthOfScaffold / 2 - 135, right: 7),
                            child: const Icon(Icons.local_gas_station, color: Colors.white))),
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityIconVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                            width: 200,
                            child:
                                Text('Fetching Fuel Stations', style: const TextStyle(fontSize: 16, color: Colors.white),
                                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))),
                    AnimatedOpacity(
                        opacity: _checkingPumpedAvailabilityTextVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: const Icon(Icons.done, color: Colors.white))
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

  void _checkPumpedAvailability() async {
    underMaintenanceService.isUnderMaintenance().then((underMaintenanceR) {
      bool isUnderMaintenance = underMaintenanceR.isUnderMaintenance;
      if (isUnderMaintenance) {
        final String underMaintenanceMsg = underMaintenanceR.underMaintenanceMessage;
        ScaffoldMessenger.of(context)
            .showSnackBar(WidgetUtils.buildSnackBar(context, underMaintenanceMsg, 12 * 60 * 60 * 30, 'Exit', _exitMethod));
      } else {
        LogUtil.debug(_tag, 'Backend is not under maintenance.');
        _getLocation();
      }
    }).onError((error, stackTrace) {
      LogUtil.debug(_tag, 'Error happened in querying Firestore $error, still making attempt');
      _getLocation();
    });
  }

  _exitMethod() {
    if (Platform.isIOS) {
      // Apple does not like  this, as it is against their Human Interface Guidelines.
      exit(0);
    } else if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      // Not sure if SystemNavigator.pop(); would work for other platforms
    }
  }

  void _getLocationFromOnDeviceLocationService() {
    final Future<GetLocationResult> getLocationDataFuture =
        getIt.get<LocationDataSource>(instanceName: locationDataSourceInstanceName).getLocationData();
    getLocationDataFuture.then((locationResult) {
      setState(() {
        locationInitResultCode = locationResult.locationInitResultCode;
      });
      switch (locationInitResultCode!) {
        case LocationInitResultCode.locationServiceDisabled:
          ScaffoldMessenger.of(context)
              .showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Service is disabled. '
              'Access to your location is mandatory to display fuel stations nearby', 86400, 'Exit',
              _exitMethod, isDismissable: false));
          break;
        case LocationInitResultCode.permissionDenied:
          ScaffoldMessenger.of(context)
              .showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Permission is denied. '
              'Access to your location is mandatory to display fuel stations nearby', 86400, 'Exit',
              _exitMethod, isDismissable: false));
          break;
        case LocationInitResultCode.permissionDeniedForEver:
          ScaffoldMessenger.of(context)
              .showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Permission is denied forever. '
              'Access to your location is mandatory to display fuel stations nearby', 86400, 'Exit',
              _exitMethod, isDismissable: false));
          break;
        case LocationInitResultCode.notFound:
          ScaffoldMessenger.of(context)
              .showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Not Found. '
              'Access to your location is mandatory to display fuel stations nearby', 86400, 'Exit',
              _exitMethod, isDismissable: false));
          break;
        case LocationInitResultCode.failure:
          ScaffoldMessenger.of(context)
              .showSnackBar(WidgetUtils.buildSnackBar(context, 'Location Failure. '
              'Access to your location is mandatory to display fuel stations nearby', 86400, 'Exit',
              _exitMethod, isDismissable: false));
          break;
        case LocationInitResultCode.success:
          _takeActionOnLocationSuccess(locationResult);
          break;
      }
    });
  }

  void _takeActionOnLocationSuccess(final GetLocationResult locationResult) {
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
