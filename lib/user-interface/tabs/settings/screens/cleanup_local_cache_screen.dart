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
import 'package:pumped_end_device/data/local/dao/favorite_fuel_stations_dao.dart';
import 'package:pumped_end_device/data/local/dao/update_history_dao.dart';
import 'package:pumped_end_device/data/local/dao/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_text_widget.dart';
import 'package:pumped_end_device/util/log_util.dart';

class CleanupLocalCacheScreen extends StatefulWidget {
  static const routeName = '/cleanUpLocalCache';

  const CleanupLocalCacheScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CleanupLocalCacheScreenState();
  }
}

class _CleanupLocalCacheScreenState
    extends State<CleanupLocalCacheScreen> {
  static const _tag = 'CleanupLocalCacheScreen';
  static const _cleanUpSearchSettingsIconBlack54Size30 = Icon(
      IconData(IconCodes.cleanupSearchSettingsIconCode,
          fontFamily: 'MaterialIcons'),
      size: 30,
      color: Colors.black54);
  static const _cleanUpUpdateHistoryIconBlack54Size30 = Icon(
      IconData(IconCodes.cleanUpUpdateHistoryIconCode,
          fontFamily: 'MaterialIcons'),
      size: 30,
      color: Colors.black54);
  static const _cleanUpFavouriteStationsIconBlack54Size30 = Icon(
      IconData(IconCodes.cleanUpFavouriteStationsIconCode,
          fontFamily: 'MaterialIcons'),
      size: 30,
      color: Colors.black54);
  static const _cleanUpAppDataIconBlack54Size30 = Icon(
      IconData(IconCodes.cleanUpApplicationDataIconCode,
          fontFamily: 'MaterialIcons'),
      size: 30,
      color: Colors.black54);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
          middle: ApplicationTitleTextWidget(),
          automaticallyImplyLeading: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 5, left: 10),
              child: WidgetUtils.getTabHeaderWidget(
                  context, 'Clear Local Cache')),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              children: <Widget>[
                _buildListTile(
                    _cleanUpSearchSettingsIconBlack54Size30,
                    "Search Settings",
                    "Clear search settings. It will set all the values to defaults.",
                    _clearSearchSettings, (value) {
                  setState(() {
                    LogUtil.debug(
                        _tag, 'build::Clear Search settings Click function');
                    _clearSearchSettings = value;
                  });
                }),
                _buildListTile(
                    _cleanUpUpdateHistoryIconBlack54Size30,
                    "Update History",
                    "All your local data related to updates made to fuel prices and operating times will be erased",
                    _clearUpdateHistory, (value) {
                  setState(() {
                    LogUtil.debug(
                        _tag, 'build::Clear Update History Click function');
                    _clearUpdateHistory = value;
                  });
                }),
                _buildListTile(
                    _cleanUpFavouriteStationsIconBlack54Size30,
                    "Favourite Stations",
                    "Clear your selected favourite stations.",
                    _clearFavouriteStations, (value) {
                  setState(() {
                    LogUtil.debug(_tag,
                        'build::Clear Favorite Stations Click function');
                    _clearFavouriteStations = value;
                  });
                }),
                _buildListTile(
                    _cleanUpAppDataIconBlack54Size30,
                    "Application Data",
                    "Clear all app cached data. It will clear search settings, update history, favourite stations..",
                    _clearApplicationData, (value) {
                  setState(() {
                    LogUtil.debug(
                        _tag, 'build::Clear Application Data Click function');
                    _clearApplicationData = value;
                  });
                }),
                ListTile(
                    contentPadding: const EdgeInsets.only(left: 10, right: 15),
                    trailing: ElevatedButton(
                        onPressed: () {
                          cleanUp(context);
                        },
                        child: const Text('Clear data'),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0))),
                        )))
              ],
            ),
          )
        ],
      ),
    );
  }

  void cleanUp(final BuildContext context) {
    if (_clearSearchSettings || _clearApplicationData) {
      _cleanUpSearchSettings(context);
    }
    if (_clearUpdateHistory || _clearApplicationData) {
      _cleanUpUpdateHistory(context);
    }
    if (_clearFavouriteStations || _clearApplicationData) {
      _cleanUpFavouriteStations(context);
    }
  }

  void _cleanUpSearchSettings(final BuildContext context) {
    final Future<int> deleteUserConfigFuture = UserConfigurationDao.instance
        .deleteUserConfiguration(UserConfiguration.defaultUserConfigId);
    deleteUserConfigFuture.then((result) {
      LogUtil.debug(_tag, 'User Configuration successfully deleted');
      WidgetUtils.showToastMessage(
          context, 'Search settings reset', Theme.of(context).primaryColor);
    }, onError: (error, s) {
      LogUtil.debug(_tag, 'Error deleting user configuration $s');
      WidgetUtils.showToastMessage(context, 'Error resetting Search settings',
          Theme.of(context).primaryColor);
    });
  }

  void _cleanUpUpdateHistory(final BuildContext context) {
    final Future<int> deleteUpdateHistoryFuture =
        UpdateHistoryDao.instance.deleteUpdateHistory();
    deleteUpdateHistoryFuture.then((result) {
      LogUtil.debug(_tag, 'Update History successfully deleted');
      WidgetUtils.showToastMessage(
          context, 'Update History deleted', Theme.of(context).primaryColor);
    }, onError: (error, s) {
      LogUtil.debug(_tag, 'Error deleting Update History $s');
      WidgetUtils.showToastMessage(context, 'Error deleting Update History',
          Theme.of(context).primaryColor);
    });
  }

  void _cleanUpFavouriteStations(final BuildContext context) {
    final Future<int> deleteFavoriteFuelStationsFuture =
        FavoriteFuelStationsDao.instance.dropFavoriteFuelStations();
    deleteFavoriteFuelStationsFuture.then((result) {
      LogUtil.debug(_tag, 'Favorite fuel-stations successfully deleted');
      WidgetUtils.showToastMessage(context, 'Favorite fuel stations deleted',
          Theme.of(context).primaryColor);
    }, onError: (error, s) {
      LogUtil.debug(_tag, 'Error deleting Favorite fuel stations $s');
      WidgetUtils.showToastMessage(
          context,
          'Error deleting Favorite fuel stations',
          Theme.of(context).primaryColor);
    });
  }

  bool _clearSearchSettings = false;
  bool _clearUpdateHistory = false;
  bool _clearFavouriteStations = false;
  bool _clearApplicationData = false;

  ListTile _buildListTile(
      final Icon icon,
      final String title,
      final String subTitle,
      final bool checkBoxValue,
      final Function onChangeFunction) {
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 10),
        leading: icon,
        title: Text(title, style: const TextStyle(fontSize: 14)),
        subtitle: Text(subTitle, style: const TextStyle(fontSize: 13)),
        trailing: Checkbox(value: checkBoxValue, onChanged: onChangeFunction));
  }
}
