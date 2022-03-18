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

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pumped_end_device/data/local/location/geo_location_wrapper.dart';
import 'package:pumped_end_device/data/local/location/get_location_result.dart';
import 'package:pumped_end_device/data/local/location/location_access_result_code.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/util/platform_wrapper.dart';

import 'location_data_source_test.mocks.dart';


@GenerateMocks([PlatformWrapper, GeoLocationWrapper])
void main() {
  late LocationDataSource locationDataSource;
  late PlatformWrapper platformWrapper;
  late GeoLocationWrapper geoLocationWrapper;
  
  setUp(() {
    platformWrapper = MockPlatformWrapper();
    geoLocationWrapper = MockGeoLocationWrapper();
    when(platformWrapper.platformIsLinux()).thenReturn(false);
    when(platformWrapper.deviceIsBrowser()).thenReturn(false);
    locationDataSource = LocationDataSource(geoLocationWrapper, platformWrapper);
  });

  test('When Location Service is Disabled', () async {
    when(geoLocationWrapper.isLocationServiceEnabled()).thenAnswer((realInvocation) => Future.value(false));
    GetLocationResult result = await locationDataSource.getLocationData();
    expect(result.locationInitResultCode, equals(LocationInitResultCode.locationServiceDisabled));
    expect(result.geoLocationData, null);
    verify(platformWrapper.deviceIsBrowser()).called(1);
    verify(platformWrapper.platformIsLinux()).called(1);
    verify(geoLocationWrapper.isLocationServiceEnabled()).called(1);
    verifyNoMoreInteractions(platformWrapper);
    verifyNoMoreInteractions(geoLocationWrapper);
  });

  test('When Location Service is Enabled but permission is Denied', () async {
    when(geoLocationWrapper.isLocationServiceEnabled()).thenAnswer((_) => Future.value(true));
    when(geoLocationWrapper.checkPermission()).thenAnswer((realInvocation) => Future.value(LocationPermission.denied));
    when(geoLocationWrapper.requestPermission()).thenAnswer((realInvocation) => Future.value(LocationPermission.denied));
    GetLocationResult result = await locationDataSource.getLocationData();
    expect(result.locationInitResultCode, equals(LocationInitResultCode.permissionDenied));
    expect(result.geoLocationData, null);
    verify(platformWrapper.deviceIsBrowser()).called(1);
    verify(platformWrapper.platformIsLinux()).called(1);
    verify(geoLocationWrapper.isLocationServiceEnabled()).called(1);
    verify(geoLocationWrapper.checkPermission()).called(1);
    verify(geoLocationWrapper.requestPermission()).called(1);
    verifyNoMoreInteractions(platformWrapper);
    verifyNoMoreInteractions(geoLocationWrapper);
  });

  test('When Location Service is Enabled but permission is DeniedForever', () async {
    when(geoLocationWrapper.isLocationServiceEnabled()).thenAnswer((_) => Future.value(true));
    when(geoLocationWrapper.checkPermission()).thenAnswer((realInvocation) => Future.value(LocationPermission.deniedForever));
    GetLocationResult result = await locationDataSource.getLocationData();
    expect(result.locationInitResultCode, equals(LocationInitResultCode.permissionDenied));
    expect(result.geoLocationData, null);
    verify(platformWrapper.deviceIsBrowser()).called(1);
    verify(platformWrapper.platformIsLinux()).called(1);
    verify(geoLocationWrapper.isLocationServiceEnabled()).called(1);
    verify(geoLocationWrapper.checkPermission()).called(1);
    verifyNoMoreInteractions(platformWrapper);
    verifyNoMoreInteractions(geoLocationWrapper);
  });
}