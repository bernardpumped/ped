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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/service/settings_service.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/data/dropdown_values.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelTypeSwitcher extends StatefulWidget {
  final FuelCategory selectedFuelCategory;
  final FuelType selectedFuelType;

  const FuelTypeSwitcher(this.selectedFuelType, this.selectedFuelCategory, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FuelTypeSwitcher();
  }
}

class _FuelTypeSwitcher extends State<FuelTypeSwitcher> {
  static const _tag = 'FuelTypeSwitcher';
  static const padding = 15.0;
  static const avatarRadius = 66.0;
  static const subTitle = "Switch Fuel Types";
  static const okButtonText = "Ok";
  static const cancelButtonText = "Cancel";

  final SettingsService _settingsDataSource = SettingsService();

  FuelType? _fuelTypeSelectedValue;
  FuelCategory? _fuelCategorySelectedValue;
  Future<DropDownValues<FuelType>>? _fuelTypeDropdownValues;
  Future<DropDownValues<FuelCategory>>? _fuelCategoryDropdownValues;

  @override
  void initState() {
    super.initState();
    _fuelTypeSelectedValue = widget.selectedFuelType;
    _fuelCategorySelectedValue = widget.selectedFuelCategory;
    _fuelCategoryDropdownValues = _settingsDataSource.fuelCategoryDropdownValues();
    _fuelTypeDropdownValues = _settingsDataSource.fuelTypeDropdownValues(_fuelCategorySelectedValue);
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: _dialogContent(context));
  }

  Widget _dialogContent(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: padding, bottom: padding, left: padding, right: padding),
        margin: const EdgeInsets.only(top: avatarRadius),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(subTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black87))),
          const Divider(color: Colors.black54, height: 1),
          SizedBox(
              height: 50,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    PumpedIcons.fuelCategoriesIconBlack54Size30,
                    const Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Text("Category", style: TextStyle(fontSize: 16))),
                    DropdownButtonHideUnderline(child: _fuelCategoryDropdown())
                  ])),
          const Divider(color: Colors.black54, height: 1),
          SizedBox(
              height: 50,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: <Widget>[
                PumpedIcons.fuelTypesIconBlack54Size30,
                const Padding(
                    padding: EdgeInsets.only(left: 12, right: 12), child: Text("Type", style: TextStyle(fontSize: 16))),
                DropdownButtonHideUnderline(child: _getFuelTypeDropdown())
              ])),
          const Divider(color: Colors.black54, height: 1),
          _getButtonRow()
        ]));
  }

  Widget _getFuelTypeDropdown() {
    return FutureBuilder<DropDownValues<FuelType>>(
        future: _fuelTypeDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
            return const Text('Error loading');
          } else if (snapshot.hasData) {
            final DropDownValues<FuelType> dropDownValues = snapshot.data!;
            if (dropDownValues.noDataFound) {
              return const Text('No data found');
            } else {
              _fuelTypeSelectedValue = __fuelTypeSelectedValue(dropDownValues);
              return DropdownButton<FuelType>(
                value: _fuelTypeSelectedValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 20,
                style: const TextStyle(color: Colors.black),
                onChanged: (FuelType? newValue) {
                  setState(() {
                    _fuelTypeSelectedValue = newValue;
                  });
                },
                items: dropDownValues.values.map<DropdownMenuItem<FuelType>>((FuelType value) {
                  return DropdownMenuItem<FuelType>(
                      value: value,
                      child: Text(value.fuelName, style: const TextStyle(fontSize: 14), textAlign: TextAlign.end));
                }).toList(),
              );
            }
          } else {
            return const Text('Loading...');
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

  FutureBuilder<DropDownValues<FuelCategory>> _fuelCategoryDropdown() {
    return FutureBuilder<DropDownValues<FuelCategory>>(
        future: _fuelCategoryDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
            return const Text('Error loading');
          } else if (snapshot.hasData) {
            final DropDownValues<FuelCategory> dropDownValues = snapshot.data!;
            _fuelCategorySelectedValue = _fuelCategorySelectedValue ?? dropDownValues.values[dropDownValues.selectedIndex];
            return DropdownButton<FuelCategory>(
              value: _fuelCategorySelectedValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              style: const TextStyle(color: Colors.black),
              onChanged: (FuelCategory? newValue) {
                setState(() {
                  _fuelTypeSelectedValue = null;
                  _fuelCategorySelectedValue = newValue;
                  _fuelTypeDropdownValues = _settingsDataSource.fuelTypeDropdownValues(newValue);
                });
              },
              items: dropDownValues.values.map<DropdownMenuItem<FuelCategory>>((FuelCategory value) {
                return DropdownMenuItem<FuelCategory>(
                    value: value, child: Text(value.categoryName, style: const TextStyle(fontSize: 14)));
              }).toList(),
            );
          } else {
            return const Text('Loading...');
          }
        });
  }

  Widget _getButtonRow() {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(child: const Text(cancelButtonText),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
              ),
              TextButton(
                  style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Text(okButtonText),
                  onPressed: () {
                    if (_fuelCategorySelectedValue != null && _fuelTypeSelectedValue != null) {
                      Navigator.pop(context, FuelTypeSwitcherResponseParams(
                          fuelCategory: _fuelCategorySelectedValue!, fuelType: _fuelTypeSelectedValue!));
                    } else {
                      LogUtil.debug(_tag, '_getButtonRow::Not popping as _fuelCategorySelectedValue : '
                          '$_fuelCategorySelectedValue and _fuelTypeSelectedValue : $_fuelTypeSelectedValue');
                    }
                  })
            ]));
  }
}
