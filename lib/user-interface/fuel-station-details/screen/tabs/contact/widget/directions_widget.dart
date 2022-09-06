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

class DirectionsWidget extends StatelessWidget {
  static const _tag = 'DirectionsWidget';
  final double _dLat;
  final double _dLng;
  final LocationDataSource _locationDataSource;
  const DirectionsWidget(this._dLat, this._dLng, this._locationDataSource, {Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final Color snackBarColor = Theme.of(context).dialogBackgroundColor;
    return GestureDetector(
        child: Column(children: [
          Card(
              elevation: 2,
              color: Colors.indigo,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.indigo, width: 1)),
              child: const Padding(
                  padding: EdgeInsets.all(14.0), child: Icon(Icons.directions_outlined, color: Colors.white))),
          const Text('Directions', style: TextStyle(color: Colors.indigo, fontSize: 14, fontWeight: FontWeight.w500))
        ]),
        onTap: () async {
          if (!FeatureSupport.directions.contains(Platform.operatingSystem)) {
            LogUtil.debug(_tag, '${Platform.operatingSystem} does not yet support ${FeatureSupport.directionsFeature}');
            return;
          }
          final GetLocationResult locationResult = await _locationDataSource.getLocationData();
          final LocationInitResultCode resultCode = locationResult.locationInitResultCode;

          switch (resultCode) {
            case LocationInitResultCode.locationServiceDisabled:
              WidgetUtils.buildSnackBar2('Location Service is disabled', snackBarColor, 2, '', () {});
              break;
            case LocationInitResultCode.permissionDenied:
              WidgetUtils.buildSnackBar2('Location Permission denied', snackBarColor, 2, '', () {});
              break;
            case LocationInitResultCode.notFound:
              WidgetUtils.buildSnackBar2('Location Not Found', snackBarColor, 2, '', () {});
              break;
            case LocationInitResultCode.failure:
              WidgetUtils.buildSnackBar2('Location Failure', snackBarColor, 2, '', () {});
              break;
            case LocationInitResultCode.success:
              {
                final GeoLocationData? geoLocationData = await locationResult.geoLocationData;
                if (geoLocationData != null) {
                  final sLat = geoLocationData.latitude;
                  final sLng = geoLocationData.longitude;
                  _launchMaps(sLat, sLng, _dLat, _dLng, () {
                    WidgetUtils.showToastMessage(context, 'Cannot call phone', Colors.indigo);
                  });
                } else {
                  WidgetUtils.buildSnackBar2('Location Failure', snackBarColor, 2, '', () {});
                }
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
          LogUtil.debug(_tag, 'Could not launch apple maps');
          launchGoogleOrWaze(slat, slng, dlat, dlng, function);
        } else {
          LogUtil.debug(_tag, 'Apple Maps successfully launched');
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
        LogUtil.debug(_tag, 'Could not launch Google Maps');
        final Future<bool> wazeMapsLaunchedFuture = _launchWazeMaps(slat, slng, dlat, dlng);
        wazeMapsLaunchedFuture.then((wazeMapsLaunched) {
          if (!wazeMapsLaunched) {
            function.call();
            LogUtil.debug(_tag, 'No suitable Maps app launched on device');
          } else {
            LogUtil.debug(_tag, 'Waze launched successful');
          }
        });
      } else {
        LogUtil.debug(_tag, 'Google Maps launched successfully');
      }
    }, onError: (e) => function.call());
  }

  Future<bool> _launchGoogleMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    final urlString = "https://www.google.com/maps/dir/?api=1&origin=$slat,$slng&destination=$dlat,$dlng";
    final Uri googleMapsUrl = Uri.parse(urlString);
    if (Platform.isIOS) {
      if (await canLaunchUrl(googleMapsUrl)) {
        final bool nativeAppLaunchSucceeded = await launchUrl(
          googleMapsUrl, mode: LaunchMode.externalApplication
          // forceSafariVC: false,
          // universalLinksOnly: true,
        );
        bool nonNativeAppLaunchSucceeded = false;
        if (!nativeAppLaunchSucceeded) {
          nonNativeAppLaunchSucceeded = await launchUrl(
              googleMapsUrl
            // forceSafariVC: true,
          );
        }
        return nativeAppLaunchSucceeded || nonNativeAppLaunchSucceeded;
      }
      return false;
    } else {
      if (await canLaunchUrl(googleMapsUrl)) {
        // launchUrl(url)
        bool launchSuccessful = await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        return launchSuccessful;
      } else {
        return false;
      }
    }
  }

  Future<bool> _launchAppleMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    if (!Platform.isIOS) return false;
    String urlString = 'http://maps.apple.com/maps?saddr=$slat,$slng&daddr=$dlat,$dlng';
    final Uri appleMapsUrl = Uri.parse(urlString);
    if (await canLaunchUrl(appleMapsUrl)) {
      LogUtil.debug(_tag, 'Attempting native launch of apple maps');
      final bool nativeAppLaunchSucceeded = await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication /*forceSafariVC: false, universalLinksOnly: true*/);
      LogUtil.debug(_tag, 'Native launch for apple map successful $nativeAppLaunchSucceeded');

      bool nonNativeAppLaunchSucceeded = false;
      if (!nativeAppLaunchSucceeded) {
        LogUtil.debug(_tag, 'Attempting non-native launch of apple maps');
        nonNativeAppLaunchSucceeded = await launchUrl(appleMapsUrl);
        LogUtil.debug(_tag, 'Non-Native launch for apple map successful $nonNativeAppLaunchSucceeded');
      }
      return nativeAppLaunchSucceeded || nonNativeAppLaunchSucceeded;
    } else {
      LogUtil.debug(_tag, 'Could not launch $urlString');
      return false;
    }
  }

  Future<bool> _launchWazeMaps(final double slat, final double slng, final double dlat, final double dlng) async {
    final String urlString = "https://waze.com/ul?ll=$dlat,$dlng&navigate=yes";
    Uri wazeMapUrl = Uri.parse(urlString);
    if (Platform.isIOS || Platform.isAndroid) {
      if (await canLaunchUrl(wazeMapUrl)) {
        final bool nativeAppLaunchSucceeded = await launchUrl(
          wazeMapUrl, mode: LaunchMode.externalApplication
        );
        bool nonNativeAppLaunchSucceeded = false;
        if (!nativeAppLaunchSucceeded) {
          nonNativeAppLaunchSucceeded = await launchUrl(wazeMapUrl);
        }
        return nativeAppLaunchSucceeded || nonNativeAppLaunchSucceeded;
      }
      return false;
    } else {
      if (await canLaunchUrl(wazeMapUrl)) {
        bool launchSuccessful = await launchUrl(wazeMapUrl);
        return launchSuccessful;
      } else {
        return false;
      }
    }
  }
}
