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
import 'package:pumped_end_device/data/local/dao2/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped_exception.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel-type-switcher/fuel_type_switcher_btn.dart';
import 'package:pumped_end_device/user-interface/settings/model/dropdown_values.dart';
import 'package:pumped_end_device/user-interface/settings/service/settings_service.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/app_theme.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelTypeSwitcherWidget extends StatefulWidget {
  final FuelType selectedFuelType;
  final FuelCategory selectedFuelCategory;
  final Function onChangeCallback;

  const FuelTypeSwitcherWidget(
      {super.key, required this.selectedFuelType, required this.selectedFuelCategory, required this.onChangeCallback});

  @override
  State<FuelTypeSwitcherWidget> createState() => _FuelTypeSwitcherWidgetState();
}

class _FuelTypeSwitcherWidgetState extends State<FuelTypeSwitcherWidget> {
  static const _tag = 'FuelStationFuelTypeWidget';

  FuelType? _fuelTypeSelectedValue;
  FuelCategory? _fuelCategorySelectedValue;
  Future<DropDownValues<FuelType>>? _fuelTypeDropdownValues;
  Future<DropDownValues<FuelCategory>>? _fuelCategoryDropdownValues;

  @override
  void initState() {
    super.initState();
    _fuelCategoryDropdownValues = SettingsService.instance.fuelCategoryDropdownValues();
    _fuelTypeDropdownValues = SettingsService.instance.fuelTypeDropdownValues(widget.selectedFuelCategory);
  }

