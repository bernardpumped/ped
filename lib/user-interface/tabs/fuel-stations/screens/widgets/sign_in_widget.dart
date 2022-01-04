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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignInWidget extends StatelessWidget {
  static const double padding = 16.0;
  static const double avatarRadius = 66.0;

  static const String title = "Sign In";
  static const String description = "Please authenticate yourself, before proceeding ahead";
  static const String buttonText = "Cancel";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: padding, bottom: padding, left: padding, right: padding),
        margin: EdgeInsets.only(top: avatarRadius),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
                image: AssetImage('assets/images/ic_pumped_black_text.png'), width: 100, height: 86, fit: BoxFit.fill),
            SizedBox(height: 16.0),
            Text(title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700)),
            SizedBox(height: 16.0),
            Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 24.0),
            SignInButton(Buttons.GoogleDark, onPressed: () {
              _onButtonPressed(context, 'Google (dark)');
            }),
            Divider(),
            SignInButton(Buttons.Facebook, onPressed: () {
              _onButtonPressed(context, 'Facebook');
            }),
            Divider(),
            SignInButton(Buttons.Twitter, text: "Use Twitter", onPressed: () {
              _onButtonPressed(context, 'Twitter');
            }),
            Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(buttonText, style: TextStyle(color: Colors.black)))),
          ],
        ),
      ),
    );
  }

  void _onButtonPressed(BuildContext context, String s) {
    Navigator.of(context).pop(true);
  }
}
