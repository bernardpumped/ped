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
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignInWidget extends StatelessWidget {
  static const double padding = 16.0;
  static const double avatarRadius = 66.0;

  static const String title = "Sign In";
  static const String description = "Please authenticate yourself, before proceeding ahead";
  static const String buttonText = "Cancel";

  const SignInWidget({Key? key}) : super(key: key);

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
        padding: const EdgeInsets.only(top: padding, bottom: padding, left: padding, right: padding),
        margin: const EdgeInsets.only(top: avatarRadius),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Image(
                image: AssetImage('assets/images/ic_pumped_black_text.png'), width: 100, height: 86, fit: BoxFit.fill),
            const SizedBox(height: 16.0),
            const Text(title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16.0),
            const Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0)),
            const SizedBox(height: 24.0),
            SignInButton(Buttons.GoogleDark, onPressed: () {
              _onButtonPressed(context, 'Google (dark)');
            }),
            const Divider(),
            SignInButton(Buttons.Facebook, onPressed: () {
              _onButtonPressed(context, 'Facebook');
            }),
            const Divider(),
            SignInButton(Buttons.Twitter, text: "Use Twitter", onPressed: () {
              _onButtonPressed(context, 'Twitter');
            }),
            Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(buttonText, style: TextStyle(color: Colors.black)))),
          ],
        ),
      ),
    );
  }

  void _onButtonPressed(BuildContext context, String s) {
    Navigator.of(context).pop(true);
  }
}
