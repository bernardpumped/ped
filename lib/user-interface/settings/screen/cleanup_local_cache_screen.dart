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
  static const routeName = '/ped/settings/clean-cache';

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
                        onPressed: () async {
                          List<String> dataToClean = _dataToClean();
                          if (dataToClean.isNotEmpty) {
                            String msg = 'Cleaning up ${dataToClean.join(", ")}';
                            BuildContext? dialogContext;
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  dialogContext = context;
                                  return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10), side: const BorderSide(width: 0.2)),
                                      title: const Text("Cleaning data", style: TextStyle(color: Colors.indigo)),
                                      content: Row(children: [
                                        Expanded(
                                            child: Text(msg,
                                                style:
                                                    const TextStyle(fontSize: 15, height: 1.4, color: Colors.indigo))),
                                        const RefreshProgressIndicator(
                                            backgroundColor: Colors.indigo, color: Colors.white)
                                      ]));
                                });
                            String failedString  = await _cleanUp(context);
                            if (dialogContext != null) {
                              Navigator.pop(dialogContext!);
                            }
                            if (mounted) {
                              if (failedString.isNotEmpty) {
                                WidgetUtils.showToastMessage(context, failedString, Colors.indigo);
                              } else {
                                Navigator.pop(context);
                              }
                            }
                          } else {
                            WidgetUtils.showToastMessage(context, 'Nothing selected to clean', Colors.indigo);
                          }
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

  Future<String> _cleanUp(final BuildContext context) async {
    bool searchSettingsDeleted = true;
    bool updateHistoryDeleted = true;
    bool favouriteStationsDeleted = true;
    bool hiddenFuelStationsDeleted = true;
    if (_clearSearchSettings || _clearApplicationData) {
      searchSettingsDeleted = await _cleanUpSearchSettings();
    }
    if (_clearUpdateHistory || _clearApplicationData) {
      updateHistoryDeleted = await _cleanUpUpdateHistory();
    }
    if (_clearFavouriteStations || _clearApplicationData) {
      favouriteStationsDeleted = await _cleanUpFavouriteStations();
    }
    if (_clearHiddenFuelStations || _clearApplicationData) {
      hiddenFuelStationsDeleted = await _cleanUpHiddenStations();
    }
    return _getFailedString(searchSettingsDeleted, updateHistoryDeleted, favouriteStationsDeleted, hiddenFuelStationsDeleted);
    // Navigator.pop(context);
  }

  Future<bool> _cleanUpSearchSettings() async {
    try {
      await UserConfigurationDao.instance.deleteUserConfiguration(UserConfiguration.defaultUserConfigId);
      LogUtil.debug(_tag, '${UserConfiguration.defaultUserConfigId} User Config successfully deleted');
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (error, s) {
      LogUtil.debug(_tag, 'Error deleting user configuration $s');
      return false;
    }
    return true;
  }

  Future<bool> _cleanUpUpdateHistory() async {
    try {
      int result = await UpdateHistoryDao.instance.deleteUpdateHistory();
      LogUtil.debug(_tag, '$result Update History records successfully deleted');
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (error, s) {
      LogUtil.debug(_tag, 'Error deleting Update History $s');
      return false;
    }
    return true;
  }

  Future<bool> _cleanUpFavouriteStations() async {
    try {
      int result = await FavoriteFuelStationsDao.instance.dropFavoriteFuelStations();
      LogUtil.debug(_tag, '$result Favorite fuel-stations successfully deleted');
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (error, s) {
      LogUtil.debug(_tag, 'Error deleting Favorite fuel stations $s');
      return false;
    }
    return true;
  }

  Future<bool> _cleanUpHiddenStations() async {
    try {
      int result = await HiddenResultDao.instance.deleteAllHiddenResults();
      LogUtil.debug(_tag, '$result Hidden fuel-stations successfully deleted');
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (error, s) {
      LogUtil.debug(_tag, 'Error deleting Hidden Fuel Stations $s');
      return false;
    }
    return true;
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

  List<String> _dataToClean() {
    if (_clearApplicationData) {
      return [favFuelStations, hdnFuelStations, srchSettings, updtHistory];
    } else {
      List<String> dataToClean = [];
      if (_clearFavouriteStations) {
        dataToClean.add(favFuelStations);
      }
      if (_clearUpdateHistory) {
        dataToClean.add(updtHistory);
      }
      if (_clearSearchSettings) {
        dataToClean.add(srchSettings);
      }
      if (_clearHiddenFuelStations) {
        dataToClean.add(hdnFuelStations);
      }
      return dataToClean;
    }
  }

  static const favFuelStations = 'Favourite Fuel Stations';
  static const hdnFuelStations = 'Hidden Fuel Stations';
  static const srchSettings = 'Search Settings';
  static const updtHistory = 'Update History';

  String _getFailedString(bool searchSettingsDeleted, bool updateHistoryDeleted, bool favouriteStationsDeleted,
      bool hiddenFuelStationsDeleted) {
    var failed = [];
    if ((_clearApplicationData || _clearFavouriteStations)) {
      if (!favouriteStationsDeleted) {
        failed.add('Favourite Fuel Stations');
      }
    }
    if ((_clearApplicationData || _clearHiddenFuelStations)) {
      if (!hiddenFuelStationsDeleted) {
        failed.add('Hidden Fuel Stations');
      }
    }
    if ((_clearApplicationData || _clearSearchSettings)) {
      if (!searchSettingsDeleted) {
        failed.add('Search Settings');
      }
    }
    if ((_clearApplicationData || _clearUpdateHistory)) {
      if (!updateHistoryDeleted) {
        failed.add('Update History');
      }
    }
    if (failed.isNotEmpty) {
      return 'Failed deleting ${failed.join(",")}.';
    }
    return '';
  }
}
