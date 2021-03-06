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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/utils/firebase_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class PumpedSignInWidget extends StatelessWidget {
  static const _tag = 'PumpedSignInWidget';
  const PumpedSignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return _dialogContent(context);
  }

  Widget _dialogContent(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, bottom: 50),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Image(
              image: AssetImage('assets/images/ic_pumped_black_text.png'), width: 100, height: 86, fit: BoxFit.fill),
          const SizedBox(height: 15.0),
          SignInButton(Buttons.GoogleDark, onPressed: () {
            _signInUsingIdProvider(context, FirebaseService.googleIdProvider);
          }),
          const SizedBox(height: 10),
          SignInButton(Buttons.Facebook, onPressed: () {
            _signInUsingIdProvider(context, FirebaseService.facebookIdProvider);
          }),
          const SizedBox(height: 10),
          SignInButton(Buttons.Twitter, onPressed: () {
            _signInUsingIdProvider(context, FirebaseService.twitterIdProvider);
          })
        ]));
  }

  void _signInUsingIdProvider(final BuildContext context, final String idProvider) async {
    final FirebaseService service = getIt.get<FirebaseService>(instanceName: firebaseServiceInstanceName);
    try {
      final bool signedIn = await service.signIn(idProvider);
      LogUtil.debug(_tag, 'signedIn = $signedIn');
      Navigator.of(context).pop(signedIn);
    } catch (e) {
      if (e is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(WidgetUtils.buildSnackBar2(
            'Error happened while logging in', Theme.of(context).dialogBackgroundColor, 10, 'DISMISS', () => {}));
      }
    }
  }
}
