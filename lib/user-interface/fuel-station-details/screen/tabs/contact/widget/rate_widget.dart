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
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/feature_support.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RateWidget extends StatelessWidget {
  static const _tag = 'RateWidget';

  final FuelStationAddress address;

  const RateWidget(this.address, {Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return WidgetUtils.getRoundedButton(
        context: context,
        buttonText: 'Rate',
        iconData: Icons.star_outline,
        onTapFunction: () async {
          if (kIsWeb) {
            if (!FeatureSupport.webPlatform.contains(FeatureSupport.ratingFeature)) {
              LogUtil.debug(_tag, 'Web does not yet support ${FeatureSupport.ratingFeature}');
              return;
            }
          }
          if (!FeatureSupport.rating.contains(Platform.operatingSystem)) {
            LogUtil.debug(_tag, '${Platform.operatingSystem} does not yet support ${FeatureSupport.ratingFeature}');
            return;
          }
          final bool launchRateAction = await _rateAction();
          if (!launchRateAction) {
            LogUtil.debug(_tag, 'Unable to launch Rating action');
          }
        });
  }

  Future<bool> _rateAction() async {
    String fsAddress = '${address.contactName} ${address.addressLine1}';
    if (address.locality != null) {
      fsAddress = '$fsAddress ${address.locality}';
    }
    if (address.region != null) {
      fsAddress = '$fsAddress ${address.region}';
    }
    if (address.state != null) {
      fsAddress = '$fsAddress ${address.state}';
    }
    final String googleRatingUrl = Uri.encodeFull('https://www.google.com/maps/search/?api=1&query=$fsAddress');

    if (await canLaunchUrlString(googleRatingUrl)) {
      return await launchUrlString(googleRatingUrl);
    } else {
      return false;
    }
  }
}
