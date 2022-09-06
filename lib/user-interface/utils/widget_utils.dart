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
import 'package:fluttertoast/fluttertoast.dart';

class WidgetUtils {
  static void showToastMessage(final BuildContext context, final String message) {
    final FToast fToast = FToast();
    fToast.init(context);
    final Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: Theme.of(context).primaryColor),
        child: Text(message, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center));
    fToast.removeQueuedCustomToasts();
    fToast.showToast(child: toast, gravity: ToastGravity.BOTTOM, toastDuration: const Duration(seconds: 3));
  }

  static SnackBar buildSnackBar2(final BuildContext context, final String text, final int durationToFadeIn,
      final String actionLabel, final Function() onPressedFunction) {
    var snackBar = SnackBar(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        content: Text(text, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500)),
        duration: Duration(seconds: durationToFadeIn),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
            label: actionLabel, onPressed: onPressedFunction, textColor: Theme.of(context).primaryColor));
    return snackBar;
  }

  static void showPumpedUnavailabilityMessage(final String underMaintenanceDocSnap, final BuildContext context) {}

  static Widget getRoundedButton(
      {required BuildContext context,
      required String buttonText,
      required Function() onTapFunction,
      final IconData? iconData}) {
    return GestureDetector(
        onTap: onTapFunction,
        child: Container(
          // Intentionally using Theme.of(context).textTheme.headline1!.color! for border, because using primaryColor
          // for border does not work well when theme is dark.
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).textTheme.headline1!.color!, width: 1)),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Text(buttonText, style: Theme.of(context).textTheme.button),
                  const SizedBox(width: 8),
                  iconData != null ? Icon(iconData, size: 24) : const SizedBox(width: 0)
                ]))));
  }
}
