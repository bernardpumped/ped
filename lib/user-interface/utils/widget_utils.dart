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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pumped_end_device/util/log_util.dart';

class WidgetUtils {
  static const _tag = 'WidgetUtils';

  static Widget getRating(final double? rating, final double size) {
    return rating != null
        ? RatingBarIndicator(
            rating: rating,
            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: size,
            direction: Axis.horizontal)
        : const SizedBox(width: 0);
  }

  static void showToastMessage(final BuildContext context, final String message, final Color color) {
    final FToast fToast = FToast();
    fToast.init(context);
    final Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: color),
        child: Text(message, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center));
    fToast.removeQueuedCustomToasts();
    fToast.showToast(child: toast, gravity: ToastGravity.BOTTOM, toastDuration: const Duration(seconds: 3));
  }

  static SnackBar buildSnackBar(final BuildContext context, final String text, final int durationToFadeIn,
      final String actionLabel, final Function() onPressedFunction,
      {final Color? snackbarColor, final Color? snackBarTextColor, final Color? actionLabelColor}) {
    var snackBar = SnackBar(
        backgroundColor: snackbarColor ?? Theme.of(context).dialogBackgroundColor,
        content: Text(text, style: TextStyle(color: snackBarTextColor ?? Colors.indigo, fontWeight: FontWeight.w500)),
        duration: Duration(seconds: durationToFadeIn),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: actionLabel, onPressed: onPressedFunction, textColor: actionLabelColor));
    return snackBar;
  }

  static void showPumpedUnavailabilityMessage(
      final DocumentSnapshot underMaintenanceDocSnap, final BuildContext context) {
    bool? underMaintenance = underMaintenanceDocSnap['underMaintenance'];
    if (underMaintenance != null && underMaintenance) {
      final String underMaintenanceMsg = underMaintenanceDocSnap['maintenanceMessage'];
      ScaffoldMessenger.of(context)
          .showSnackBar(WidgetUtils.buildSnackBar(context, underMaintenanceMsg, 12 * 60 * 60 * 30, 'Exit', () {
        if (Platform.isIOS) {
          // Apple does not like  this, as it is against their Human Interface Guidelines.
          exit(0);
        } else if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          // Not sure if SystemNavigator.pop(); would work
        }
      }, snackbarColor: Colors.indigo, snackBarTextColor: Colors.white, actionLabelColor: Colors.red));
    } else {
      LogUtil.debug(_tag, 'Pumped Backend is not under maintenance');
    }
  }

  static ElevatedButton getRoundedElevatedButton(
      {final Function()? onPressed,
      final Widget? child,
      required final Color backgroundColor,
      final Color foreGroundColor = Colors.white,
      required final double borderRadius}) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(foreGroundColor),
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)))),
        child: Padding(padding: const EdgeInsets.only(left: 15, right: 15), child: child));
  }
}
