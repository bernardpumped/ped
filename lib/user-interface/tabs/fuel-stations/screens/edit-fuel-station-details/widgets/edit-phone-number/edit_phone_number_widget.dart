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
import 'package:pumped_end_device/data/local/dao/update_history_dao.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/post_end_device_fuel_station_update.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/updatable_address_components.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/request/end_device_update_fuel_station_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/end_device_update_fuel_station_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/reponse-parser/end_device_update_fuel_station_response_parser.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_phone_number_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/edit_widget_expansion_tile.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/save_undo_button_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-phone-number/edit_phone_number_line_item.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../fonts_and_colors.dart';

class EditPhoneNumberWidget extends StatefulWidget {
  final Function setStateFunction;
  final Function isWidgetExpanded;
  final String phone1;
  final String phone2;
  final String fuelStationSource;
  final String fuelStationName;
  final int fuelStationId;

  const EditPhoneNumberWidget(this.setStateFunction, this.isWidgetExpanded, this.phone1, this.phone2, this.fuelStationSource,
      this.fuelStationId, this.fuelStationName, {Key key}) : super(key: key);

  @override
  _EditPhoneNumberWidgetState createState() => _EditPhoneNumberWidgetState();
}

class _EditPhoneNumberWidgetState extends State<EditPhoneNumberWidget> {
  static const _tag = 'EditPhoneNumberWidget';
  static const _phone1Title = "Phone 1";
  static const _phone2Title = "Phone 2";

  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  String _enteredPhone1Value;
  String _enteredPhone2Value;
  bool _onValueChanged = false;
  bool _backendUpdateInProgress = false;

  @override
  void initState() {
    super.initState();
    _enteredPhone1Value = widget.phone1;
    _enteredPhone2Value = widget.phone2;
  }

  static const addressDetailsIcon = Icon(IconData(IconCodes.phoneIconCode, fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: FontsAndColors.pumpedNonActionableIconColor, size: 30);

  @override
  Widget build(final BuildContext context) {
    return EditWidgetExpansionTile(addressDetailsIcon, 'Phone Number', 'phone-number',
        _editPhoneNumberExpansionTileWidgetTree(), widget.isWidgetExpanded, widget.setStateFunction);
  }

  List<Widget> _editPhoneNumberExpansionTileWidgetTree() {
    List<Widget> columnContent = [];
    columnContent.add(EditPhoneNumberLineItem(
        _phone1Title, widget.phone1, _phone1Controller, _onValueChangedListener, _backendUpdateInProgress));
    columnContent.add(EditPhoneNumberLineItem(
        _phone2Title, widget.phone2, _phone2Controller, _onValueChangedListener, _backendUpdateInProgress));
    columnContent.add(Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: SaveUndoButtonWidget(
            onSave: onSaveAction,
            onCancel: onUndoAction,
            onValueChange: _onValueChanged,
            saveButtonDisabled: _backendUpdateInProgress,
            undoButtonDisabled: _backendUpdateInProgress)));
    return columnContent;
  }

  void _onValueChangedListener(final String phoneFieldTitle, final String enteredValue) {
    if (_phone1Title == phoneFieldTitle) {
      if (DataUtils.isValidNumber(enteredValue)) {
        _enteredPhone1Value = enteredValue;
      }
    }
    if (_phone2Title == phoneFieldTitle) {
      if (DataUtils.isValidNumber(enteredValue)) {
        _enteredPhone2Value = enteredValue;
      }
    }
    LogUtil.debug(_tag, 'Phone 1 different ${DataUtils.stringEqual(_enteredPhone1Value, widget.phone1, true)}');
    LogUtil.debug(_tag, 'Phone 2 different ${DataUtils.stringEqual(_enteredPhone2Value, widget.phone2, true)}');

    final bool showSaveUndoButton = !DataUtils.stringEqual(_enteredPhone1Value, widget.phone1, true) ||
        !DataUtils.stringEqual(_enteredPhone2Value, widget.phone2, true);
    LogUtil.debug(_tag, 'Entered Val1 $_enteredPhone1Value');
    if (showSaveUndoButton) {
      if (!_onValueChanged) {
        setState(() {
          _onValueChanged = true;
        });
      }
    } else {
      if (_onValueChanged) {
        setState(() {
          _onValueChanged = false;
        });
      }
    }
  }

