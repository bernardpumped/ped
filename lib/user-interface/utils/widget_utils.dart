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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WidgetUtils {
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

  static Widget wrapWithRoundedContainer(
      {required BuildContext context, required double radius, required Widget child}) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
        child: child);
  }

  static Widget getRoundedButton(
      {required BuildContext context,
      required String buttonText,
      required Function() onTapFunction,
      final IconData? iconData}) {
    return GestureDetector(
        onTap: onTapFunction,
        child: WidgetUtils.wrapWithRoundedContainer(
            context: context,
            radius: 24,
            child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(children: [
                  Text(buttonText, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  iconData != null ? Icon(iconData, size: 20) : const SizedBox(width: 0)
                ]))));
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
