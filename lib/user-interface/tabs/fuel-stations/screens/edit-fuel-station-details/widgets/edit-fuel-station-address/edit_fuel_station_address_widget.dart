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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/update_history_dao.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/post_end_device_fuel_station_update.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/updatable_address_components.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/request/end_device_update_fuel_station_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/end_device_update_fuel_station_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/reponse-parser/end_device_update_fuel_station_response_parser.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_address_details_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/edit_widget_expansion_tile.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/save_undo_button_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-fuel-station-address/edit_fuel_station_address_line_item.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../fonts_and_colors.dart';

class EditFuelStationAddressWidget extends StatefulWidget {
  final Function setStateFunction;
  final Function isWidgetExpanded;
  final FuelStationAddress _fuelStationAddress;
  final String stationName;
  final int _fuelStationId;
  final String _fuelStationSource;

  EditFuelStationAddressWidget(this.setStateFunction, this.isWidgetExpanded, this._fuelStationAddress,
      this._fuelStationId, this.stationName, this._fuelStationSource);

  @override
  _EditFuelStationAddressWidgetState createState() => _EditFuelStationAddressWidgetState();
}

class _EditFuelStationAddressWidgetState extends State<EditFuelStationAddressWidget> {
  static const _TAG = 'EditFuelStationAddressWidget';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  String _enteredName;
  String _enteredAddress;
  String _enteredLocality;
  String _enteredRegion;
  String _enteredState;
  String _enteredZip;

  bool _onValueChange = false;
  bool _backendUpdateInProgress = false;

  @override
  void initState() {
    super.initState();
    _enteredName = widget._fuelStationAddress.contactName;
    _enteredAddress = widget._fuelStationAddress.addressLine1;
    _enteredLocality = widget._fuelStationAddress.locality;
    _enteredRegion = widget._fuelStationAddress.region;
    _enteredState = widget._fuelStationAddress.state;
    _enteredZip = widget._fuelStationAddress.zip;
  }

