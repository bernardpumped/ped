import 'package:flutter/material.dart';
import 'package:pumped_end_device/models/pumped/fuel_category.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/params/fuel_type_switcher_response_params.dart';
import 'package:pumped_end_device/user-interface/settings/model/dropdown_values.dart';
import 'package:pumped_end_device/user-interface/settings/service/settings_service.dart';
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
    _fuelTypeDropdownValues = _settingsDataSource.fuelTypeDropdownValues(widget.selectedFuelCategory);
  }

  @override
  Widget build(final BuildContext context) {
    return ListView(padding: const EdgeInsets.all(15), children: [
      ListTile(
          leading: const Icon(Icons.workspaces_outline, size: 34),
          title: Text('Change Fuel Type', style: Theme.of(context).textTheme.headline2)),
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
            onTapFunction: () {
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
                style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).errorColor));
          } else if (snapshot.hasData) {
            final DropDownValues<FuelCategory> dropDownValues = snapshot.data!;
            _fuelCategorySelectedValue ??= dropDownValues.values[dropDownValues.selectedIndex];
            return ExpansionTile(
                title: Text('Fuel Category', style: Theme.of(context).textTheme.headline5),
                subtitle: _fuelCategorySelectedValue != null
                    ? Text(_fuelCategorySelectedValue!.categoryName, style: Theme.of(context).textTheme.caption)
                    : const SizedBox(width: 0),
                leading: const Icon(Icons.category_outlined, size: 35),
                children: dropDownValues.values.map<RadioListTile<FuelCategory>>((FuelCategory category) {
                  return RadioListTile<FuelCategory>(
                      selected: category.categoryId == _fuelCategorySelectedValue?.categoryId,
                      value: category,
                      title: Text(category.categoryName, style: Theme.of(context).textTheme.headline6),
                      groupValue: _fuelCategorySelectedValue,
                      onChanged: (changedCat) {
                        setState(() {
                          LogUtil.debug(_tag, '_fuelCategorySelectedValue::mystate $changedCat');
                          _fuelTypeSelectedValue = changedCat!.defaultFuelType;
                          _fuelCategorySelectedValue = changedCat;
                          _fuelTypeDropdownValues = _settingsDataSource.fuelTypeDropdownValues(changedCat);
                        });
                      });
                }).toList());
          } else {
            return Text('Loading...', style: Theme.of(context).textTheme.headline5);
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
                style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).errorColor));
          } else if (snapshot.hasData) {
            final DropDownValues<FuelType> dropDownValues = snapshot.data!;
            if (dropDownValues.noDataFound) {
              return Text('No data found',
                  style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).errorColor));
            } else {
              _fuelTypeSelectedValue ??= __fuelTypeSelectedValue(dropDownValues);
              return ExpansionTile(
                  title: Text('Fuel Type', style: Theme.of(context).textTheme.headline5),
                  subtitle: _fuelTypeSelectedValue != null
                      ? Text(_fuelTypeSelectedValue!.fuelName, style: Theme.of(context).textTheme.caption)
                      : const SizedBox(width: 0),
                  leading: const Icon(Icons.class_outlined, size: 35),
                  children: dropDownValues.values.map<RadioListTile<FuelType>>((FuelType fuelType) {
                    return RadioListTile<FuelType>(
                        selected: fuelType.fuelType == _fuelTypeSelectedValue?.fuelType,
                        value: fuelType,
                        title: Text(fuelType.fuelName, style: Theme.of(context).textTheme.headline6),
                        groupValue: _fuelTypeSelectedValue,
                        onChanged: (changedFuelType) {
                          setState(() {
                            _fuelTypeSelectedValue = changedFuelType;
                          });
                        });
                  }).toList());
            }
          } else {
            return Text('Loading...', style: Theme.of(context).textTheme.headline5);
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
