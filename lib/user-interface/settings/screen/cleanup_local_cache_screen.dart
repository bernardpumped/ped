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
import 'package:pumped_end_device/data/local/dao/favorite_fuel_stations_dao.dart';
import 'package:pumped_end_device/data/local/dao/hidden_result_dao.dart';
import 'package:pumped_end_device/data/local/dao/update_history_dao.dart';
import 'package:pumped_end_device/data/local/dao/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

class CleanupLocalCacheScreen extends StatefulWidget {
  static const routeName = '/cleanUpLocalCache';

  const CleanupLocalCacheScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CleanupLocalCacheScreenState();
  }
}

class _CleanupLocalCacheScreenState extends State<CleanupLocalCacheScreen> {
  static const _tag = 'CleanupLocalCacheScreen';

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: const PumpedAppBar(),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFF0EDFF),
            width: double.infinity,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Text('Clear Local Cache',
                      style: TextStyle(fontSize: 24, color: Colors.indigo, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Expanded(
                  child: ListView(padding: const EdgeInsets.only(left: 10, right: 10, top: 10), children: <Widget>[
                _buildListTile(Icons.search, "Search Settings",
                    "Clear search settings. It will set all the values to defaults.", _clearSearchSettings, (value) {
                  setState(() {
                    LogUtil.debug(_tag, 'build::Clear Search settings Click function');
                    _clearSearchSettings = value!;
                  });
                }),
                _buildListTile(
                    Icons.history,
                    "Update History",
                    "All your local data related to updates made to fuel prices and operating times will be erased",
                    _clearUpdateHistory, (value) {
                  setState(() {
                    LogUtil.debug(_tag, 'build::Clear Update History Click function');
                    _clearUpdateHistory = value!;
                  });
                }),
                _buildListTile(Icons.favorite_border_outlined, "Favourite Stations",
                    "Clear your selected favourite stations.", _clearFavouriteStations, (value) {
                  setState(() {
                    LogUtil.debug(_tag, 'build::Clear Favorite Stations Click function');
                    _clearFavouriteStations = value!;
                  });
                }),
                _buildListTile(Icons.hide_source_outlined, "Hidden Fuel Stations", "Clear your hidden stations.",
                    _clearHiddenFuelStations, (value) {
                  setState(() {
                    LogUtil.debug(_tag, 'build::Clear Hidden Stations Click function');
                    _clearHiddenFuelStations = value!;
                  });
                }),
                _buildListTile(
                    Icons.description_outlined,
                    "Application Data",
                    "Clear all app cached data. It will clear search settings, update history, "
                        "favourite stations and hidden stations",
                    _clearApplicationData, (value) {
                  setState(() {
                    LogUtil.debug(_tag, 'build::Clear Application Data Click function');
                    _clearApplicationData = value!;
                  });
                }),
                ListTile(
                    contentPadding: const EdgeInsets.only(left: 10, right: 15),
                    trailing: ElevatedButton(
                        onPressed: () {
                          cleanUp(context);
                        },
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            backgroundColor: MaterialStateProperty.all(Colors.indigo),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),
                        child: const Text('Clear data')))
              ]))
            ])));
  }

  void cleanUp(final BuildContext context) {
    if (_clearSearchSettings || _clearApplicationData) {
      _cleanUpSearchSettings(context, showToast: false);
    }
    if (_clearUpdateHistory || _clearApplicationData) {
      _cleanUpUpdateHistory(context, showToast: false);
    }
    if (_clearFavouriteStations || _clearApplicationData) {
      _cleanUpFavouriteStations(context, showToast: false);
    }
    if (_clearHiddenFuelStations || _clearApplicationData) {
      _cleanUpHiddenStations(context, showToast: false);
    }
  }

  void _cleanUpSearchSettings(final BuildContext context, {final bool showToast = true}) {
    final Future<dynamic> deleteUserConfigFuture =
        UserConfigurationDao.instance.deleteUserConfiguration(UserConfiguration.defaultUserConfigId);
    deleteUserConfigFuture.then((result) {
      LogUtil.debug(_tag, 'User Configuration successfully deleted');
      if (showToast) {
        WidgetUtils.showToastMessage(context, 'Search settings reset', Colors.indigo);
      }
    }, onError: (error, s) {
      LogUtil.debug(_tag, 'Error deleting user configuration $s');
      WidgetUtils.showToastMessage(context, 'Error resetting Search settings', Colors.indigo);
    });
  }

  void _cleanUpUpdateHistory(final BuildContext context, {final bool showToast = true}) {
    final Future<dynamic> deleteUpdateHistoryFuture = UpdateHistoryDao.instance.deleteUpdateHistory();
    deleteUpdateHistoryFuture.then((result) {
      LogUtil.debug(_tag, 'Update History successfully deleted');
      if (showToast) {
        WidgetUtils.showToastMessage(context, 'Update History deleted', Colors.indigo);
      }
    }, onError: (error, s) {
      LogUtil.debug(_tag, 'Error deleting Update History $s');
      WidgetUtils.showToastMessage(context, 'Error deleting Update History', Colors.indigo);
    });
  }

  void _cleanUpFavouriteStations(final BuildContext context, {final bool showToast = true}) {
    final Future<int> deleteFavoriteFuelStationsFuture = FavoriteFuelStationsDao.instance.dropFavoriteFuelStations();
    deleteFavoriteFuelStationsFuture.then((result) {
      LogUtil.debug(_tag, '$result Favorite fuel-stations successfully deleted');
      if (showToast) {
        WidgetUtils.showToastMessage(context, 'Favorite fuel stations deleted', Colors.indigo);
      }
    }, onError: (error, s) {
      LogUtil.debug(_tag, 'Error deleting Favorite fuel stations $s');
      WidgetUtils.showToastMessage(context, 'Error deleting Favorite fuel stations', Colors.indigo);
    });
  }

  void _cleanUpHiddenStations(final BuildContext context, {final bool showToast = true}) {
    final Future<int> deleteAllHiddenResultsFuture = HiddenResultDao.instance.deleteAllHiddenResults();
    deleteAllHiddenResultsFuture.then((result) {
      LogUtil.debug(_tag, '$result Hidden fuel-stations successfully deleted');
      if (showToast) {
        WidgetUtils.showToastMessage(context, 'Hidden fuel-stations deleted', Colors.indigo);
      }
    }, onError: (error, s) {
      LogUtil.debug(_tag, 'Error deleting Hidden Fuel Stations $s');
      WidgetUtils.showToastMessage(context, 'Error deleting Hidden Fuel Stations', Colors.indigo);
    });
  }

  bool _clearSearchSettings = false;
  bool _clearUpdateHistory = false;
  bool _clearFavouriteStations = false;
  bool _clearApplicationData = false;
  bool _clearHiddenFuelStations = false;

  Widget _buildListTile(final IconData icon, final String title, final String subTitle, final bool checkBoxValue,
      final Function(bool?)? onChangeFunction) {
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: Icon(icon, size: 30, color: Colors.indigo),
            title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.indigo)),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(subTitle, style: const TextStyle(fontSize: 14, color: Colors.indigo))),
            trailing: Checkbox(
                value: checkBoxValue,
                onChanged: onChangeFunction,
                activeColor: Colors.indigo,
                focusColor: Colors.indigo)));
  }
}
