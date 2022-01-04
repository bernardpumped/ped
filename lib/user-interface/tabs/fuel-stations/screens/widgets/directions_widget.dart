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
import 'package:pumped_end_device/data/local/location/geo_location_data.dart';
import 'package:pumped_end_device/data/local/location/get_location_result.dart';
import 'package:pumped_end_device/data/local/location/location_access_result_code.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectionsWidget extends StatelessWidget {
  static const _TAG = 'DirectionsWidget';
  static const _expandedViewButtonIconColor = Colors.white;
  static const _expandedViewSecondaryIconColor = FontsAndColors.pumpedSecondaryIconColor;
  final double _dLat;
  final double _dLng;
  final LocationDataSource _locationDataSource;

  const DirectionsWidget(this._dLat, this._dLng, this._locationDataSource);

  static const directionsIcon = const Icon(IconData(IconCodes.directions_icon_code, fontFamily: 'MaterialIcons'), color: _expandedViewButtonIconColor);

  @override
  Widget build(final BuildContext context) {
    return WidgetUtils.getActionIconCircular(directionsIcon, 'Directions',
        _expandedViewSecondaryIconColor, _expandedViewSecondaryIconColor, onTap: () async {
          final GetLocationResult locationResult = await _locationDataSource.getLocationData();
      final LocationInitResultCode resultCode = locationResult.locationInitResultCode;
      switch (resultCode) {
        case LocationInitResultCode.LOCATION_SERVICE_DISABLED:
          WidgetUtils.buildSnackBar(context, 'Location Service is disabled', 2, '', () {});
          break;
        case LocationInitResultCode.PERMISSION_DENIED:
          WidgetUtils.buildSnackBar(context, 'Location Permission denied', 2, '', () {});
          break;
        case LocationInitResultCode.NOT_FOUND:
          WidgetUtils.buildSnackBar(context, 'Location Not Found', 2, '', () {});
          break;
        case LocationInitResultCode.FAILURE:
          WidgetUtils.buildSnackBar(context, 'Location Failure', 2, '', () {});
          break;
        case LocationInitResultCode.SUCCESS:
          {
            final GeoLocationData geoLocationData = await locationResult.geoLocationData;
            final sLat = geoLocationData.latitude;
            final sLng = geoLocationData.longitude;
            _launchMaps(sLat, sLng, _dLat, _dLng, () {
              WidgetUtils.showToastMessage(context, 'Cannot call phone', Theme.of(context).primaryColor);
            });
          }
          break;
      }
    });
  }

  void _launchMaps(
      final double slat, final double slng, final double dlat, final double dlng, final Function function) {
    if (Platform.isIOS) {
      final Future<bool> appleMapsLaunchedFuture = _launchAppleMaps(slat, slng, dlat, dlng);
      appleMapsLaunchedFuture.then((appleMapsLaunched) {
        if (!appleMapsLaunched) {
          LogUtil.debug(_TAG, 'Could not launch apple maps');
          launchGoogleOrWaze(slat, slng, dlat, dlng, function);
        } else {
          LogUtil.debug(_TAG, 'Apple Maps successfully launched');
        }
      }, onError: (e) => function.call());
    } else {
      launchGoogleOrWaze(slat, slng, dlat, dlng, function);
    }
  }

  void launchGoogleOrWaze(double slat, double slng, double dlat, double dlng, Function function) {
    final Future<bool> googleMapsLaunchedFuture = _launchGoogleMaps(slat, slng, dlat, dlng);
    googleMapsLaunchedFuture.then((googleMapsLaunched) {
      if (!googleMapsLaunched) {
        LogUtil.debug(_TAG, 'Could not launch Google Maps');
        final Future<bool> wazeMapsLaunchedFuture = _launchWazeMaps(slat, slng, dlat, dlng);
        wazeMapsLaunchedFuture.then((wazeMapsLaunched) {
          if (!wazeMapsLaunched) {
            function.call();
            LogUtil.debug(_TAG, 'No suitable Maps app launched on device');
          } else {
            LogUtil.debug(_TAG, 'Waze launched successful');
          }
        });
      } else {
        LogUtil.debug(_TAG, 'Google Maps launched successfully');
      }
    }, onError: (e) => function.call());
  }

  Future<bool> _launchGoogleMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$slat,$slng&destination=$dlat,$dlng";
    if (Platform.isIOS) {
      if (await canLaunch(googleMapsUrl)) {
        final bool nativeAppLaunchSucceeded = await launch(
          googleMapsUrl,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        bool nonNativeAppLaunchSucceeded = false;
        if (!nativeAppLaunchSucceeded) {
          nonNativeAppLaunchSucceeded = await launch(
            googleMapsUrl,
            forceSafariVC: true,
          );
        }
        return nativeAppLaunchSucceeded || nonNativeAppLaunchSucceeded;
      }
      return false;
    } else {
      if (await canLaunch(googleMapsUrl)) {
        bool launchSuccessful = await launch(googleMapsUrl);
        return launchSuccessful;
      } else {
        return false;
      }
    }
  }

  Future<bool> _launchAppleMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    if (!Platform.isIOS) return false;
    var urlAppleMaps = 'http://maps.apple.com/maps?saddr=$slat,$slng&daddr=$dlat,$dlng';
    if (await canLaunch(urlAppleMaps)) {
      final bool nativeAppLaunchSucceeded = await launch(
        urlAppleMaps,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      LogUtil.debug(_TAG, 'Native launch for apple map successful $nativeAppLaunchSucceeded');
      bool nonNativeAppLaunchSucceeded = false;
      if (!nativeAppLaunchSucceeded) {
        nonNativeAppLaunchSucceeded = await launch(
          urlAppleMaps,
          forceSafariVC: true,
        );
      }
      return nativeAppLaunchSucceeded || nonNativeAppLaunchSucceeded;
    } else {
      LogUtil.debug(_TAG, 'Could not launch $urlAppleMaps');
      return false;
    }
  }

  Future<bool> _launchWazeMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    final String wazeMapsUrl = "https://waze.com/ul?ll=$dlat,$dlng&navigate=yes";
    if (Platform.isIOS) {
      if (await canLaunch(wazeMapsUrl)) {
        final bool nativeAppLaunchSucceeded = await launch(
          wazeMapsUrl,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        bool nonNativeAppLaunchSucceeded = false;
        if (!nativeAppLaunchSucceeded) {
          nonNativeAppLaunchSucceeded = await launch(
            wazeMapsUrl,
            forceSafariVC: true,
          );
        }
        return nativeAppLaunchSucceeded || nonNativeAppLaunchSucceeded;
      }
      return false;
    } else {
      if (await canLaunch(wazeMapsUrl)) {
        bool launchSuccessful = await launch(wazeMapsUrl);
        return launchSuccessful;
      } else {
        return false;
      }
    }
  }
}
