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
          Card(
              elevation: 2,
              color: Colors.indigo,
              // color: Color(0xFFF0EDFF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.indigo, width: 1)),
              child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Icon(Icons.phone_outlined, color: Colors.white))),
          const Text('Call', style: TextStyle(color: Colors.indigo, fontSize: 14, fontWeight: FontWeight.w500))
        ]),
        onTap: () async {
          _launchCaller(_phone, () {
            WidgetUtils.showToastMessage(context, 'Cannot call phone', Colors.indigo);
          });
        });
  }

  static void _launchCaller(final String phone, final Function function) async {
    if (kIsWeb) {
      if (!FeatureSupport.webPlatform.contains(FeatureSupport.callFeature)) {
        LogUtil.debug(_tag, 'Web does not yet support ${FeatureSupport.callFeature}');
        return;
      }
    }
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
