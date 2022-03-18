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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/screens/widget/server_version_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_text_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';

import 'cleanup_local_cache_screen.dart';
import 'customize_search_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _moreIcon = Icon(IconData(IconCodes.navigateNextIconCode, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 30);
  static const _cleanupLocalCache =
      Icon(IconData(IconCodes.cleanUpLocalCacheIconCodeMaterial, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 30);

  @override
  Widget build(final BuildContext context) {
    const pedVersion = appVersion;
    return Scaffold(
        appBar: const CupertinoNavigationBar(middle: ApplicationTitleTextWidget()),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  WidgetUtils.getTabHeaderWidget(context, "Settings"),
                  const Padding(
                      padding: EdgeInsets.only(left: 10), child: Text("User", style: TextStyle(fontSize: FontsAndColors.largeFontSize))),
                  Container(
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(border: Border.all(color: const Color(0x22000000)), borderRadius: BorderRadius.circular(5)),
                      child: Row(children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                                margin: const EdgeInsets.all(7),
                                child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: const Color(0xffdddddd),
                                    foregroundColor: Theme.of(context).primaryColor,
                                    child: const Icon(IconData(IconCodes.accountIconCode, fontFamily: 'MaterialIcons'), size: 80)))),
                        Expanded(
                            flex: 5,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                      child: Text("Welcome ", style: TextStyle(fontSize: 15))),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 3, left: 10, right: 10),
                                      child: Text("Logged in via Google", style: TextStyle(fontSize: 13))),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 3, left: 10, right: 10),
                                      child: Text("Last Login - 25th Jan 2020", style: TextStyle(fontSize: 13))),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: WidgetUtils.getRoundedTextButton(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              foreGroundColor: Colors.white,
                                              borderRadius: 18.0,
                                              child: const Text('Logout'),
                                              onPressed: () {})))
                                ]))
                      ])),
                  ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                      leading: PumpedIcons.settingsIconBlack54Size30,
                      title: const Text("Customize Search", style: TextStyle(fontSize: 14)),
                      subtitle: const Text("Adjust search options to narrow down search results as per needs", style: TextStyle(fontSize: 13)),
                      trailing: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, CustomizeSearchSettingsScreen.routeName);
                          },
                          child: _moreIcon)),
                  ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      dense: true,
                      leading: _cleanupLocalCache,
                      title: const Text("Clear local cache", style: TextStyle(fontSize: 14)),
                      subtitle: const Text(
                          "Resets search settings, removes the favourite fuel stations, cleans up local update history, removes app cached data",
                          style: TextStyle(fontSize: 13)),
                      trailing: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, CleanupLocalCacheScreen.routeName);
                          },
                          child: _moreIcon)),
                  const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: ListTile(
                        title: Text("Pumped App Release - $pedVersion",
                            style: TextStyle(
                                fontSize: FontsAndColors.largeFontSize, color: FontsAndColors.blackTextColor),
                            textAlign: TextAlign.center)),
                  ),
                  const ServerVersionWidget()
                ]))));
  }
}
