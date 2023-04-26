import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pumped_end_device/data/local/dao2/mock_location_dao.dart';
import 'package:pumped_end_device/data/local/model/mock_location.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class AddMockLocationWidget extends StatefulWidget {
  final Function callback;
  const AddMockLocationWidget({required this.callback, Key? key}) : super(key: key);

  @override
  State<AddMockLocationWidget> createState() => _AddMockLocationWidgetState();
}

class _AddMockLocationWidgetState extends State<AddMockLocationWidget> {
  static const _tag = 'AddMockLocationWidget';
  @override
  Widget build(final BuildContext context) {
    LogUtil.debug(_tag, 'Build method invoked for AddMockLocationWidget');
    final TextEditingController addressLineEditingController = TextEditingController();
    final TextEditingController cityEditingController = TextEditingController();
    final TextEditingController stateEditingController = TextEditingController();
    final TextEditingController countryEditingController = TextEditingController();
    final TextEditingController latitudeEditingController = TextEditingController();
    final TextEditingController longitudeEditingController = TextEditingController();

    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.add_location_alt_outlined, size: 30),
            const SizedBox(width: 20),
            Text('Add a Mock Location', style: Theme.of(context).textTheme.titleMedium,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(flex: 1, child: Text('Address Line', style: Theme.of(context).textTheme.bodyLarge,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(
                flex: 1, child: _buildTextField(addressLineEditingController, 'Enter address line', 'add-address-line'))
          ]),
          Row(children: [
            Expanded(flex: 1, child: Text('City', style: Theme.of(context).textTheme.bodyLarge,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(flex: 1, child: _buildTextField(cityEditingController, 'Enter city', 'add-city'))
          ]),
          Row(children: [
            Expanded(flex: 1, child: Text('State', style: Theme.of(context).textTheme.bodyLarge,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(flex: 1, child: _buildTextField(stateEditingController, 'Enter state', 'add-state'))
          ]),
          Row(children: [
            Expanded(flex: 1, child: Text('Country', style: Theme.of(context).textTheme.bodyLarge,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(flex: 1, child: _buildTextField(countryEditingController, 'Enter Country', 'add-country'))
          ]),
          Row(children: [
            Expanded(flex: 1, child: Text('Latitude', style: Theme.of(context).textTheme.bodyLarge,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(flex: 1, child: _buildTextField(latitudeEditingController, 'Enter Latitude', 'add-latitude'))
          ]),
          Row(children: [
            Expanded(flex: 1, child: Text('Longitude', style: Theme.of(context).textTheme.bodyLarge,
                textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
            Expanded(flex: 1, child: _buildTextField(longitudeEditingController, 'Enter Longitude', 'add-longitude'))
          ]),
          Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                WidgetUtils.getRoundedButton(
                    context: context,
                    buttonText: 'Add Mock Location',
                    onTapFunction: () async {
                      final String addressLine = addressLineEditingController.text;
                      final String city = cityEditingController.text;
                      final String state = stateEditingController.text;
                      final String country = countryEditingController.text;
                      final String latStr = latitudeEditingController.text;
                      final String lngStr = longitudeEditingController.text;
                      if (validParams(context, addressLine, state, country, latStr, lngStr)) {
                        final MockLocation mockLocation = MockLocation(
                            id: const Uuid().v1(),
                            addressLine: addressLine,
                            city: city,
                            state: state,
                            country: country,
                            latitude: double.parse(latStr),
                            longitude: double.parse(lngStr));
                        await MockLocationDao.instance.insertMockLocation(mockLocation);
                        _clearTextControllers(addressLineEditingController, stateEditingController,
                            countryEditingController, latitudeEditingController, longitudeEditingController);
                        widget.callback();
                      }
                    })
              ]))
        ]);
  }

  void _clearTextControllers(
      final TextEditingController addressLineEditingController,
      final TextEditingController stateEditingController,
      final TextEditingController countryEditingController,
      final TextEditingController latitudeEditingController,
      final TextEditingController longitudeEditingController) {
    addressLineEditingController.clear();
    stateEditingController.clear();
    countryEditingController.clear();
    latitudeEditingController.clear();
    longitudeEditingController.clear();
  }

  TextField _buildTextField(final textEditingController, final hintString, final pageStorageKey) {
    return TextField(
        controller: textEditingController, // Add this
        style: Theme.of(context).textTheme.bodyLarge,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        enabled: true,
        decoration: InputDecoration(hintText: hintString, hintStyle: Theme.of(context).textTheme.bodyLarge),
        key: PageStorageKey(pageStorageKey),
        onChanged: (v) {
          // _onValueChange();
        });
  }

  bool validParams(final BuildContext context, final String addressLine, final String state, final String country,
      final String latStr, final String lngStr) {
    if (DataUtils.isBlank(addressLine)) {
      WidgetUtils.showToastMessage(context, 'Provide Value for address line');
      return false;
    } else if (DataUtils.isBlank(state)) {
      WidgetUtils.showToastMessage(context, 'Provide Value for state');
      return false;
    } else if (DataUtils.isBlank(country)) {
      WidgetUtils.showToastMessage(context, 'Provide Value for country');
      return false;
    } else if (DataUtils.isBlank(latStr) || !DataUtils.isNumeric(latStr)) {
      WidgetUtils.showToastMessage(context, 'Provide Value for latitude');
      return false;
    } else if (DataUtils.isBlank(latStr) || !DataUtils.isNumeric(lngStr)) {
      WidgetUtils.showToastMessage(context, 'Provide Value for longitude');
      return false;
    } else if (double.parse(latStr) < -90 || double.parse(latStr) > 90) {
      // This check has to be placed, only after previous check of isNumeric is done
      WidgetUtils.showToastMessage(context, 'Provide valid latitude between -90 and 90 degrees');
      return false;
    } else if (double.parse(lngStr) < -180 || double.parse(lngStr) > 180) {
      // This check has to be placed, only after previous check of isNumeric is done
      WidgetUtils.showToastMessage(context, 'Provide valid longitude between -180 and 180 degrees');
      return false;
    }
    {
      return true;
    }
  }
}
