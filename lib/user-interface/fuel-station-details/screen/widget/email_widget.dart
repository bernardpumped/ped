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
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailNotificationWidget extends StatelessWidget {
  static const _tag = 'EmailNotificationWidget';
  final String emailSubject;
  final String emailBody;
  final String sourceName;

  const EmailNotificationWidget(
      {Key? key, required this.emailSubject, required this.emailBody, required this.sourceName})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _sendEmail(() {
            WidgetUtils.showToastMessage(context, 'Cannot send email');
          });
        },
        child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child:
            Row(children: const [Icon(Icons.email_outlined, size: 24), SizedBox(width: 10), Text('Email')])));
  }

  void _sendEmail(final Function function) async {
    final List<String>? toEmailAddresses = _faToEmailAddressMap[sourceName];
    final String emailAddress =
        (toEmailAddresses == null || toEmailAddresses.isEmpty) ? 'bernard@pumpedfuel.com' : toEmailAddresses.join(',');
    final Uri emailUri =
        Uri.parse("mailto:$emailAddress?subject=$emailSubject&body=$emailBody&cc=bernard@pumpedfuel.com");
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        LogUtil.debug(_tag, 'Cannot send email $emailUri');
        function.call();
      }
    } on Exception catch (e) {
      LogUtil.debug(_tag, 'Exception invoking emailUrl $emailUri $e');
      function.call();
    }
  }

  static const _faToEmailAddressMap = {
    'nsw': ['support@nsw-email.com'],
    'qld': ['support@qld-email.com'],
    'sa':  ['support@sa-email.com'],
    'fwa': ['support@fwa-email.com'],
    'tas': ['support@tas-email.com'],
    'nt':  ['support@nt-email.com']
  };
}
