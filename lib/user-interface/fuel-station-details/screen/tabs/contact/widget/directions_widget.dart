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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/location/geo_location_data.dart';
import 'package:pumped_end_device/data/local/location/get_location_result.dart';
import 'package:pumped_end_device/data/local/location/location_access_result_code.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

import 'feature_support.dart';

class DirectionsWidget extends StatefulWidget {
  static const _tag = 'DirectionsWidget';
  final double _dLat;
  final double _dLng;
  final LocationDataSource _locationDataSource;
  const DirectionsWidget(this._dLat, this._dLng, this._locationDataSource, {Key? key}) : super(key: key);

  @override
  State<DirectionsWidget> createState() => _DirectionsWidgetState();
}

class _DirectionsWidgetState extends State<DirectionsWidget> {
  @override
  Widget build(final BuildContext context) {
    return WidgetUtils.getRoundedButton(
        context: context,
        buttonText: 'Directions',
        iconData: Icons.directions_outlined,
        onTapFunction: () async {
          if (kIsWeb) {
            if (!FeatureSupport.webPlatform.contains(FeatureSupport.directionsFeature)) {
              LogUtil.debug(DirectionsWidget._tag, 'Web does not yet support ${FeatureSupport.directionsFeature}');
              return;
            }
          }
          if (!FeatureSupport.directions.contains(Platform.operatingSystem)) {
            LogUtil.debug(DirectionsWidget._tag,
                '${Platform.operatingSystem} Yocto/AGL does not yet support ${FeatureSupport.directionsFeature}');
            return;
          }
          final GetLocationResult locationResult = await widget._locationDataSource.getLocationData();
          final LocationInitResultCode resultCode = locationResult.locationInitResultCode;
          if (!mounted) return;
          switch (resultCode) {
            case LocationInitResultCode.locationServiceDisabled:
              WidgetUtils.buildSnackBar(context, 'Location Service is disabled', 2, '', () {});
              break;
            case LocationInitResultCode.permissionDenied:
              WidgetUtils.buildSnackBar(context, 'Location Permission denied', 2, '', () {});
              break;
            case LocationInitResultCode.notFound:
              WidgetUtils.buildSnackBar(context, 'Location Not Found', 2, '', () {});
              break;
            case LocationInitResultCode.failure:
              WidgetUtils.buildSnackBar(context, 'Location Failure', 2, '', () {});
              break;
            case LocationInitResultCode.success:
            case LocationInitResultCode.static:
              {
                final GeoLocationData? geoLocationData = await locationResult.geoLocationData;
                if (geoLocationData != null) {
                  final sLat = geoLocationData.latitude;
                  final sLng = geoLocationData.longitude;
                  _launchMaps(sLat, sLng, widget._dLat, widget._dLng, () {
                    WidgetUtils.showToastMessage(context, 'Cannot call phone', isErrorToast: true);
                  });
                } else {
                  if (!mounted) return;
                  WidgetUtils.buildSnackBar(context, 'Location Failure', 2, '', () {});
                }
              }
              break;
          }
        });
  }

  void _launchMaps(
      final double slat, final double slng, final double dlat, final double dlng, final Function function) {
    launchGoogleOrWaze(slat, slng, dlat, dlng, function);
  }

  void launchGoogleOrWaze(double slat, double slng, double dlat, double dlng, Function function) {
    final Future<bool> googleMapsLaunchedFuture = _launchGoogleMaps(slat, slng, dlat, dlng);
    googleMapsLaunchedFuture.then((googleMapsLaunched) {
      if (!googleMapsLaunched) {
        LogUtil.debug(DirectionsWidget._tag, 'Could not launch Google Maps');
        final Future<bool> wazeMapsLaunchedFuture = _launchWazeMaps(slat, slng, dlat, dlng);
        wazeMapsLaunchedFuture.then((wazeMapsLaunched) {
          if (!wazeMapsLaunched) {
            function.call();
            LogUtil.debug(DirectionsWidget._tag, 'No suitable Maps app launched on device');
          } else {
            LogUtil.debug(DirectionsWidget._tag, 'Waze launched successful');
          }
        });
      } else {
        LogUtil.debug(DirectionsWidget._tag, 'Google Maps launched successfully');
      }
    }, onError: (e) => function.call());
  }

  Future<bool> _launchGoogleMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/dir/?api=1&origin=$slat,$slng&destination=$dlat,$dlng");
    if (await canLaunchUrl(googleMapsUrl)) {
      bool launchSuccessful = await launchUrl(googleMapsUrl);
      return launchSuccessful;
    } else {
      return false;
    }
  }

  Future<bool> _launchWazeMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    // final String wazeMapsUrl = "https://waze.com/ul?ll=$dlat,$dlng&navigate=yes";
    final Uri wazeMapsUrl = Uri.parse("https://waze.com/ul?ll=$dlat,$dlng&navigate=yes");
    if (await canLaunchUrl(wazeMapsUrl)) {
      return await launchUrl(wazeMapsUrl);
    } else {
      return false;
    }
  }
}
