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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationWidget extends StatelessWidget {
  static const _tag = 'NotificationWidget';
  final FuelStation fuelStation;

  const NotificationWidget({Key? key, required this.fuelStation}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return WidgetUtils.getRoundedElevatedButton(
        child: Row(children: const [
          Icon(Icons.email_outlined, size: 24, color: Colors.white),
          SizedBox(width: 10),
          Text('Notify', style: TextStyle(color: Colors.white))
        ]),
        onPressed: () {
          _sendNotification(() {
            WidgetUtils.showToastMessage(context, 'Cannot send notification', Colors.indigo);
          });
        },
        borderRadius: 10.0,
        backgroundColor: Colors.indigo);
  }

  void _sendNotification(final Function function) async {
    final String notificationUrl = _getNotificationUrl();
    try {
      if (await canLaunchUrlString(notificationUrl)) {
        await canLaunchUrlString(notificationUrl);
      } else {
        LogUtil.debug(_tag, 'Cannot send email $notificationUrl');
        function.call();
      }
    } on Exception catch (e) {
      LogUtil.debug(_tag, 'Exception invoking notificationUrl $notificationUrl $e');
      function.call();
    }
  }

  String _getNotificationUrl() {
    return Uri.encodeFull("https://notify-fuel-prices.epw.qld.gov.au/?SiteName=${fuelStation.fuelStationName}"
        "&SiteAddress=${fuelStation.fuelStationAddress}&SiteID=${fuelStation.fuelAuthorityStationCode}&DataPublisher=Pumped");
  }
}
