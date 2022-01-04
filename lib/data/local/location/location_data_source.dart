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

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pumped_end_device/data/local/location/geo_location_wrapper.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/places.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:pumped_end_device/util/platform_wrapper.dart';

import 'geo_location_data.dart';
import 'get_location_result.dart';
import 'location_access_result_code.dart';
import 'location_service_subscription.dart';

class LocationDataSource {
  static const _TAG = "LocationDataSource";
  GeoLocationWrapper _geoLocationWrapper;
  PlatformWrapper _platformWrapper;

  LocationDataSource(this._geoLocationWrapper, this._platformWrapper);

  Future<GetLocationResult> getLocationData({String thread = 'default'}) async {
    if (!_platformWrapper.deviceIsBrowser() && _platformWrapper.platformIsLinux()) {
      return Future.value(GetLocationResult(LocationInitResultCode.SUCCESS,
          Future.value(GeoLocationData(
            latitude: Places.FISHBURNER_SYDNEY.latitude,
            longitude: Places.FISHBURNER_SYDNEY.longitude,
            altitude: 0,
          ))));
    }
    LogUtil.debug(_TAG, "Checking Location Service Enabled");
    bool serviceEnabled = await _geoLocationWrapper.isLocationServiceEnabled();
    LogUtil.debug(_TAG, "Location Service is Enabled ? ${serviceEnabled}");
    if (!serviceEnabled) {
      return Future.value(GetLocationResult(LocationInitResultCode.LOCATION_SERVICE_DISABLED, null));
    }

    LocationPermission permission = await _geoLocationWrapper.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocationWrapper.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.value(GetLocationResult(LocationInitResultCode.PERMISSION_DENIED, null));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.value(GetLocationResult(LocationInitResultCode.PERMISSION_DENIED, null));
    }

    try {
      final Position position = await _geoLocationWrapper.getCurrentPosition();
      if (position == null) {
        return Future.value(GetLocationResult(LocationInitResultCode.NOT_FOUND, null));
      }
      LogUtil.debug(_TAG, "Location found as : $position");
      if (kIsWeb) {
        LogUtil.debug(_TAG, 'Returning from kIsWeb');
        return Future.value(GetLocationResult(LocationInitResultCode.SUCCESS,
            Future.value(GeoLocationData(
              latitude: Places.FISHBURNER_SYDNEY.latitude,
              longitude: Places.FISHBURNER_SYDNEY.longitude,
              altitude: 0,
            ))));
      } else {
        LogUtil.debug(_TAG, 'Returning from !kIsWeb');
        return Future.value(GetLocationResult(LocationInitResultCode.SUCCESS,
            Future.value(GeoLocationData(
              latitude: position.latitude,
              longitude: position.longitude,
              altitude: position.altitude,
            ))));
      }
    } catch (e) {
      return Future.value(GetLocationResult(LocationInitResultCode.FAILURE, null));
    }
  }

  Future<LocationServiceSubscription> updateLocationSettings(final int interval,
      final double distance, final Function listenerFunction) async {
      final StreamSubscription<Position> positionSubscription = _geoLocationWrapper.getPositionStream(interval, distance)
        .listen((Position position) {
            print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
            if (kIsWeb) {
              listenerFunction(Places.FISHBURNER_SYDNEY.latitude, Places.FISHBURNER_SYDNEY.longitude);
            } else {
              listenerFunction(position.latitude, position.longitude);
            }
          });
      return new LocationServiceSubscription(positionSubscription);
  }
}