  void onSaveAction() async {
    var uuid = const Uuid();
    final Map<String, dynamic> updatePathAndValues = {};
    final Map<String, dynamic> originalPathAndValues = {};
    bool _phone1InputValid = true;
    bool _phone2InputValid = true;
    if (_enteredPhone1Value != widget.phone1) {
      _phone1InputValid = DataUtils.isValidNumber(_enteredPhone1Value);
      if (_phone1InputValid) {
        originalPathAndValues.putIfAbsent(UpdatableAddressComponents.phone1, () => widget.phone1);
        updatePathAndValues.putIfAbsent(UpdatableAddressComponents.phone1, () => _enteredPhone1Value);
      }
    }
    if (_enteredPhone2Value != widget.phone2) {
      _phone2InputValid = DataUtils.isValidNumber(_enteredPhone2Value);
      if (_phone2InputValid) {
        originalPathAndValues.putIfAbsent(UpdatableAddressComponents.phone2, () => widget.phone2);
        updatePathAndValues.putIfAbsent(UpdatableAddressComponents.phone2, () => _enteredPhone2Value);
      }
    }
    LogUtil.debug(_tag, '_phone1InputValid $_phone1InputValid _phone2InputValid $_phone2InputValid');
    if (!_phone1InputValid || !_phone2InputValid) {
      setState(() {});
      if (!_phone1InputValid && !_phone2InputValid) {
        WidgetUtils.showToastMessage(context, 'Invalid Phone 1 and Phone 2', Colors.red);
      } else if (!_phone1InputValid) {
        WidgetUtils.showToastMessage(context, 'Invalid Phone 1', Colors.red);
      } else {
        WidgetUtils.showToastMessage(context, 'Invalid Phone 2', Colors.red);
      }
      return;
    }
    if (updatePathAndValues.isNotEmpty) {
      final EndDeviceUpdateFuelStationRequest request = EndDeviceUpdateFuelStationRequest(
          updatePathAndValues: updatePathAndValues,
          uuid: uuid.v1(),
          fuelStationSource: widget.fuelStationSource,
          fuelStationId: widget.fuelStationId,
          identityProvider: 'FIREBASE',
          oauthToken: 'my-dummy-oath-token',
          oauthTokenSecret: 'my-dummy-oauth-token-secret');
      EndDeviceUpdateFuelStationResponse response;
      try {
        lockInputs();
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
        unlockInputs();
      }
      final int persistUpdateHistoryResult = await _persistUpdateHistory(request, response, originalPathAndValues);
      LogUtil.debug(
          _tag, 'endDeviceUpdateFuelStation::updatePhoneNum::persistenceResult : $persistUpdateHistoryResult');
      if (response.responseCode == 'SUCCESS') {
        WidgetUtils.showToastMessage(
            context, 'Updated phone number notified to pumped team', Theme.of(context).primaryColor);
      } else {
        WidgetUtils.showToastMessage(context, 'Error notifying update to pumped team', Theme.of(context).primaryColor);
      }
      Navigator.pop(context, _getUpdateResponse(request, response));
    }
  }

  Future<int> _persistUpdateHistory(final EndDeviceUpdateFuelStationRequest request,
      final EndDeviceUpdateFuelStationResponse response, final Map<String, dynamic> originalPathAndValues) {
    final UpdateHistory updateHistory = UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: widget.fuelStationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: response.updateEpoch,
        updateType: UpdateType.phoneNumber.updateTypeName,
        responseCode: response.responseCode,
        originalValues: originalPathAndValues,
        updateValues: request.updatePathAndValues,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  void onUndoAction() {
    _phone1Controller.clear();
    _phone2Controller.clear();
    setState(() {
      _onValueChanged = false;
      _enteredPhone1Value = widget.phone1;
      _enteredPhone2Value = widget.phone2;
    });
  }

  void lockInputs() {
    LogUtil.debug(_tag, 'locking the inputs');
    setState(() {
      _backendUpdateInProgress = true;
    });
  }

  void unlockInputs() {
    LogUtil.debug(_tag, 'unlocking the inputs');
    setState(() {
      _backendUpdateInProgress = false;
      _onValueChanged = false;
    });
  }

  UpdatePhoneNumberResult _getUpdateResponse(
      final EndDeviceUpdateFuelStationRequest request, final EndDeviceUpdateFuelStationResponse response) {
    return UpdatePhoneNumberResult(response.successfulUpdate, response.updateEpoch,
        phoneTypeUpdateStatusMap: response.updateResult, phoneTypeNewValueMap: request.updatePathAndValues);
  }
}
