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
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

class RateWidget extends StatelessWidget {
  static const _tag = 'RateWidget';
  static const Color _buttonIconColor = Colors.white;
  static const Color _secondaryIconColor = FontsAndColors.pumpedSecondaryIconColor;

  final FuelStationAddress address;

  const RateWidget(this.address, {Key key}) : super(key: key);

  static const rateIcon = Icon(IconData(IconCodes.rateIconCode, fontFamily: 'MaterialIcons'), color: _buttonIconColor);

  @override
  Widget build(final BuildContext context) {
    // rate_review icon
    return WidgetUtils.getActionIconCircular(rateIcon, 'Rate', _secondaryIconColor, _secondaryIconColor, onTap: () async {
      final bool launchRateAction = await _rateAction();
      if (!launchRateAction) {
        LogUtil.debug(_tag, 'Unable to launch Rating action');
      }
    });
  }

  Future<bool> _rateAction() async {
    final String fsAddress = address.contactName +
        ' ' +
        address.addressLine1 +
        ' ' +
        address.locality +
        ' ' +
        address.region +
        ' ' +
        address.state;
    final String googleRatingUrl = Uri.encodeFull('https://www.google.com/maps/search/?api=1&query=$fsAddress');
    if (Platform.isIOS) {
      if (await canLaunch(googleRatingUrl)) {
        LogUtil.debug(_tag, 'Attempting native launch of Google Maps/rate url');
        bool nativeAppLaunchSucceeded = false;
        nativeAppLaunchSucceeded = await launch(
          googleRatingUrl,
          forceSafariVC: false,
          universalLinksOnly: true,
        );
        LogUtil.debug(_tag, 'Native launch of Google Maps/rate successful $nativeAppLaunchSucceeded');
        bool nonNativeAppLaunchSucceeded = false;
        if (!nativeAppLaunchSucceeded) {
          LogUtil.debug(_tag, 'Attempting non-native launch of Google Maps/rate successful');
          nonNativeAppLaunchSucceeded = await launch(
            googleRatingUrl,
            forceSafariVC: true,
          );
          LogUtil.debug(_tag, 'Non-Native launch of Google Maps/rate successful $nativeAppLaunchSucceeded');
        }
        return nativeAppLaunchSucceeded || nonNativeAppLaunchSucceeded;
      } else {
        LogUtil.debug(_tag, 'Could not launch $googleRatingUrl');
        return false;
      }
    } else {
      if (await canLaunch(googleRatingUrl)) {
        return await launch(googleRatingUrl);
      } else {
        return false;
      }
    }
  }
}
