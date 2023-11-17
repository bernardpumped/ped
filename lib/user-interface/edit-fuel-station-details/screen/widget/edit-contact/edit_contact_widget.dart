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
import 'package:pumped_end_device/data/local/dao2/update_history_dao.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/request/end_device_update_fuel_station_request.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/end_device_update_fuel_station_response.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/post_end_device_fuel_station_update.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/reponse-parser/end_device_update_fuel_station_response_parser.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/updatable_address_components.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/update-results/update_address_details_result.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-contact/edit_fuel_station_address_line_item.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-contact/edit_phone_number_line_item.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit_action_buttons_widget.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class EditContactWidget extends StatefulWidget {
  final EditFuelStationDetailsParams _params;
  final double _heightHeaderWidget;

  const EditContactWidget(this._params, this._heightHeaderWidget, {Key? key}) : super(key: key);

  @override
  State<EditContactWidget> createState() => _EditContactWidgetState();
}

class _EditContactWidgetState extends State<EditContactWidget> {
  static const _tag = 'EditContactWidget';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();

  bool _fabVisible = false;
  bool _backendUpdateInProgress = false;

  String? _enteredName;
  String? _enteredAddress;
  String? _enteredLocality;
  String? _enteredRegion;
  String? _enteredState;
  String? _enteredZip;
  String? _enteredPhone1;
  String? _enteredPhone2;

  late FuelStation _fuelStation;

  @override
  void initState() {
    super.initState();
    _fuelStation = widget._params.fuelStation;
    final FuelStationAddress fuelStationAddress = _fuelStation.fuelStationAddress;
    _enteredName = fuelStationAddress.contactName;
    _enteredAddress = fuelStationAddress.addressLine1;
    _enteredLocality = fuelStationAddress.locality;
    _enteredRegion = fuelStationAddress.region;
    _enteredState = fuelStationAddress.state;
    _enteredZip = fuelStationAddress.zip;
    _enteredPhone1 = fuelStationAddress.phone1;
    _enteredPhone2 = fuelStationAddress.phone2;
  }

