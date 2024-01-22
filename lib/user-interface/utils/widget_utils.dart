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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/app_theme.dart';
import 'package:pumped_end_device/util/log_util.dart';

class WidgetUtils {
  static const _tag = 'WidgetUtils';

  static void showToastMessage(final BuildContext context, final String message, {final bool isErrorToast = false}) {
    final FToast fToast = FToast();
    fToast.init(context);
    final Color color = AppTheme.modalBottomSheetBg(context);
    final textColor = isErrorToast ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary;
    final Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: color),
        child: Text(message,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: textColor), textAlign: TextAlign.center,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
    fToast.removeQueuedCustomToasts();
    fToast.showToast(child: toast, gravity: ToastGravity.BOTTOM, toastDuration: const Duration(seconds: 3));
  }

  static SnackBar buildSnackBar(final BuildContext context, final String text, final int durationToFadeIn,
      final String actionLabel, final Function() onPressedFunction,
      {final bool isError = false, final bool isDismissable = true}) {
    final textColor = isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary;
    final actionColor = isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary;
    var snackBar = SnackBar(
        dismissDirection: !isDismissable ? DismissDirection.none : DismissDirection.down,
        elevation: 2,
        backgroundColor: AppTheme.modalBottomSheetBg(context),
        content: Text(text, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: textColor),
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
        duration: Duration(seconds: durationToFadeIn),
        behavior: SnackBarBehavior.fixed,
        action: SnackBarAction(label: actionLabel, onPressed: onPressedFunction, textColor: actionColor));
    return snackBar;
  }

  static void showPumpedUnavailabilityMessage(
      final DocumentSnapshot underMaintenanceDocSnap, final BuildContext context) {
    bool? underMaintenance = underMaintenanceDocSnap['underMaintenance'];
    if (underMaintenance != null && underMaintenance) {
      final String underMaintenanceMsg = underMaintenanceDocSnap['maintenanceMessage'];
      ScaffoldMessenger.of(context)
          .showSnackBar(buildSnackBar(context, underMaintenanceMsg, 12 * 60 * 60 * 30, 'Exit', () {
        if (Platform.isIOS) {
          // Apple does not like  this, as it is against their Human Interface Guidelines.
          exit(0);
        } else if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          // Not sure if SystemNavigator.pop(); would work
        }
      }, isError: true));
    } else {
      LogUtil.debug(_tag, 'Pumped Backend is not under maintenance');
    }
  }
}
