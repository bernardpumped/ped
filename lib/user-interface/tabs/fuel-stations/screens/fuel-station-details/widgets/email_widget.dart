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
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailNotificationWidget extends StatelessWidget {
  static const _tag = 'EmailNotificationWidget';
  final String emailSubject;
  final String emailBody;
  final String source;

  const EmailNotificationWidget({Key? key, required this.emailSubject, required this.emailBody, required this.source}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return WidgetUtils.getRoundedElevatedButton(
        child: Row(children: const [
          Text('Email', style: TextStyle(color: Colors.white)),
          SizedBox(width: 10),
          PumpedIcons.emailIconWhiteSize24
        ]),
        onPressed: () {
          _sendEmail(() {
            WidgetUtils.showToastMessage(context, 'Cannot send email', Theme.of(context).primaryColor);
          });
        },
        borderRadius: 10.0,
        backgroundColor: Theme.of(context).primaryColor);
  }

  void _sendEmail(final Function function) async {
    final List<String>? toEmailAddresses = _faToEmailAddressMap[source];
    final String emailAddress = (toEmailAddresses == null || toEmailAddresses.isEmpty) ? 'bernard@pumpedfuel.com' : toEmailAddresses.join(',');
    final String emailUrl = Uri.encodeFull("mailto:$emailAddress?subject=$emailSubject&body=$emailBody&cc:bernard@pumpedfuel.com");
    try {
      if (await canLaunch(emailUrl)) {
        await launch(emailUrl);
      } else {
        LogUtil.debug(_tag, 'Cannot send email $emailUrl');
        function.call();
      }
    } on Exception catch (e) {
      LogUtil.debug(_tag, 'Exception invoking emailUrl $emailUrl $e');
      function.call();
    }
  }

  static const _faToEmailAddressMap = {
    'nsw' : ['support@onegov.nsw.gov.au', 'fuelchecknews@customerservice.nsw.gov.au'],
    'qld' : ['fuelprices@dnrme.qld.gov.au', 'support@fuelpricesqld.com.au'],
    'sa' : ['fuelpricingscheme@sa.gov.au', 'support@safuelpricinginformation.com.au'],
    'fwa' : ['fuelwatch@dmirs.wa.gov.au', 'fuelwatch@commerce.wa.gov.au'],
    'tas' : ['support@onegov.nsw.gov.au', 'fuelchecknews@customerservice.nsw.gov.au'],
    'nt' : ['consumer@nt.gov.au']
  };
}
