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
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/data/dropdown_values.dart';
import 'package:pumped_end_device/user-interface/tabs/settings/service/settings_service.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelTypeSwitcherWidget extends StatefulWidget {
  final FuelType selectedFuelType;
  final FuelCategory selectedFuelCategory;

  const FuelTypeSwitcherWidget({Key? key, required this.selectedFuelType, required this.selectedFuelCategory}) : super(key: key);

  @override
  State<FuelTypeSwitcherWidget> createState() => _FuelTypeSwitcherWidgetState();
}

class _FuelTypeSwitcherWidgetState extends State<FuelTypeSwitcherWidget> {
  static const _tag = 'FuelStationFuelTypeWidget';
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
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(context: context, builder: _modalBottomSheetBuilder);
      },
      child: Chip(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        avatar: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.workspaces, color: Theme.of(context).primaryColor)),
        label: Text(_fuelTypeSelectedValue!.fuelName),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        labelPadding: const EdgeInsets.all(3),
        onDeleted: (){
          showModalBottomSheet(context: context, builder: _modalBottomSheetBuilder);
        },
        deleteIcon: const Icon(Icons.chevron_right, color: Colors.white)),
    );
  }

  updateSelectedFuelType() {
    setState(() {
    });
  }

  Widget _modalBottomSheetBuilder(context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
      return ListView(
          padding: const EdgeInsets.all(15),
          children: [
            ListTile(
                leading: Icon(Icons.workspaces_outlined, size: 25, color: secondaryColor),
                title: Text('Change Fuel Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: secondaryColor))),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: _getFuelCategoriesExpansionTile(mystate),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: _getFuelTypesExpansionTile(mystate),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    updateSelectedFuelType();
                    Navigator.pop(context);
                  },
                  child: Text('Change', style: TextStyle(color: secondaryColor)))])
          ]);
    });
  }

  FutureBuilder<DropDownValues<FuelType>> _getFuelTypesExpansionTile(final StateSetter mystate) {
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
              return ExpansionTile(
                title: const Text('Fuel Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                subtitle: _fuelTypeSelectedValue != null ? Text(_fuelTypeSelectedValue!.fuelName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)) : const SizedBox(width: 0),
                leading: const Icon(Icons.class__outlined, size: 24),
                children: dropDownValues.values.map<RadioListTile<FuelType>>((FuelType fuelType) {
                  return RadioListTile<FuelType>(
                    selected: fuelType.fuelType == _fuelTypeSelectedValue?.fuelType,
                    value: fuelType,
                    title: Text(fuelType.fuelName),
                    groupValue: _fuelTypeSelectedValue,
                    onChanged: (changedFuelType) {
                      mystate(() {
                        _fuelTypeSelectedValue = changedFuelType;
                      });
                    });
                }).toList()
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

  FutureBuilder<DropDownValues<FuelCategory>> _getFuelCategoriesExpansionTile(final StateSetter mystate) {
    return FutureBuilder(
      future: _fuelCategoryDropdownValues,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
          return const Text('Error loading Fuel Categories');
        } else if (snapshot.hasData) {
          final DropDownValues<FuelCategory> dropDownValues = snapshot.data!;
          _fuelCategorySelectedValue ??= dropDownValues.values[dropDownValues.selectedIndex];
          return ExpansionTile(
            title: const Text('Fuel Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            subtitle: _fuelCategorySelectedValue != null ?
                Text(_fuelCategorySelectedValue!.categoryName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal))
                : const SizedBox(width: 0),
            leading: const Icon(Icons.category, size: 24),
            children: dropDownValues.values.map<RadioListTile<FuelCategory>>((FuelCategory category) {
              return RadioListTile<FuelCategory>(
                selected: category.categoryId == _fuelCategorySelectedValue?.categoryId,
                value: category,
                title: Text(category.categoryName),
                groupValue: _fuelCategorySelectedValue,
                onChanged: (changedCat) {
                  mystate(() {
                    _fuelTypeSelectedValue = null;
                    _fuelCategorySelectedValue = changedCat;
                    _fuelTypeDropdownValues = _settingsDataSource.fuelTypeDropdownValues(changedCat);
                  });
                });
            }).toList()
          );
        } else {
          return const Text('Loading...');
        }
    });
  }
}