import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao2/user_configuration_dao.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/pumped_exception.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/settings/model/dropdown_values.dart';
import 'package:pumped_end_device/user-interface/settings/service/settings_service.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelTypeSwitcherWidget extends StatefulWidget {
  final FuelType selectedFuelType;
  final FuelCategory selectedFuelCategory;
  final Function onChangeCallback;
  final Function onCancelCallback;

  const FuelTypeSwitcherWidget(
      {Key? key,
      required this.selectedFuelType,
      required this.selectedFuelCategory,
      required this.onChangeCallback,
      required this.onCancelCallback})
      : super(key: key);

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
    _fuelTypeSelectedValue = widget.selectedFuelType;
    _fuelCategorySelectedValue = widget.selectedFuelCategory;
    _fuelCategoryDropdownValues = SettingsService.instance.fuelCategoryDropdownValues();
    _fuelTypeDropdownValues = SettingsService.instance.fuelTypeDropdownValues(widget.selectedFuelCategory);
  }

  @override
  Widget build(final BuildContext context) {
    return ListView(padding: const EdgeInsets.all(15), children: [
      ListTile(
          leading: const Icon(Icons.workspaces_outline, size: 34),
          title: Text('Change Fuel Type', style: Theme.of(context).textTheme.displayMedium,
              textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Card(child: _getFuelCategoriesExpansionTile()),
      Card(child: _getFuelTypesExpansionTile()),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        WidgetUtils.getRoundedButton(
            context: context,
            buttonText: 'Cancel',
            onTapFunction: () => widget.onCancelCallback(),
            iconData: Icons.cancel_outlined),
        const SizedBox(width: 40),
        WidgetUtils.getRoundedButton(
            context: context,
            buttonText: 'Apply',
            iconData: Icons.save_alt,
            onTapFunction: () async {
              final UserConfiguration? userConfig = await UserConfigurationDao.instance.getUserConfiguration(UserConfiguration.defaultUserConfigId);
              if (userConfig == null) {
                throw PumpedException("UserConfiguration cannot be null");
              }
              UserConfiguration userConfigUpdated = UserConfiguration(id: userConfig.id, numSearchResults: userConfig.numSearchResults,
                  defaultFuelType: _fuelTypeSelectedValue!, defaultFuelCategory: _fuelCategorySelectedValue!,
                  searchRadius: userConfig.searchRadius, searchCriteria: userConfig.searchCriteria, version: userConfig.version + 1);
              await UserConfigurationDao.instance.insertUserConfiguration(userConfigUpdated);
              LogUtil.debug(_tag, 'Finished persisting ${_fuelTypeSelectedValue!.fuelName} and ${_fuelCategorySelectedValue!.categoryName} to db');
              widget.onChangeCallback(FuelTypeSwitcherResponseParams(
                  fuelType: _fuelTypeSelectedValue!, fuelCategory: _fuelCategorySelectedValue!));
            })
      ])
    ]);
  }

  FutureBuilder<DropDownValues<FuelCategory>> _getFuelCategoriesExpansionTile() {
    return FutureBuilder(
        future: _fuelCategoryDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
            return Text('Error loading Fuel Categories',
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.error));
          } else if (snapshot.hasData) {
            final DropDownValues<FuelCategory> dropDownValues = snapshot.data!;
            _fuelCategorySelectedValue ??= dropDownValues.values[dropDownValues.selectedIndex];
            return ExpansionTile(
                title: Text('Fuel Category', style: Theme.of(context).textTheme.headlineSmall,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                subtitle: _fuelCategorySelectedValue != null
                    ? Text(_fuelCategorySelectedValue!.categoryName, style: Theme.of(context).textTheme.bodySmall,
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                    : const SizedBox(width: 0),
                leading: const Icon(Icons.category_outlined, size: 35),
                children: dropDownValues.values.map<RadioListTile<FuelCategory>>((FuelCategory category) {
                  return RadioListTile<FuelCategory>(
                      selected: category.categoryId == _fuelCategorySelectedValue?.categoryId,
                      value: category,
                      title: Text(category.categoryName, style: Theme.of(context).textTheme.titleLarge,
                          textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                      groupValue: _fuelCategorySelectedValue,
                      onChanged: (changedCat) {
                        setState(() {
                          LogUtil.debug(_tag, '_fuelCategorySelectedValue::mystate $changedCat');
                          _fuelTypeSelectedValue = changedCat!.defaultFuelType;
                          _fuelCategorySelectedValue = changedCat;
                          _fuelTypeDropdownValues = SettingsService.instance.fuelTypeDropdownValues(changedCat);
                        });
                      });
                }).toList());
          } else {
            return Text('Loading...', style: Theme.of(context).textTheme.headlineSmall,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
          }
        });
  }

  FutureBuilder<DropDownValues<FuelType>> _getFuelTypesExpansionTile() {
    return FutureBuilder<DropDownValues<FuelType>>(
        future: _fuelTypeDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
            return Text('Error loading',
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.error));
          } else if (snapshot.hasData) {
            final DropDownValues<FuelType> dropDownValues = snapshot.data!;
            if (dropDownValues.noDataFound) {
              return Text('No data found',
                  textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.error));
            } else {
              _fuelTypeSelectedValue ??= __fuelTypeSelectedValue(dropDownValues);
              return ExpansionTile(
                  title: Text('Fuel Type', style: Theme.of(context).textTheme.headlineSmall,
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  subtitle: _fuelTypeSelectedValue != null
                      ? Text(_fuelTypeSelectedValue!.fuelName, style: Theme.of(context).textTheme.bodySmall,
                        textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
                      : const SizedBox(width: 0),
                  leading: const Icon(Icons.class_outlined, size: 35),
                  children: dropDownValues.values.map<RadioListTile<FuelType>>((FuelType fuelType) {
                    return RadioListTile<FuelType>(
                        selected: fuelType.fuelType == _fuelTypeSelectedValue?.fuelType,
                        value: fuelType,
                        title: Text(fuelType.fuelName, style: Theme.of(context).textTheme.titleLarge,
                              textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                        groupValue: _fuelTypeSelectedValue,
                        onChanged: (changedFuelType) {
                          setState(() {
                            _fuelTypeSelectedValue = changedFuelType;
                          });
                        });
                  }).toList());
            }
          } else {
            return Text('Loading...', style: Theme.of(context).textTheme.headlineSmall,
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
}
