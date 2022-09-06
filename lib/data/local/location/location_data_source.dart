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

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pumped_end_device/data/local/location/geo_location_wrapper.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/data/local/places.dart';
import 'package:pumped_end_device/util/log_util.dart';

import 'geo_location_data.dart';
import 'get_location_result.dart';
import 'location_access_result_code.dart';
import 'location_service_subscription.dart';

class LocationDataSource {
  static const _tag = "LocationDataSource";
  final GeoLocationWrapper _geoLocationWrapper;

  LocationDataSource(this._geoLocationWrapper);

  Future<GetLocationResult> getLocationData({String thread = 'default'}) async {
    // if (!_platformWrapper.deviceIsBrowser() && _platformWrapper.platformIsLinux()) {
    //   return Future.value(GetLocationResult(
    //       LocationInitResultCode.success,
    //       Future.value(GeoLocationData(
    //           latitude: Places.fishBurnerSydney.latitude, longitude: Places.fishBurnerSydney.longitude, altitude: 0))));
    // }
    LogUtil.debug(_tag, "Checking Location Service Enabled");
    bool serviceEnabled = await _geoLocationWrapper.isLocationServiceEnabled();
    LogUtil.debug(_tag, "Location Service is Enabled ? $serviceEnabled");
    if (!serviceEnabled) {
      return Future.value(GetLocationResult(LocationInitResultCode.locationServiceDisabled, null));
    }

    LocationPermission permission = await _geoLocationWrapper.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocationWrapper.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.value(GetLocationResult(LocationInitResultCode.permissionDenied, null));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.value(GetLocationResult(LocationInitResultCode.permissionDenied, null));
    }

    try {
      final Position position = await _geoLocationWrapper.getCurrentPosition();
      LogUtil.debug(_tag, "Location found as : $position");
      // final List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      // String? isoCountryCode;
      // if (placemarks.isNotEmpty) {
      //   isoCountryCode = placemarks[0].isoCountryCode;
      //   LogUtil.debug(_tag, 'CountryCode found is $isoCountryCode');
      // }
      if (kIsWeb || Platform.isLinux || Platform.isAndroid) {
        // LogUtil.debug(_tag, 'Overriding the location, as the current country is not AU/Australia');
        LogUtil.debug(_tag, 'Overriding the actual location with static one, as the Browser / Linux does not allow mocking the location');
        return Future.value(GetLocationResult(
            LocationInitResultCode.success,
            Future.value(GeoLocationData(
                latitude: Places.fishBurnerBrisbane.latitude,
                longitude: Places.fishBurnerBrisbane.longitude,
                altitude: 0))));
      } else {
        LogUtil.debug(_tag, 'Returning from !kIsWeb');
        return Future.value(GetLocationResult(
            LocationInitResultCode.success,
            Future.value(GeoLocationData(
                latitude: position.latitude, longitude: position.longitude, altitude: position.altitude))));
        // return Future.value(GetLocationResult(LocationInitResultCode.success,
        //     Future.value(GeoLocationData(
        //       latitude: Places.cairnsQld.latitude,
        //       longitude: Places.cairnsQld.longitude,
        //       altitude: 1,
        //     ))));
      }
    } catch (e) {
      return Future.value(GetLocationResult(LocationInitResultCode.failure, null));
    }
  }

  Future<LocationServiceSubscription> updateLocationSettings(
      final int interval, final double distance, final Function listenerFunction) async {
    final StreamSubscription<Position> positionSubscription =
        _geoLocationWrapper.getPositionStream(interval, distance).listen((Position position) {
      if (kIsWeb) {
        listenerFunction(Places.fishBurnerSydney.latitude, Places.fishBurnerSydney.longitude);
      } else {
        listenerFunction(position.latitude, position.longitude);
      }
    });
    return LocationServiceSubscription(positionSubscription);
  }
}
