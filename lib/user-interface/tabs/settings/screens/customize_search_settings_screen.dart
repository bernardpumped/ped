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

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/service/settings_service.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/data/dropdown_values.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_text_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/quote_sort_order.dart';
import 'package:pumped_end_device/util/log_util.dart';

class CustomizeSearchSettingsScreen extends StatefulWidget {
  static const routeName = '/customizeSearchSettings';

  @override
  State<StatefulWidget> createState() {
    return _CustomizeSearchSettingsScreenState();
  }
}

class _CustomizeSearchSettingsScreenState
    extends State<CustomizeSearchSettingsScreen> {
  static const _TAG = '_CustomizeSearchSettingsScreenIosState';
  static const _unselectedValInt = -1;
  static const _unselectedValDouble = -1.0;

  final List<String> searchCriteria = ["Cheapest Closest", "Closest Cheapest"];
  final SettingsService _settingsDataSource = new SettingsService();

  num _searchRadiusSelectedValue = _unselectedValDouble;
  num _searchResultsCountSelectedValue = _unselectedValInt;
  FuelCategory _fuelCategorySelectedValue;
  FuelType _fuelTypeSelectedValue;
  SortOrder _sortOrderSelectedVal;
  int _userSettingsVersion;

  Future<int> _userSettingsVersionFuture;
  Future<DropDownValues<FuelCategory>> _fuelCategoryDropdownValues;
  Future<DropDownValues<FuelType>> _fuelTypeDropdownValues;
  Future<DropDownValues<SortOrder>> _sortOrderDropdownValues;

  @override
  void initState() {
    super.initState();
    _fuelCategoryDropdownValues =
        _settingsDataSource.fuelCategoryDropdownValues();
    _fuelTypeDropdownValues =
        _settingsDataSource.fuelTypeDropdownValues(_fuelCategorySelectedValue);
    _sortOrderDropdownValues = _settingsDataSource.sortOrderDropdownValues();
    _userSettingsVersionFuture = UserConfigurationDao.instance
        .getUserConfigurationVersion(UserConfiguration.DEFAULT_USER_CONFIG_ID);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
            middle: ApplicationTitleTextWidget(),
            automaticallyImplyLeading: true),
        body: Container(
            width: double.infinity,
            padding: EdgeInsets.only(right: 15, bottom: 15, left: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: WidgetUtils.getTabHeaderWidget(
                          context, 'Customize search')),
                  Expanded(
                      child: ListView(children: <Widget>[
                    _numberOfSearchResultsListTile(),
                    Divider(color: Colors.black87, height: 1),
                    _fuelCategoriesListTile(),
                    Divider(color: Colors.black87, height: 1),
                    _fuelTypeListTile(),
                    Divider(color: Colors.black87, height: 1),
                    _searchRadiusListTile(),
                    Divider(color: Colors.black87, height: 1),
                    _searchCriteriaListTile(),
                    Divider(color: Colors.black87, height: 1),
                    _getButtonRow(context),
                    _getVersionNumberRow()
                  ]))
                ])));
  }

  Widget _getButtonRow(final BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          WidgetUtils.getRoundedElevatedButton(
              backgroundColor: Theme.of(context).primaryColor,
              foreGroundColor: Colors.white,
              borderRadius: 18.0,
              child: Text("Save"),
              onPressed: () {
                if (_userSettingsVersion >= 1) {
                  _userSettingsVersion = _userSettingsVersion + 1;
                  _settingsDataSource
                      .insertSettings(
                          _searchRadiusSelectedValue,
                          _searchResultsCountSelectedValue,
                          _fuelCategorySelectedValue,
                          _fuelTypeSelectedValue,
                          _sortOrderSelectedVal.sortOrderStr,
                          _userSettingsVersion)
                      .then((result) {
                    WidgetUtils.showToastMessage(
                        context,
                        'Search Settings updated',
                        Theme.of(context).primaryColor);
                    Navigator.of(context).pop();
                  }, onError: (error, s) {
                    LogUtil.debug(_TAG, 'Failed Persistence Result $s');
                    WidgetUtils.showToastMessage(
                        context,
                        'Error updating search settings',
                        Theme.of(context).primaryColor);
                  });
                } else {
                  WidgetUtils.showToastMessage(
                      context,
                      'Settings not loaded. So cannot save.',
                      Theme.of(context).primaryColor);
                }
              })
        ]));
  }

  Widget _getVersionNumberRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Container(
          child: FutureBuilder<int>(
              future: _userSettingsVersionFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  _userSettingsVersion = -1;
                  LogUtil.debug(
                      _TAG, '_getVersionNumberRow::${snapshot.error}');
                  return Text('Error loading the settings',
                      style: TextStyle(color: Colors.red, fontSize: 13));
                } else if (snapshot.hasData) {
                  _userSettingsVersion = snapshot.data;
                  return Text('Version : $_userSettingsVersion',
                      style: TextStyle(color: Colors.black87, fontSize: 13));
                } else {
                  return Text('Loading');
                }
              }))
    ]);
  }

  static const _searchCriteriaIcon = const Icon(
      IconData(IconCodes.search_criteria_icon_code,
          fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: Colors.black54,
      size: 30);

  ListTile _searchCriteriaListTile() {
    return ListTile(
        leading: _searchCriteriaIcon, // compare icon
        contentPadding: EdgeInsets.only(left: 5),
        dense: false,
        isThreeLine: true,
        title: Container(
            child: Text("Search Criteria", style: TextStyle(fontSize: 14))),
        subtitle: Container(
            child: Text("Prefer Price or distance",
                style: TextStyle(fontSize: 13))),
        trailing: DropdownButtonHideUnderline(child: _sortOrderDropdown()));
  }

  Widget _sortOrderDropdown() {
    return FutureBuilder<DropDownValues<SortOrder>>(
      future: _sortOrderDropdownValues,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          LogUtil.debug(_TAG,
              '_sortOrderDropdown::_sortOrderDropdownValues error ${snapshot.error}');
          return Container(child: Text('Error loading'));
        } else if (snapshot.hasData) {
          final DropDownValues<SortOrder> dropDownValues = snapshot.data;
          _sortOrderSelectedVal = _sortOrderSelectedVal == null
              ? dropDownValues.values[dropDownValues.selectedIndex]
              : _sortOrderSelectedVal;
          return DropdownButton<SortOrder>(
            value: _sortOrderSelectedVal,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            style: TextStyle(color: Colors.black),
            onChanged: (SortOrder newValue) {
              setState(() {
                _sortOrderSelectedVal = newValue;
              });
            },
            items: dropDownValues.values
                .map<DropdownMenuItem<SortOrder>>((SortOrder sortOrder) {
              return DropdownMenuItem<SortOrder>(
                  value: sortOrder,
                  child: Text(sortOrder.sortOrderName,
                      style: TextStyle(fontSize: 14)));
            }).toList(),
          );
        } else {
          return Container(child: Text('No Values'));
        }
      },
    );
  }

  static const _searchRadiusIcon = Icon(
      IconData(IconCodes.search_radius_icon_code,
          fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: Colors.black54,
      size: 30);

  ListTile _searchRadiusListTile() {
    return ListTile(
        leading: _searchRadiusIcon, // explore icon
        contentPadding: EdgeInsets.only(left: 5),
        dense: false,
        isThreeLine: true,
        title: Container(
            child: Text("Search Radius", style: TextStyle(fontSize: 14))),
        subtitle: Container(
            child: Text("Maximum distance around your location to search",
                style: TextStyle(fontSize: 13))),
        trailing: DropdownButtonHideUnderline(
            child: _getSearchRadiusDropDown(
                _settingsDataSource.searchRadiusDropDownValues(5))));
  }

  ListTile _fuelTypeListTile() {
    return ListTile(
        leading: PumpedIcons.fuelTypesIcon_black54Size30,
        contentPadding: EdgeInsets.only(left: 5),
        dense: false,
        isThreeLine: true,
        title:
            Container(child: Text("Fuel Type", style: TextStyle(fontSize: 14))),
        subtitle: Container(
            child: Text("Search Result are filtered by fuel type",
                style: TextStyle(fontSize: 13))),
        trailing: DropdownButtonHideUnderline(child: _getFuelTypeDropdown()));
  }

  Widget _getFuelTypeDropdown() {
    return FutureBuilder<DropDownValues<FuelType>>(
        future: _fuelTypeDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_TAG,
                '_getFuelTypeDropdown::_fuelTypeDropdownValues error ${snapshot.error}');
            return Container(child: Text('Error loading'));
          } else if (snapshot.hasData) {
            final DropDownValues<FuelType> dropDownValues = snapshot.data;
            if (snapshot.data.noDataFound) {
              return Container(child: Text('No Data'));
            } else {
              _fuelTypeSelectedValue = __fuelTypeSelectedValue(dropDownValues);
              return DropdownButton<FuelType>(
                value: _fuelTypeSelectedValue,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 20,
                style: TextStyle(color: Colors.black),
                onChanged: (FuelType newValue) {
                  setState(() {
                    _fuelTypeSelectedValue = newValue;
                  });
                },
                items: dropDownValues.values
                    .map<DropdownMenuItem<FuelType>>((FuelType value) {
                  return DropdownMenuItem<FuelType>(
                      value: value,
                      child:
                          Text(value.fuelName, style: TextStyle(fontSize: 14)));
                }).toList(),
              );
            }
          } else {
            LogUtil.debug(_TAG, 'No values found from fuelTypeFuture');
            return Container(child: Text('Loading'));
          }
        });
  }

  FuelType __fuelTypeSelectedValue(
      final DropDownValues<FuelType> dropDownValues) {
    if (_fuelTypeSelectedValue != null &&
        dropDownValues.values.contains(_fuelTypeSelectedValue)) {
      return _fuelTypeSelectedValue;
    } else {
      return dropDownValues.values[dropDownValues.selectedIndex];
    }
  }

  ListTile _fuelCategoriesListTile() {
    return ListTile(
        leading: PumpedIcons.fuelCategoriesIcon_black54Size30, // Category
        contentPadding: EdgeInsets.only(left: 5),
        dense: false,
        isThreeLine: true,
        title: Container(
            child: Text("Fuel Category", style: TextStyle(fontSize: 14))),
        subtitle: Container(
            child: Text("Fuel types are grouped into fuel categories",
                style: TextStyle(fontSize: 13))),
        trailing: DropdownButtonHideUnderline(child: _fuelCategoryDropdown()));
  }

  FutureBuilder<DropDownValues<FuelCategory>> _fuelCategoryDropdown() {
    return FutureBuilder<DropDownValues<FuelCategory>>(
      future: _fuelCategoryDropdownValues,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          LogUtil.debug(_TAG,
              '_fuelCategoryDropdown _fuelCategoryDropdownValues error ${snapshot.error}');
          return Container(child: Text('Error loading'));
        } else if (snapshot.hasData) {
          if (snapshot.data.noDataFound) {
            return Container(child: Text('No values'));
          } else {
            final DropDownValues<FuelCategory> dropDownValues = snapshot.data;
            _fuelCategorySelectedValue = _fuelCategorySelectedValue == null
                ? dropDownValues.values[dropDownValues.selectedIndex]
                : _fuelCategorySelectedValue;
            return DropdownButton<FuelCategory>(
              value: _fuelCategorySelectedValue,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              style: TextStyle(color: Colors.black),
              onChanged: (FuelCategory newValue) {
                setState(() {
                  _fuelTypeSelectedValue = null;
                  _fuelCategorySelectedValue = newValue;
                  _fuelTypeDropdownValues =
                      _settingsDataSource.fuelTypeDropdownValues(newValue);
                });
              },
              items: dropDownValues.values
                  .map<DropdownMenuItem<FuelCategory>>((FuelCategory value) {
                return DropdownMenuItem<FuelCategory>(
                  value: value,
                  child:
                      Text(value.categoryName, style: TextStyle(fontSize: 14)),
                );
              }).toList(),
            );
          }
        } else {
          LogUtil.debug(_TAG, 'No value found in fuelCategoryFuture');
          return Container(child: Text('Loading'));
        }
      },
    );
  }

  static const _numSearchResultsIcon = const Icon(
      IconData(IconCodes.number_of_search_results,
          fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: Colors.black54,
      size: 30);

  ListTile _numberOfSearchResultsListTile() {
    return ListTile(
        leading: _numSearchResultsIcon,
        contentPadding: EdgeInsets.only(left: 5),
        title: Container(
            child: Text("Number of Search Results",
                style: TextStyle(fontSize: 14))),
        subtitle: Container(
            child: Text("Cheapest closest fuel station around your location",
                style: TextStyle(fontSize: 13))),
        dense: false,
        isThreeLine: true,
        trailing: DropdownButtonHideUnderline(
            child: _getSearchResultsCountDropDown(
                _settingsDataSource.searchFuelStationDropDownValues(5))));
  }

  FutureBuilder<DropDownValues<num>> _getSearchResultsCountDropDown(
      final Future<DropDownValues<num>> dropDownValues) {
    return new FutureBuilder<DropDownValues<num>>(
        future: dropDownValues, //
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_TAG,
                'Error getting values from searchResultsCountFuture ${snapshot.error}');
            return Container(child: Text('Error loading'));
          } else if (snapshot.hasData) {
            final DropDownValues<num> dropDownValues = snapshot.data;
            _searchResultsCountSelectedValue =
                _searchResultsCountSelectedValue == _unselectedValDouble
                    ? dropDownValues.values[dropDownValues.selectedIndex]
                    : _searchResultsCountSelectedValue;
            return DropdownButton<num>(
              value: _searchResultsCountSelectedValue,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              style: TextStyle(color: Colors.black),
              onChanged: (num newValue) {
                setState(() {
                  _searchResultsCountSelectedValue = newValue;
                });
              },
              items:
                  dropDownValues.values.map<DropdownMenuItem<num>>((num value) {
                return DropdownMenuItem<num>(
                  value: value,
                  child: Text(value.toString(), style: TextStyle(fontSize: 14)),
                );
              }).toList(),
            );
          } else {
            LogUtil.debug(_TAG, 'No values found in searchResultCountFuture');
            return Container(child: Text('No values'));
          }
        });
  }

  FutureBuilder<DropDownValues<num>> _getSearchRadiusDropDown(
      final Future<DropDownValues<num>> dropDownValues) {
    return new FutureBuilder<DropDownValues<num>>(
        future: dropDownValues, //
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_TAG,
                '_getSearchRadiusDropDown::dropDownValues error ${snapshot.error}');
            return Container(child: Text('Error loading'));
          } else if (snapshot.hasData) {
            final DropDownValues<num> dropDownValues = snapshot.data;
            _searchRadiusSelectedValue =
                _searchRadiusSelectedValue == _unselectedValDouble
                    ? dropDownValues.values[dropDownValues.selectedIndex]
                    : _searchRadiusSelectedValue;
            return DropdownButton<num>(
              value: _searchRadiusSelectedValue,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              style: TextStyle(color: Colors.black),
              onChanged: (num newValue) {
                setState(() {
                  _searchRadiusSelectedValue = newValue;
                });
              },
              items:
                  dropDownValues.values.map<DropdownMenuItem<num>>((num value) {
                return DropdownMenuItem<num>(
                  value: value,
                  child: Text(value.toString(), style: TextStyle(fontSize: 14)),
                );
              }).toList(),
            );
          } else {
            LogUtil.debug(_TAG, 'No value found in searchRadiusFuture');
            return Container(child: Text('No values'));
          }
        });
  }
}
