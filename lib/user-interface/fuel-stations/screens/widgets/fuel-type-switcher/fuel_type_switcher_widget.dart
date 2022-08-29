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
      const ListTile(
          leading: Icon(Icons.workspaces_outline, size: 40),
          title: Text('Change Fuel Type', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
      Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent), child: _getFuelCategoriesExpansionTile())),
      Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child:
              Theme(data: ThemeData().copyWith(dividerColor: Colors.transparent), child: _getFuelTypesExpansionTile())),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
          onTap: () {
            widget.onCancelCallback();
          },
          child: WidgetUtils.wrapWithRoundedContainer(
              context: context,
              radius: 24,
              child: const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                  child: Text('Cancel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)))),
        ),
        const SizedBox(width: 40),
        GestureDetector(
            onTap: () {
              widget.onChangeCallback(FuelTypeSwitcherResponseParams(
                  fuelType: _fuelTypeSelectedValue!, fuelCategory: _fuelCategorySelectedValue!));
            },
            child: WidgetUtils.wrapWithRoundedContainer(
                context: context,
                radius: 24,
                child: const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 8, bottom: 8),
                    child: Text('Apply', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)))))
      ])
    ]);
  }

  FutureBuilder<DropDownValues<FuelCategory>> _getFuelCategoriesExpansionTile() {
    return FutureBuilder(
        future: _fuelCategoryDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
            return const Text('Error loading Fuel Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal));
          } else if (snapshot.hasData) {
            final DropDownValues<FuelCategory> dropDownValues = snapshot.data!;
            _fuelCategorySelectedValue ??= dropDownValues.values[dropDownValues.selectedIndex];
            return ExpansionTile(
                title: const Text('Fuel Category', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                subtitle: _fuelCategorySelectedValue != null
                    ? Text(_fuelCategorySelectedValue!.categoryName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal))
                    : const SizedBox(width: 0),
                leading: const Icon(Icons.category_outlined, size: 35),
                children: dropDownValues.values.map<RadioListTile<FuelCategory>>((FuelCategory category) {
                  return RadioListTile<FuelCategory>(
                      selected: category.categoryId == _fuelCategorySelectedValue?.categoryId,
                      value: category,
                      activeColor: Colors.indigo,
                      title: Text(category.categoryName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
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
            return const Text('Loading...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal));
          }
        });
  }

  FutureBuilder<DropDownValues<FuelType>> _getFuelTypesExpansionTile() {
    return FutureBuilder<DropDownValues<FuelType>>(
        future: _fuelTypeDropdownValues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading ${snapshot.error}');
            return const Text('Error loading', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal));
          } else if (snapshot.hasData) {
            final DropDownValues<FuelType> dropDownValues = snapshot.data!;
            if (dropDownValues.noDataFound) {
              return const Text('No data found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal));
            } else {
              _fuelTypeSelectedValue ??= __fuelTypeSelectedValue(dropDownValues);
              return ExpansionTile(
                  title: const Text('Fuel Type', style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  subtitle: _fuelTypeSelectedValue != null
                      ? Text(_fuelTypeSelectedValue!.fuelName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal))
                      : const SizedBox(width: 0),
                  leading: const Icon(Icons.class_outlined, size: 35),
                  children: dropDownValues.values.map<RadioListTile<FuelType>>((FuelType fuelType) {
                    return RadioListTile<FuelType>(
                        selected: fuelType.fuelType == _fuelTypeSelectedValue?.fuelType,
                        value: fuelType,
                        activeColor: Colors.indigo,
                        title: Text(fuelType.fuelName,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                        groupValue: _fuelTypeSelectedValue,
                        onChanged: (changedFuelType) {
                          setState(() {
                            _fuelTypeSelectedValue = changedFuelType;
                          });
                        });
                  }).toList());
            }
          } else {
            return const Text('Loading...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal));
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