  @override
  Widget build(final BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _getTitleWidget(),
      const SizedBox(height: 10),
      Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height - widget._heightHeaderWidget,
            child: SingleChildScrollView(child: _buildFutureBuilder())),
        Positioned(
            bottom: 25,
            right: 25,
            child: Visibility(
                visible: _fabVisible,
                child: EditActionButton(
                    undoButtonAction: _onContactChangeUndo, saveButtonAction: _onAddressChangeSave, tag: _tag)))
      ])
    ]);
  }

  _getTitleWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(Icons.location_city, size: 30),
          const SizedBox(width: 10),
          Text('Update Contact Details', style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
        ]));
  }

  _updateFabVisibility(bool showFab) {
    setState(() {
      _fabVisible = showFab;
    });
  }

  _buildFutureBuilder() {
    final FuelStationAddress fuelStationAddress = _fuelStation.fuelStationAddress;
    List<Widget> columnContent = [];
    columnContent.add(EditFuelStationAddressLineItem('Name', UpdatableAddressComponents.stationName,
        fuelStationAddress.contactName, _nameController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Address', UpdatableAddressComponents.addressLine,
        fuelStationAddress.addressLine1, _addressController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Locality', UpdatableAddressComponents.locality,
        fuelStationAddress.locality, _localityController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Region', UpdatableAddressComponents.region, fuelStationAddress.region,
        _regionController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('State', UpdatableAddressComponents.state, fuelStationAddress.state,
        _stateController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Zip', UpdatableAddressComponents.zip, fuelStationAddress.zip,
        _zipController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditPhoneNumberLineItem('Phone 1', UpdatableAddressComponents.phone1, fuelStationAddress.phone1,
        _phone1Controller, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditPhoneNumberLineItem('Phone 2', UpdatableAddressComponents.phone2, fuelStationAddress.phone2,
        _phone2Controller, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(Container(height: 100));
    return Column(children: columnContent);
  }

  void _onValueChangeListener(
      final String addressComponentType, final String enteredValue, final String? originalValue) {
    if (DataUtils.isNotBlank(enteredValue) || enteredValue != originalValue) {
      switch (addressComponentType) {
        case UpdatableAddressComponents.stationName:
          _enteredName = enteredValue;
          break;
        case UpdatableAddressComponents.addressLine:
          _enteredAddress = enteredValue;
          break;
        case UpdatableAddressComponents.locality:
          _enteredLocality = enteredValue;
          break;
        case UpdatableAddressComponents.region:
          _enteredRegion = enteredValue;
          break;
        case UpdatableAddressComponents.state:
          _enteredState = enteredValue;
          break;
        case UpdatableAddressComponents.zip:
          _enteredZip = enteredValue;
          break;
        case UpdatableAddressComponents.phone1:
          _enteredPhone1 = enteredValue;
          break;
        case UpdatableAddressComponents.phone2:
          _enteredPhone2 = enteredValue;
          break;
      }
    }
    final FuelStationAddress fuelStationAddress = _fuelStation.fuelStationAddress;

    final bool showSaveUndoButton = !DataUtils.stringEqual(_enteredName, fuelStationAddress.contactName, true) ||
        !DataUtils.stringEqual(_enteredAddress, fuelStationAddress.addressLine1, true) ||
        !DataUtils.stringEqual(_enteredLocality, fuelStationAddress.locality, true) ||
        !DataUtils.stringEqual(_enteredRegion, fuelStationAddress.region, true) ||
        !DataUtils.stringEqual(_enteredState, fuelStationAddress.state, true) ||
        !DataUtils.stringEqual(_enteredZip, fuelStationAddress.zip, true) ||
        !DataUtils.stringEqual(_enteredPhone1, fuelStationAddress.phone1, true) ||
        !DataUtils.stringEqual(_enteredPhone2, fuelStationAddress.phone2, true);

    _updateFabVisibility(showSaveUndoButton);
  }

  _onContactChangeUndo() {
    _nameController.clear();
    _addressController.clear();
    _localityController.clear();
    _regionController.clear();
    _stateController.clear();
    _zipController.clear();
    _phone1Controller.clear();
    _phone2Controller.clear();
    _updateFabVisibility(false);
  }

  _onAddressChangeSave() async {
    var uuid = const Uuid();
    final FuelStationAddress fuelStationAddress = _fuelStation.fuelStationAddress;
    final Map<String, dynamic> updatePathAndValues = {};
    final Map<String, dynamic> originalPathAndValues = {};
    List<String> invalidInputs = [];
    _recordChanges(_enteredName, fuelStationAddress.contactName, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.stationName, invalidInputs);
    _recordChanges(_enteredAddress, fuelStationAddress.addressLine1, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.addressLine, invalidInputs);
    _recordChanges(_enteredLocality, fuelStationAddress.locality, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.locality, invalidInputs);
    _recordChanges(_enteredRegion, fuelStationAddress.region, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.region, invalidInputs);
    _recordChanges(_enteredState, fuelStationAddress.state, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.state, invalidInputs);
    _recordChanges(_enteredZip, fuelStationAddress.zip, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.zip, invalidInputs);
    _recordChanges(_enteredPhone1, fuelStationAddress.phone1, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.phone1, invalidInputs);
    _recordChanges(_enteredPhone2, fuelStationAddress.phone2, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.phone2, invalidInputs);

    if (invalidInputs.isNotEmpty) {
      setState(() {});
      final String invalidInputMsg = invalidInputs.join(', ');
      WidgetUtils.showToastMessage(context, invalidInputMsg, isErrorToast: true);
      return;
    } else {
      if (updatePathAndValues.isNotEmpty) {
        final EndDeviceUpdateFuelStationRequest request = EndDeviceUpdateFuelStationRequest(
            updatePathAndValues: updatePathAndValues,
            uuid: uuid.v1(),
            fuelStationSource: _fuelStation.getFuelStationSource(),
            fuelStationId: _fuelStation.stationId,
            identityProvider: 'FIREBASE',
            oauthToken: widget._params.oauthToken,
            oauthTokenSecret: '');
        EndDeviceUpdateFuelStationResponse response;
        try {
          _lockInputs();
          response = await PostEndDeviceFuelStationUpdate(EndDeviceUpdateFuelStationResponseParser()).execute(request);
        } on Exception catch (e, s) {
          LogUtil.debug(_tag, 'Exception occurred while calling PostEndDeviceFuelStationUpdate.execute $s');
          response = EndDeviceUpdateFuelStationResponse(
              responseCode: 'CALL-EXCEPTION',
              responseDetails: s.toString(),
              invalidArguments: {},
              responseEpoch: DateTime.now().millisecondsSinceEpoch,
              exceptionCodes: [],
              updateResult: {},
              fuelStationId: request.fuelStationId,
              fuelStationSource: request.fuelStationSource,
              updateEpoch: DateTime.now().millisecondsSinceEpoch,
              uuid: request.uuid,
              successfulUpdate: false);
        } finally {
          _unlockInputs();
        }

        final dynamic persistUpdateHistoryResult =
            await _persistUpdateHistory(request, response, originalPathAndValues);
        LogUtil.debug(
            _tag, 'endDeviceUpdateFuelStation::updateAddress::persistenceResult : $persistUpdateHistoryResult');
        if (!mounted) return;
        final Map<String, dynamic> responseParseMap = _isUpdateSuccessful(response);
        WidgetUtils.showToastMessage(context, responseParseMap[_responseMsg],
            isErrorToast: !responseParseMap[_isSuccess]!);
        Navigator.pop(context, _getUpdateResponse(request, response, originalPathAndValues));
      }
    }
  }

  static const _responseMsg = 'resp-msg';
  static const _isSuccess = 'is-success';

  Map<String, dynamic> _isUpdateSuccessful(final EndDeviceUpdateFuelStationResponse response) {
    if (response.exceptionCodes != null && response.exceptionCodes!.isNotEmpty) {
      return {_responseMsg: 'Request to update contact details failed with exceptions', _isSuccess: false};
    }
    if (!response.successfulUpdate) {
      if (response.responseCode == 'CALL-EXCEPTION') {
        return {_responseMsg: 'Transient issue occurred while updating Contact Details, please retry', _isSuccess: false};
      }
      return {_responseMsg: 'Request to update contact details failed', _isSuccess: false};
    } else {
      bool exceptionDetected = false;
      response.updateResult?.forEach((addressComponent, updateExceptions) {
        exceptionDetected = exceptionDetected || (updateExceptions as List).isNotEmpty;
      });
      if (exceptionDetected) {
        return {_responseMsg: 'Update request partially failed for a address components', _isSuccess: false};
      }
      bool invalidArgumentsDetected = false;
      response.invalidArguments?.forEach((addressComponent, invalidArgs) {
        invalidArgumentsDetected = invalidArgumentsDetected || DataUtils.isNotBlank(invalidArgs);
      });
      if (invalidArgumentsDetected) {
        return {
          _responseMsg: 'Address components found invalid, please refresh / correct before update',
          _isSuccess: false
        };
      }
      return {_responseMsg: 'Address components successfully updated. Also notified Pumped Team', _isSuccess: true};
    }
  }

  void _recordChanges(
      final String? newValue,
      final String? originalValue,
      final Map<String, dynamic> originalPathAndValues,
      final Map<String, dynamic> updatePathAndValues,
      final String mapKey,
      final List<String> invalidInputs) {
    bool valueChanged = !DataUtils.stringEqual(newValue, originalValue, true);
    if (valueChanged) {
      if (isValidInput(newValue)) {
        originalPathAndValues.putIfAbsent(mapKey, () => originalValue);
        updatePathAndValues.putIfAbsent(mapKey, () => newValue);
      } else {
        invalidInputs.add(mapKey);
      }
    }
  }

  bool isValidInput(final String? input) {
    return DataUtils.isNotBlank(input);
  }

  void _lockInputs() {
    setState(() {
      _backendUpdateInProgress = true;
    });
  }

  void _unlockInputs() {
    setState(() {
      _backendUpdateInProgress = false;
    });
  }

  Future<dynamic> _persistUpdateHistory(final EndDeviceUpdateFuelStationRequest request,
      final EndDeviceUpdateFuelStationResponse response, final Map<String, dynamic> originalPathAndValues) {
    int updateEpoch = response.updateEpoch;
    if (response.updateEpoch > 1700000000) {
      //Ths is interim, till the Pumped fix is not pushed back.
      updateEpoch = response.updateEpoch ~/ 1000;
    }
    final UpdateHistory updateHistory = UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: _fuelStation.fuelStationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: updateEpoch,
        updateType: UpdateType.addressDetails.updateTypeName!,
        responseCode: response.responseCode,
        originalValues: originalPathAndValues,
        updateValues: request.updatePathAndValues,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  UpdateAddressDetailsResult _getUpdateResponse(final EndDeviceUpdateFuelStationRequest request,
      final EndDeviceUpdateFuelStationResponse response, final Map<String, dynamic> originalPathAndValues) {
    int updateEpoch = response.updateEpoch;
    if (response.updateEpoch > 1700000000) {
      //Ths is interim, till the Pumped fix is not pushed back.
      updateEpoch = response.updateEpoch ~/ 1000;
    }
    return UpdateAddressDetailsResult(response.successfulUpdate, updateEpoch,
        addressComponentUpdateStatus: response.updateResult, addressComponentNewValue: request.updatePathAndValues);
  }
}
