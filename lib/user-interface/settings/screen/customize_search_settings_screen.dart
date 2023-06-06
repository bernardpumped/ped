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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao2/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/user-interface/settings/screen/settings_screen.dart';
import 'package:pumped_end_device/user-interface/settings/service/settings_service.dart';
import 'package:pumped_end_device/user-interface/settings/model/dropdown_values.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/quote_sort_order.dart';
import 'package:pumped_end_device/util/log_util.dart';

class CustomizeSearchSettingsScreen extends StatefulWidget {
  static const routeName = '/ped/settings/edit';

  const CustomizeSearchSettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomizeSearchSettingsScreenState();
  }
}

class _CustomizeSearchSettingsScreenState extends State<CustomizeSearchSettingsScreen> {
  static const _tag = '_CustomizeSearchSettingsScreenIosState';
  static const _unselectedValInt = -1;
  static const _unselectedValDouble = -1.0;

  num _searchRadiusSelectedValue = _unselectedValDouble;
  num _searchResultsCountSelectedValue = _unselectedValInt;
  FuelCategory? _fuelCategorySelectedValue;
  FuelType? _fuelTypeSelectedValue;
  SortOrder? _sortOrderSelectedVal;
  int? _userSettingsVersion;

  Future<int>? _userSettingsVersionFuture;
  Future<DropDownValues<FuelCategory>>? _fuelCategoryDropdownValues;
  Future<DropDownValues<FuelType>>? _fuelTypeDropdownValues;
  Future<DropDownValues<SortOrder>>? _sortOrderDropdownValues;
  Future<DropDownValues<num>>? _numSearchResultsDropdownValues;
  Future<DropDownValues<num>>? _searchRadiusDropdownValues;