  static const addressDetailsIcon = const Icon(IconData(IconCodes.address_details_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: FontsAndColors.pumpedNonActionableIconColor, size: 30);

  @override
  Widget build(final BuildContext context) {
    return EditWidgetExpansionTile(addressDetailsIcon, 'Address Details', 'address-details',
        _editAddressExpansionTileWidgetTree(), widget.isWidgetExpanded, widget.setStateFunction);
  }

  bool isValidInput(final String input) {
    return DataUtils.isNotBlank(input);
  }

  void _recordChanges(
      final String newValue,
      final String originalValue,
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

  void onSaveOperation() async {
    var uuid = Uuid();
    final Map<String, dynamic> updatePathAndValues = {};
    final Map<String, dynamic> originalPathAndValues = {};
    List<String> invalidInputs = [];
    _recordChanges(_enteredName, widget._fuelStationAddress.contactName, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.STATION_NAME, invalidInputs);
    _recordChanges(_enteredAddress, widget._fuelStationAddress.addressLine1, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.ADDRESS_LINE, invalidInputs);
    _recordChanges(_enteredLocality, widget._fuelStationAddress.locality, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.LOCALITY, invalidInputs);
    _recordChanges(_enteredRegion, widget._fuelStationAddress.region, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.REGION, invalidInputs);
    _recordChanges(_enteredState, widget._fuelStationAddress.state, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.STATE, invalidInputs);
    _recordChanges(_enteredZip, widget._fuelStationAddress.zip, originalPathAndValues, updatePathAndValues,
        UpdatableAddressComponents.ZIP, invalidInputs);
    if (invalidInputs.length > 0) {
      setState(() {});
      final String invalidInputMsg = invalidInputs.join(', ');
      WidgetUtils.showToastMessage(context, invalidInputMsg, Colors.red);
      return;
    } else {
      if (updatePathAndValues.length > 0) {
        final EndDeviceUpdateFuelStationRequest request = EndDeviceUpdateFuelStationRequest(
            updatePathAndValues: updatePathAndValues,
            uuid: uuid.v1(),
            fuelStationSource: widget._fuelStationSource,
            fuelStationId: widget._fuelStationId,
            identityProvider: 'FIREBASE',
            oauthToken: 'my-dummy-oath-token',
            oauthTokenSecret: 'my-dummy-oauth-token-secret');
        EndDeviceUpdateFuelStationResponse response;
        try {
          _lockInputs();
          response = await PostEndDeviceFuelStationUpdate(EndDeviceUpdateFuelStationResponseParser()).execute(request);
        } on Exception catch (e, s) {
          LogUtil.debug(_TAG, 'Exception occurred while calling PostEndDeviceFuelStationUpdate.execute $s');
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

        final int persistUpdateHistoryResult = await _persistUpdateHistory(request, response, originalPathAndValues);
        LogUtil.debug(
            _TAG, 'endDeviceUpdateFuelStation::updateAddress::persistenceResult : $persistUpdateHistoryResult');
        if (response.responseCode == 'SUCCESS') {
          WidgetUtils.showToastMessage(
              context, 'Updated Address Details notified to pumped team', Theme.of(context).primaryColor);
        } else {
          WidgetUtils.showToastMessage(
              context, 'Error notifying update to pumped team', Theme.of(context).primaryColor);
        }
        Navigator.pop(context, _getUpdateResponse(request, response, originalPathAndValues));
      }
    }
  }

  Future<int> _persistUpdateHistory(final EndDeviceUpdateFuelStationRequest request,
      final EndDeviceUpdateFuelStationResponse response, final Map<String, dynamic> originalPathAndValues) {
    final UpdateHistory updateHistory = new UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: widget.stationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: response.updateEpoch,
        updateType: UpdateType.ADDRESS_DETAILS.updateTypeName,
        responseCode: response.responseCode,
        originalValues: originalPathAndValues,
        updateValues: request.updatePathAndValues,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  List<Widget> _editAddressExpansionTileWidgetTree() {
    List<Widget> columnContent = [];
    columnContent.add(EditFuelStationAddressLineItem('Name', UpdatableAddressComponents.STATION_NAME,
        widget._fuelStationAddress.contactName, _nameController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Address', UpdatableAddressComponents.ADDRESS_LINE,
        widget._fuelStationAddress.addressLine1, _addressController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Locality', UpdatableAddressComponents.LOCALITY,
        widget._fuelStationAddress.locality, _localityController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Region', UpdatableAddressComponents.REGION,
        widget._fuelStationAddress.region, _regionController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('State', UpdatableAddressComponents.STATE,
        widget._fuelStationAddress.state, _stateController, _backendUpdateInProgress, _onValueChangeListener));
    columnContent.add(EditFuelStationAddressLineItem('Zip', UpdatableAddressComponents.ZIP,
        widget._fuelStationAddress.region, _zipController, _backendUpdateInProgress, _onValueChangeListener));

    columnContent.add(SaveUndoButtonWidget(
        onSave: onSaveOperation,
        onCancel: onCancelOperation,
        onValueChange: _onValueChange,
        saveButtonDisabled: _backendUpdateInProgress,
        undoButtonDisabled: _backendUpdateInProgress));
    return columnContent;
  }

  void _onValueChangeListener(
      final String addressComponentType, final String enteredValue, final String originalValue) {
    if (DataUtils.isNotBlank(enteredValue) || enteredValue == originalValue) {
      switch (addressComponentType) {
        case UpdatableAddressComponents.STATION_NAME:
          _enteredName = enteredValue;
          break;
        case UpdatableAddressComponents.ADDRESS_LINE:
          _enteredAddress = enteredValue;
          break;
        case UpdatableAddressComponents.LOCALITY:
          _enteredLocality = enteredValue;
          break;
        case UpdatableAddressComponents.REGION:
          _enteredRegion = enteredValue;
          break;
        case UpdatableAddressComponents.STATE:
          _enteredState = enteredValue;
          break;
        case UpdatableAddressComponents.ZIP:
          _enteredZip = enteredValue;
          break;
      }
    }

    final bool showSaveUndoButton =
        !DataUtils.stringEqual(_enteredName, widget._fuelStationAddress.contactName, true) ||
            !DataUtils.stringEqual(_enteredAddress, widget._fuelStationAddress.addressLine1, true) ||
            !DataUtils.stringEqual(_enteredLocality, widget._fuelStationAddress.locality, true) ||
            !DataUtils.stringEqual(_enteredRegion, widget._fuelStationAddress.region, true) ||
            !DataUtils.stringEqual(_enteredState, widget._fuelStationAddress.state, true) ||
            !DataUtils.stringEqual(_enteredZip, widget._fuelStationAddress.zip, true);

    if (showSaveUndoButton) {
      if (!_onValueChange) {
        setState(() {
          _onValueChange = true;
        });
      }
    } else {
      if (_onValueChange) {
        setState(() {
          _onValueChange = false;
        });
      }
    }
  }

  void onCancelOperation() {
    _nameController.clear();
    _addressController.clear();
    _localityController.clear();
    _regionController.clear();
    _stateController.clear();
    _zipController.clear();
    setState(() {
      _onValueChange = false;
    });
  }

  void _lockInputs() {
    setState(() {
      _backendUpdateInProgress = true;
    });
  }

  void _unlockInputs() {
    setState(() {
      _backendUpdateInProgress = false;
      _onValueChange = false;
    });
  }

  UpdateAddressDetailsResult _getUpdateResponse(final EndDeviceUpdateFuelStationRequest request,
      final EndDeviceUpdateFuelStationResponse response, final Map<String, dynamic> originalPathAndValues) {
    return new UpdateAddressDetailsResult(response.successfulUpdate, response.updateEpoch,
        addressComponentUpdateStatus: response.updateResult != null ? response.updateResult : {},
        addressComponentNewValue: request.updatePathAndValues != null ? request.updatePathAndValues : {});
  }
}
