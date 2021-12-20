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

import 'package:geolocator/geolocator.dart';

class GeoLocationWrapper {

  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition();
  }

  Stream<Position> getPositionStream(final int intervalInMillis, final double distance) {
    return Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        distanceFilter: distance.toInt(),
        intervalDuration: Duration(milliseconds: intervalInMillis));
  }

  double distanceBetween(final double startLatitude, final double startLongitude,
      final double endLatitude, final double endLongitude) {
    double distanceBetween =  Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceBetween < 0 ? distanceBetween * -1 : distanceBetween;
  }
}