  @override
  void initState() {
    super.initState();
    _fuelCategoryDropdownValues = SettingsService.instance.fuelCategoryDropdownValues();
    _fuelTypeDropdownValues = SettingsService.instance.fuelTypeDropdownValues(_fuelCategorySelectedValue);
    _sortOrderDropdownValues = SettingsService.instance.sortOrderDropdownValues();
    _userSettingsVersionFuture =
        UserConfigurationDao.instance.getUserConfigurationVersion(UserConfiguration.defaultUserConfigId);
    _numSearchResultsDropdownValues = SettingsService.instance.searchFuelStationDropDownValues(5);
    _searchRadiusDropdownValues = SettingsService.instance.searchRadiusDropDownValues(5);
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: const PumpedAppBar(title: SettingsScreen.viewLabel, icon: SettingsScreen.viewSelectedIcon),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                      child: Row(children: [
                        const Icon(Icons.settings_outlined, size: 30),
                        const SizedBox(width: 10),
                        Text('Customize Search',
                            style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center)
                      ])),
                  Expanded(
                      child: ListView(children: <Widget>[
                    _expansionTileDecoration(_getNumSearchResultsExpansionTile()),
                    _expansionTileDecoration(_getFuelCategoriesExpansionTile()),
                    _expansionTileDecoration(_getFuelTypesExpansionTile()),
                    _expansionTileDecoration(_getSearchRadiusExpansionTile()),
                    _expansionTileDecoration(_getSortOrderExpansionTile()),
                    _getButtonRow(context),
                    _getVersionNumberRow()
                  ]))
                ]))));
  }

  Widget _expansionTileDecoration(final Widget expansionTile) {
    return Card(child: expansionTile);
  }

  FutureBuilder<DropDownValues<num>> _getNumSearchResultsExpansionTile() {
    return FutureBuilder<DropDownValues<num>>(
        future: _numSearchResultsDropdownValues, //
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, '_getNumSearchResultsExpansionTile::error ${snapshot.error}');
            return Text('Error Loading Num Search Results Count',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final DropDownValues<num> dropDownValues = snapshot.data!;
            _searchResultsCountSelectedValue = _searchResultsCountSelectedValue == _unselectedValDouble
                ? dropDownValues.values[dropDownValues.selectedIndex]
                : _searchResultsCountSelectedValue;
            return ExpansionTile(
                title: Text('Number of Search Results', style: Theme.of(context).textTheme.titleMedium,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                subtitle: Text('$_searchResultsCountSelectedValue fuel stations around you',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                leading: const Icon(Icons.format_list_numbered, size: 30),
                children: dropDownValues.values.map<RadioListTile<num>>((num numVal) {
                  return RadioListTile<num>(
                      selected: numVal == _searchResultsCountSelectedValue,
                      value: numVal,
                      title: Text('${numVal.toString()} fuel stations', style: Theme.of(context).textTheme.titleSmall,
                          textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                      groupValue: _searchResultsCountSelectedValue,
                      onChanged: (newNumVal) {
                        setState(() {
                          if (newNumVal != null) {
                            _searchResultsCountSelectedValue = newNumVal;
                          } else {
                            LogUtil.debug(_tag, '_getNumSearchResultsExpansionTile::newValue in dropdown is null');
                          }
                        });
                      });
                }).toList());
          } else {
            return Text('Loading values for Num Search Results', style: Theme.of(context).textTheme.titleSmall,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  FutureBuilder<DropDownValues<FuelCategory>> _getFuelCategoriesExpansionTile() {
    return FutureBuilder<DropDownValues<FuelCategory>>(
        future: _fuelCategoryDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, '_fuelCategoryDropdown _fuelCategoryDropdownValues error ${snapshot.error}');
            return Text('Error Loading Fuel Categories',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final DropDownValues<FuelCategory> dropDownValues = snapshot.data!;
            if (dropDownValues.noDataFound) {
              return Text('No Fuel Categories Found',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                  textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            } else {
              _fuelCategorySelectedValue =
                  _fuelCategorySelectedValue ?? dropDownValues.values[dropDownValues.selectedIndex];
              return ExpansionTile(
                  title: Text('Fuel Category', style: Theme.of(context).textTheme.titleMedium,
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  subtitle: _fuelCategorySelectedValue != null
                      ? Text('Fuel types from ${_fuelCategorySelectedValue!.categoryName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                      : const SizedBox(width: 0),
                  leading: const Icon(Icons.category_outlined, size: 30),
                  children: dropDownValues.values.map<RadioListTile<FuelCategory>>((FuelCategory fuelCategory) {
                    return RadioListTile<FuelCategory>(
                        selected: fuelCategory.categoryId == _fuelCategorySelectedValue?.categoryId,
                        value: fuelCategory,
                        title: Text(fuelCategory.categoryName, style: Theme.of(context).textTheme.titleSmall,
                            textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                        groupValue: _fuelCategorySelectedValue,
                        onChanged: (changedFuelType) {
                          setState(() {
                            if (changedFuelType != null) {
                              _fuelTypeSelectedValue = null;
                              _fuelCategorySelectedValue = changedFuelType;
                              _fuelTypeDropdownValues = SettingsService.instance.fuelTypeDropdownValues(changedFuelType);
                            } else {
                              LogUtil.debug(_tag, '_fuelCategoryDropdown::newValue in dropdown is null');
                            }
                          });
                        });
                  }).toList());
            }
          } else {
            return Text('Loading Fuel Categories...', style: Theme.of(context).textTheme.titleSmall,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  FutureBuilder<DropDownValues<FuelType>> _getFuelTypesExpansionTile() {
    return FutureBuilder(
        future: _fuelTypeDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, '_getFuelTypesExpansionTile::error ${snapshot.error}');
            return Text('Error Loading Fuel Types',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final DropDownValues<FuelType> dropDownValues = snapshot.data!;
            if (dropDownValues.noDataFound) {
              return Text('No Fuel Types found',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                  textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            } else {
              _fuelTypeSelectedValue = __fuelTypeSelectedValue(dropDownValues);
              return ExpansionTile(
                  title: Text('Fuel Types', style: Theme.of(context).textTheme.titleMedium,
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  subtitle: _fuelTypeSelectedValue != null
                      ? Text('Filter results by ${_fuelTypeSelectedValue!.fuelName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                      : const SizedBox(width: 0),
                  leading: const Icon(Icons.class_outlined, size: 30),
                  children: dropDownValues.values.map<RadioListTile<FuelType>>((FuelType fuelType) {
                    return RadioListTile<FuelType>(
                        selected: fuelType.fuelType == _fuelTypeSelectedValue?.fuelType,
                        value: fuelType,
                        title: Text(fuelType.fuelName, style: Theme.of(context).textTheme.titleSmall,
                            textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                        groupValue: _fuelTypeSelectedValue,
                        onChanged: (changedFuelType) {
                          setState(() {
                            if (changedFuelType != null) {
                              _fuelTypeSelectedValue = changedFuelType;
                            } else {
                              LogUtil.debug(_tag, '_getFuelTypesExpansionTile::newValue in dropdown is null');
                            }
                          });
                        });
                  }).toList());
            }
          } else {
            return Text('Loading Fuel Types...', style: Theme.of(context).textTheme.titleSmall,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  FutureBuilder<DropDownValues<num>> _getSearchRadiusExpansionTile() {
    return FutureBuilder<DropDownValues<num>>(
        future: _searchRadiusDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, '_getSearchRadiusExpansionTile::error ${snapshot.error}');
            return Text('Error Loading Search Radius',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final DropDownValues<num> dropDownValues = snapshot.data!;
            _searchRadiusSelectedValue = _searchRadiusSelectedValue == _unselectedValDouble
                ? dropDownValues.values[dropDownValues.selectedIndex]
                : _searchRadiusSelectedValue;
            return ExpansionTile(
                title: Text('Search Radius', style: Theme.of(context).textTheme.titleMedium,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                subtitle: Text('Search $_searchRadiusSelectedValue Km Radius around you',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                leading: const Icon(Icons.explore_outlined, size: 30),
                children: dropDownValues.values.map<RadioListTile<num>>((num numVal) {
                  return RadioListTile<num>(
                      selected: numVal == _searchRadiusSelectedValue,
                      value: numVal,
                      title: Text('${numVal.toString()} Km Radius', style: Theme.of(context).textTheme.titleSmall,
                          textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                      groupValue: _searchRadiusSelectedValue,
                      onChanged: (newNumVal) {
                        setState(() {
                          if (newNumVal != null) {
                            _searchRadiusSelectedValue = newNumVal;
                          } else {
                            LogUtil.debug(_tag, '_getSearchRadiusExpansionTile::newValue in dropdown is null');
                          }
                        });
                      });
                }).toList());
          } else {
            return Text('Loading Search Radius...', style: Theme.of(context).textTheme.titleSmall,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  FutureBuilder<DropDownValues<SortOrder>> _getSortOrderExpansionTile() {
    return FutureBuilder(
        future: _sortOrderDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, '_getSortOrderExpansionTile::error ${snapshot.error}');
            return Text('Error Loading Sort Order',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final DropDownValues<SortOrder> dropDownValues = snapshot.data!;
            _sortOrderSelectedVal = _sortOrderSelectedVal ?? dropDownValues.values[dropDownValues.selectedIndex];
            return ExpansionTile(
                title: Text('Result Sort Order', style: Theme.of(context).textTheme.titleMedium,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                subtitle: _sortOrderSelectedVal != null
                    ? Text('Prefer ${_sortOrderSelectedVal!.sortOrderDesc!}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                    : const SizedBox(width: 0),
                leading: const Icon(Icons.compare_outlined, size: 30),
                children: dropDownValues.values.map<RadioListTile<SortOrder>>((SortOrder sortOrder) {
                  return RadioListTile<SortOrder>(
                      selected: sortOrder == _sortOrderSelectedVal,
                      value: sortOrder,
                      title: Text(sortOrder.sortOrderName!, style: Theme.of(context).textTheme.titleSmall,
                          textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                      groupValue: _sortOrderSelectedVal,
                      onChanged: (newSortOrder) {
                        setState(() {
                          if (newSortOrder != null) {
                            _sortOrderSelectedVal = newSortOrder;
                          } else {
                            LogUtil.debug(_tag, '_getSortOrderExpansionTile::newValue in dropdown is null');
                          }
                        });
                      });
                }).toList());
          } else {
            return Text('Loading values for Sort Order...', style: Theme.of(context).textTheme.titleSmall,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  FuelType __fuelTypeSelectedValue(final DropDownValues<FuelType> dropDownValues) {
    if (_fuelTypeSelectedValue != null && dropDownValues.values.contains(_fuelTypeSelectedValue)) {
      return _fuelTypeSelectedValue!;
    } else {
      return dropDownValues.values[dropDownValues.selectedIndex];
    }
  }

  Widget _getButtonRow(final BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          ElevatedButton(
              onPressed: () {
                if (_userSettingsVersion != null && _userSettingsVersion! >= 1) {
                  if (_fuelCategorySelectedValue != null &&
                      _fuelTypeSelectedValue != null &&
                      _sortOrderSelectedVal != null) {
                    _userSettingsVersion = _userSettingsVersion! + 1;
                    SettingsService.instance
                        .insertSettings(
                            _searchRadiusSelectedValue,
                            _searchResultsCountSelectedValue,
                            _fuelCategorySelectedValue!,
                            _fuelTypeSelectedValue!,
                            _sortOrderSelectedVal!.sortOrderStr!,
                            _userSettingsVersion!)
                        .then((result) {
                      WidgetUtils.showToastMessage(context, 'Search Settings updated');
                      Navigator.of(context).pop();
                    }, onError: (error, s) {
                      LogUtil.debug(_tag, 'Failed Persistence Result $s');
                      WidgetUtils.showToastMessage(context, 'Error updating search settings', isErrorToast: true);
                    });
                  } else {
                    LogUtil.debug(
                        _tag,
                        '_getButtonRow::Inconsistent state _fuelCategorySelectedValue : $_fuelCategorySelectedValue'
                        '  _fuelTypeSelectedValue : $_fuelTypeSelectedValue  _sortOrderSelectedVal : $_sortOrderSelectedVal');
                  }
                } else {
                  WidgetUtils.showToastMessage(context, 'Settings not loaded. So cannot save.');
                }
              },
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                      children: [const Icon(Icons.save_alt_outlined, size: 24), const SizedBox(width: 10),
                        Text('Save', textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)])))
        ]));
  }

  Widget _getVersionNumberRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      FutureBuilder<int>(
          future: _userSettingsVersionFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              _userSettingsVersion = -1;
              LogUtil.debug(_tag, '_getVersionNumberRow::${snapshot.error}');
              return Text('Error loading the user settings version',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                  textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            } else if (snapshot.hasData) {
              _userSettingsVersion = snapshot.data;
              return Text('User Settings Version : $_userSettingsVersion', style: Theme.of(context).textTheme.bodySmall,
                  textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            } else {
              return Text('Loading', textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            }
          })
    ]);
  }
}
