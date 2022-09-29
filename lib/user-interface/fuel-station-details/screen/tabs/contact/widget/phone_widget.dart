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
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/feature_support.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneWidget extends StatelessWidget {
  static const _tag = 'PhoneWidget';
  final String _phone;
  const PhoneWidget(this._phone, {Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
        child: Column(children: [
          Material(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(15),
              // Cannot use Theme.of(context).primaryColor because in darkMode it does not work well
              color: Theme.of(context).textTheme.headline3!.color,
              shadowColor: Theme.of(context).textTheme.headline3!.color,
              child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(Icons.phone_outlined, color: Theme.of(context).backgroundColor))),
          Text('Call', style: Theme.of(context).textTheme.bodyText2)
        ]),
        onTap: () async {
          _launchCaller(_phone, () {
            WidgetUtils.showToastMessage(context, 'Cannot call phone');
          });
        });
  }

  static void _launchCaller(final String phone, final Function function) async {
    if (!FeatureSupport.call.contains(Platform.operatingSystem)) {
      LogUtil.debug(_tag, '${Platform.operatingSystem} does not yet support ${FeatureSupport.callFeature}');
      return;
    }
    final String phoneUrl = Uri.encodeFull("tel:$phone");
    try {
      if (await canLaunch(phoneUrl)) {
        await launch(phoneUrl);
      } else {
        LogUtil.debug(_tag, 'Could not launch $phoneUrl');
        function.call();
      }
    } on Exception catch (e) {
      LogUtil.debug(_tag, 'Exception invoking phoneUrl $phoneUrl $e');
      function.call();
    }
  }
}
