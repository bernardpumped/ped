/*
 *     Copyright (c) 2021.
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
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneWidget extends StatelessWidget {
  static const _TAG = 'PhoneWidget';
  static const _buttonIconColor = Colors.white;
  static const _secondaryIconColor = FontsAndColors.pumpedSecondaryIconColor;
  final String _phone;

  PhoneWidget(this._phone);

  static const callIcon = const Icon(IconData(IconCodes.call_icon_code, fontFamily: 'MaterialIcons'), color: _buttonIconColor);

  @override
  Widget build(final BuildContext context) {
    return WidgetUtils.getActionIconCircular(
        callIcon, 'Call', _secondaryIconColor, _secondaryIconColor, onTap: () async {
      _launchCaller(_phone, () {
        WidgetUtils.showToastMessage(context, 'Cannot call phone', Theme.of(context).primaryColor);
      });
    });
  }

  static void _launchCaller(final String phone, final Function function) async {
    final String phoneUrl = Uri.encodeFull("tel:$phone");
    try {
      if (await canLaunch(phoneUrl)) {
        await launch(phoneUrl);
      } else {
        LogUtil.debug(_TAG, 'Could not launch $phoneUrl');
        function.call();
      }
    } on Exception catch (e) {
      LogUtil.debug(_TAG, 'Exception invoking phoneUrl $phoneUrl $e');
      function.call();
    }
  }
}