  @override
  Widget build(final BuildContext context) {
    String txtToDisplay = widget.selectedFuelType.fuelName;
    if (txtToDisplay.length > 15) {
      txtToDisplay = widget.selectedFuelType.fuelName.substring(0, 15);
    }
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              backgroundColor: AppTheme.modalBottomSheetBg(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              context: context,
              builder: _modalBottomSheetBuilder);
        },
        child: FuelTypeSwitcherButton(txtToDisplay, () {
          showModalBottomSheet(
              context: context,
              builder: _modalBottomSheetBuilder,
              backgroundColor: AppTheme.modalBottomSheetBg(context));
        }));
  }

  updateSelectedFuelType() {
    setState(() {
      if (_fuelTypeSelectedValue != null && _fuelCategorySelectedValue != null) {
        widget.onChangeCallback(FuelTypeSwitcherResponseParams(
            fuelType: _fuelTypeSelectedValue!, fuelCategory: _fuelCategorySelectedValue!));
      } else {
        LogUtil.debug(
            _tag,
            'Not invoking onChangeCallback as _fuelTypeSelectedValue : $_fuelTypeSelectedValue '
            'and _fuelCategorySelectedValue $_fuelCategorySelectedValue');
      }
    });
  }

  _persistUpdatedFuelTypeSelection() async {
    if (_fuelTypeSelectedValue != null && _fuelCategorySelectedValue != null) {
      LogUtil.debug(_tag, 'Fetching userConfig with id ${UserConfiguration.defaultUserConfigId}');
      final UserConfiguration? userConfig = await UserConfigurationDao.instance.getUserConfiguration(
          UserConfiguration.defaultUserConfigId);
      if (userConfig == null) {
        throw PumpedException("UserConfiguration cannot be null");
      }
      UserConfiguration userConfigUpdated = UserConfiguration(id: userConfig.id,
          numSearchResults: userConfig.numSearchResults,
          defaultFuelType: _fuelTypeSelectedValue!,
          defaultFuelCategory: _fuelCategorySelectedValue!,
          searchRadius: userConfig.searchRadius,
          searchCriteria: userConfig.searchCriteria,
          version: userConfig.version + 1);
      await UserConfigurationDao.instance.insertUserConfiguration(userConfigUpdated);
    }
  }

  Widget _modalBottomSheetBuilder(context) {
    LogUtil.debug(_tag, '_modalBottomSheetBuilder invoked');
    _fuelTypeSelectedValue = widget.selectedFuelType;
    _fuelCategorySelectedValue = widget.selectedFuelCategory;
    return StatefulBuilder(builder: (final BuildContext context, final StateSetter mystate) {
      return ListView(padding: const EdgeInsets.all(15), children: [
        ListTile(
            leading: const Icon(Icons.workspaces, size: 35),
            title: Text('Change Fuel Type', style: Theme.of(context).textTheme.titleLarge,
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
        Card(child: _getFuelCategoriesExpansionTile(mystate)),
        Card(child: _getFuelTypesExpansionTile(mystate)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
          const SizedBox(width: 40),
          ElevatedButton(
              onPressed: () async {
                await _persistUpdatedFuelTypeSelection();
                updateSelectedFuelType();
                Navigator.pop(context);
              },
              child: Text('Apply', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
        ])
      ]);
    });
  }

  FutureBuilder<DropDownValues<FuelType>> _getFuelTypesExpansionTile(final StateSetter mystate) {
    return FutureBuilder<DropDownValues<FuelType>>(
        future: _fuelTypeDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
            return Text('Error loading', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final DropDownValues<FuelType> dropDownValues = snapshot.data!;
            if (dropDownValues.noDataFound) {
              return Text('No data found', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
            } else {
              _fuelTypeSelectedValue ??= __fuelTypeSelectedValue(dropDownValues);
              return ExpansionTile(
                  title: Text('Fuel Type', style: Theme.of(context).textTheme.titleSmall,
                      textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  subtitle: _fuelTypeSelectedValue != null
                      ? Text(_fuelTypeSelectedValue!.fuelName, style: Theme.of(context).textTheme.bodyLarge,
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                      : const SizedBox(width: 0),
                  leading: const Icon(Icons.class_, size: 24),
                  children: dropDownValues.values.map<RadioListTile<FuelType>>((FuelType fuelType) {
                    return RadioListTile<FuelType>(
                        selected: fuelType.fuelType == _fuelTypeSelectedValue?.fuelType,
                        value: fuelType,
                        title: Text(fuelType.fuelName, style: Theme.of(context).textTheme.bodySmall,
                            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                        groupValue: _fuelTypeSelectedValue,
                        onChanged: (changedFuelType) {
                          mystate(() {
                            _fuelTypeSelectedValue = changedFuelType;
                          });
                        });
                  }).toList());
            }
          } else {
            return Text('Loading...', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
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
            return Text('Error loading Fuel Categories', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          } else if (snapshot.hasData) {
            final DropDownValues<FuelCategory> dropDownValues = snapshot.data!;
            _fuelCategorySelectedValue ??= dropDownValues.values[dropDownValues.selectedIndex];
            return ExpansionTile(
                title: Text('Fuel Category', style: Theme.of(context).textTheme.titleSmall,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                subtitle: _fuelCategorySelectedValue != null
                    ? Text(_fuelCategorySelectedValue!.categoryName, style: Theme.of(context).textTheme.bodyLarge,
                        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                    : const SizedBox(width: 0),
                leading: const Icon(Icons.category, size: 24),
                children: dropDownValues.values.map<RadioListTile<FuelCategory>>((FuelCategory category) {
                  return RadioListTile<FuelCategory>(
                      selected: category.categoryId == _fuelCategorySelectedValue?.categoryId,
                      value: category,
                      title: Text(category.categoryName, style: Theme.of(context).textTheme.bodySmall,
                          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                      groupValue: _fuelCategorySelectedValue,
                      onChanged: (changedCat) {
                        mystate(() {
                          LogUtil.debug(_tag, '_fuelCategorySelectedValue::mystate $changedCat');
                          _fuelTypeSelectedValue = changedCat!.defaultFuelType;
                          _fuelCategorySelectedValue = changedCat;
                          _fuelTypeDropdownValues = SettingsService.instance.fuelTypeDropdownValues(changedCat);
                        });
                      });
                }).toList());
          } else {
            return Text('Loading...', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }
}
