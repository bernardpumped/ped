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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/about/screen/about_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/ped/about';
  AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(appBar: const PumpedAppBar(), drawer: const NavDrawerWidget(), body: _drawBody(context));
  }

  final AboutScreenColorScheme colorScheme =
      getIt.get<AboutScreenColorScheme>(instanceName: aboutScreenColorSchemeName);

  _drawBody(final BuildContext context) {
    return Container(
        color: const Color(0xFFF0EDFF),
        child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 15, right: 15),
                color: colorScheme.backgroundColor,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 5),
                          child: Text('About',
                              style:
                                  TextStyle(fontSize: 24, color: colorScheme.titleColor, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center)),
                      _buildPara(context,
                          'Pumped Your Friendly Neighbourhood Fuel finder designed and written with user first in mind.'),
                      _buildPara(
                          context,
                          'Your neighbourhood friendly fuel finder, not only locates your cheapest, closest fuel, '
                          'friendliest service, cleanest restrooms, tastiest coffee but much more. Upcoming release will advise '
                          'when your local station has promotions, both in-store products and Garage services including '
                          'tuneup, wheel alignment, oil change and soo much more!'),
                      _buildPara(
                          context,
                          'Many large retailers and oil companies develop their own fuel finder apps, however they '
                          'only list their own stations, and therefore have limited appeal to the general public, who want prices '
                          'for all the neighbourhood stations.'),
                      _buildPara(
                          context,
                          'What???s required is an app designed with user first in mind that not only lists all fuel station '
                          'prices within your neighbourhood, but also advertise any and all promotions ???products and services??? within '
                          'the fuel station. Thereby providing real value to the users whilst also providing retailers a targeted '
                          'audience for advertising and impulse buying.'),
                      _buildPara(context,
                          'This is our goal with Pumped user first, together with direct and powerful retailer incentive.')
                    ]))));
  }

  Padding _buildPara(final BuildContext context, final String text) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(text, style: TextStyle(fontSize: 16, color: colorScheme.textColor), textAlign: TextAlign.left));
  }
}
