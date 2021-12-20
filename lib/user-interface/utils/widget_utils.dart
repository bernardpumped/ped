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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetUtils {
  static const _TAG = 'WidgetUtils';

  static Widget getTabHeaderWidget(
      final BuildContext context, final String title) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
        child: Text(title,
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center));
  }

  static Icon buildCupertinoIcon(final int iconCode,
      {final double size, final Color color}) {
    return Icon(
        IconData(iconCode,
            fontFamily: CupertinoIcons.iconFont,
            fontPackage: CupertinoIcons.iconFontPackage),
        size: size,
        color: color);
  }

  static Widget getRating(final double rating, final double size) {
    return rating != null
        ? RatingBar.readOnly(
            initialRating: rating,
            isHalfAllowed: true,
            halfFilledIcon: Icons.star_half,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            filledColor: Colors.orangeAccent,
            halfFilledColor: Colors.orangeAccent,
            size: size)
        : SizedBox(width: 0);
  }

  static Widget getActionIconCircular(final Icon icon, final String description,
      final Color backgroundColor, final Color textColor,
      {final Function onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Column(children: <Widget>[
          CircleAvatar(child: icon, backgroundColor: backgroundColor),
          SizedBox(height: 7),
          Text(description,
              style: TextStyle(color: textColor, fontSize: 12),
              textAlign: TextAlign.center)
        ]));
  }

  static void showToastMessage(
      final BuildContext context, final String message, final Color color) {
    final FToast fToast = FToast();
    fToast.init(context);
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: color),
      child: Text(message,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
    );
    fToast.removeQueuedCustomToasts();
    fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 3));
  }

  static void launchCaller(
      final String phone, final Function onFailureFunction) async {
    final String phoneUrl = Uri.encodeFull("tel:$phone");
    try {
      if (await canLaunch(phoneUrl)) {
        await launch(phoneUrl);
      } else {
        LogUtil.debug(_TAG, 'Could not launch $phoneUrl');
        onFailureFunction.call();
      }
    } on Exception catch (e) {
      LogUtil.debug(_TAG, 'Exception invoking phoneUrl $phoneUrl $e');
      onFailureFunction.call();
    }
  }

  static SnackBar buildSnackBar(
      final BuildContext context,
      final String text,
      final int durationToFadeIn,
      final String actionLabel,
      final Function onPressedFunction) {
    var snackBar = SnackBar(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      content:
          Text(text, style: TextStyle(color: Theme.of(context).primaryColor)),
      duration: Duration(seconds: durationToFadeIn),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(label: actionLabel, onPressed: onPressedFunction),
    );
    return snackBar;
  }

  static ElevatedButton getRoundedElevatedButton({
    final Function onPressed,
    final Widget child,
    final Color backgroundColor,
    final Color foreGroundColor = Colors.white,
    final double borderRadius}) {
    return ElevatedButton(onPressed: onPressed,
        child: Padding(child: child, padding: EdgeInsets.only(left: 15, right: 15)),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(foreGroundColor),
          backgroundColor:
          MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius))),
        ));
  }

  static TextButton getRoundedTextButton({
      final Function onPressed,
      final Widget child,
      final Color backgroundColor,
      final Color foreGroundColor = Colors.white,
      final double borderRadius}) {
    return TextButton(
        onPressed: onPressed,
        child: Padding(child: child, padding: EdgeInsets.only(left: 15, right: 15)),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(foreGroundColor),
          backgroundColor:
              MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius))),
        ));
  }
}
