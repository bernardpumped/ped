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
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_feature.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/local/data_fuel_station_features.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/request/end_device_update_fuel_station_feature_request.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/end_device_update_fuel_station_feature_response.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/post_end_device_fuel_station_feature_update.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/reponse-parser/end_device_update_fuel_station_feature_response_parser.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/update-results/update_feature_result.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit_action_buttons_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class EditFeaturesWidget extends StatefulWidget {
  final FuelStation _fuelStation;
  final double _heightHeaderWidget;

  const EditFeaturesWidget(this._fuelStation, this._heightHeaderWidget, {Key? key}) : super(key: key);

  @override
  State<EditFeaturesWidget> createState() => _EditFeaturesWidgetState();
}

class _EditFeaturesWidgetState extends State<EditFeaturesWidget> {
  static const _tag = 'EditFeaturesWidget';

  bool _fabVisible = false;

  final Map<String, bool> referenceFeatureSelectedMap = {};
  final Map<String, bool> featureSelectStatusMap = {};
  Map<String, bool> updatedFeatureSelectStatusMap = {};
  bool _onValueChanged = false;

  @override
  void initState() {
    super.initState();
    _copySelectionStatus();
  }

  void _copySelectionStatus() {
    featureSelectStatusMap.clear();
    final List<FuelStationFeature> fuelStationFeatures = DataFuelStationFeatures.fuelStationFeatures;
    for (var fsf in fuelStationFeatures) {
      referenceFeatureSelectedMap.putIfAbsent(fsf.featureType, () => fsf.selected);
      featureSelectStatusMap.putIfAbsent(fsf.featureType, () => fsf.selected);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _getTitleWidget(),
      const SizedBox(height: 10),
      Stack(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height - widget._heightHeaderWidget,
            child: SingleChildScrollView(child: Column(children: _getFeatureCards()))),
        Positioned(
            bottom: 25,
            right: 25,
            child: Visibility(
                visible: _fabVisible,
                child: EditActionButton(undoButtonAction: _onFeaturesEditUndo, saveButtonAction: _onFeaturesEditSave)))
      ])
    ]);
  }

  _getTitleWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
          Icon(Icons.flag_outlined, size: 30, color: Colors.indigo),
          SizedBox(width: 10),
          Text('Update Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.indigo))
        ]));
  }

  List<Widget> _getFeatureCards() {
    final List<FuelStationFeature> fuelStationFeatures = DataFuelStationFeatures.fuelStationFeatures;
    return fuelStationFeatures
        .map((feature) =>
            Padding(padding: const EdgeInsets.only(left: 8.0, right: 8.0), child: _getFeatureCard(feature)))
        .toList();
  }

  Widget _getFeatureCard(final FuelStationFeature feature) {
    bool val =
        featureSelectStatusMap[feature.featureType] != null ? featureSelectStatusMap[feature.featureType]! : false;
    final Checkbox featureCheckBox = Checkbox(
        value: val,
        checkColor: Colors.indigo,
        onChanged: (val) {
          if (val != null) {
            _valueChangeListenerFunction(feature.featureType, val);
          } else {
            LogUtil.debug(_tag, '_getFeatureCard::ChangeListener had null value');
          }
        },
        activeColor: Colors.white);
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: ListTile(
            leading: Icon(feature.icon, size: 30, color: Colors.indigo),
            title: Text(feature.featureName,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.indigo)),
            trailing: featureCheckBox));
  }

  void _valueChangeListenerFunction(final String featureType, final bool selectStatus) {
    featureSelectStatusMap[featureType] = selectStatus;
    if (selectStatus != referenceFeatureSelectedMap[featureType]) {
      updatedFeatureSelectStatusMap[featureType] = selectStatus;
    } else {
      if (updatedFeatureSelectStatusMap.containsKey(featureType)) {
        updatedFeatureSelectStatusMap.remove(featureType);
      }
    }
    bool showSaveUndoButton = false;
    updatedFeatureSelectStatusMap.forEach((featureTypeKey, selectStatusVal) {
      if (selectStatusVal != referenceFeatureSelectedMap[featureTypeKey]) {
        showSaveUndoButton = true;
      }
    });
    setState(() {
      if (showSaveUndoButton) {
        if (!_onValueChanged) {
          _onValueChanged = true;
        }
      } else {
        if (_onValueChanged) {
          _onValueChanged = false;
        }
      }
      _fabVisible = _onValueChanged;
    });
  }

  _onFeaturesEditUndo() {
    setState(() {
      _copySelectionStatus();
      _onValueChanged = false;
      _fabVisible = _onValueChanged;
    });
  }

  _onFeaturesEditSave() async {
    if (updatedFeatureSelectStatusMap.isNotEmpty) {
      final List<String> enabledFeatures =
          updatedFeatureSelectStatusMap.entries.where((element) => element.value).map((e) => e.key).toList();
      final List<String> disabledFeatures =
          updatedFeatureSelectStatusMap.entries.where((element) => !element.value).map((e) => e.key).toList();
      const Uuid uuid = Uuid();
      final EndDeviceUpdateFuelStationFeatureRequest request = EndDeviceUpdateFuelStationFeatureRequest(
          uuid: uuid.v1(),
          fuelStationId: widget._fuelStation.stationId,
          fuelStationSource: widget._fuelStation.getFuelStationSource(),
          oauthToken: 'my-dummy-oauth-token',
          oauthTokenSecret: 'my-dymmy-oauth-token-secret',
          identityProvider: 'FIREBASE',
          enabledFeatures: enabledFeatures,
          disabledFeatures: disabledFeatures);
      EndDeviceUpdateFuelStationFeatureResponse response;
      try {
        response = await PostEndDeviceFuelStationFeatureUpdate(EndDeviceUpdateFuelStationFeatureResponseParser())
            .execute(request);
      } on Exception catch (e, s) {
        LogUtil.debug(_tag, 'Exception occurred while calling PostEndDeviceFuelStationFeatureUpdate.execute $s');
        response = EndDeviceUpdateFuelStationFeatureResponse(
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
      }
      final dynamic persistUpdateHistoryResult = await _persistUpdateHistory(request, response);
      LogUtil.debug(_tag,
          'endDeviceUpdateFuelStation::updateFuelStationFeature::persistenceResult : $persistUpdateHistoryResult');
      if (!mounted) return;
      final Map<String, dynamic> responseParseMap = _isUpdateSuccessful(response);
      WidgetUtils.showToastMessage(
          context, responseParseMap[_responseMsg], responseParseMap[_isSuccess]! ? Colors.indigo : Colors.red);
      Navigator.pop(context, _getUpdateResponse(request, response));
    }
  }

  UpdateFeatureResult _getUpdateResponse(final EndDeviceUpdateFuelStationFeatureRequest request,
      final EndDeviceUpdateFuelStationFeatureResponse response) {
    return UpdateFeatureResult(true, response.updateEpoch);
  }

  Future<dynamic> _persistUpdateHistory(final EndDeviceUpdateFuelStationFeatureRequest request,
      final EndDeviceUpdateFuelStationFeatureResponse response) {
    final Map<String, bool> originalValues = {};
    final Map<String, bool> updatedValues = {};
    for (var featureType in request.disabledFeatures) {
      originalValues.putIfAbsent(featureType, () => true);
      updatedValues.putIfAbsent(featureType, () => false);
    }
    for (var featureType in request.enabledFeatures) {
      originalValues.putIfAbsent(featureType, () => false);
      updatedValues.putIfAbsent(featureType, () => true);
    }

    final UpdateHistory updateHistory = UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: widget._fuelStation.fuelStationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: response.updateEpoch,
        updateType: UpdateType.fuelStationFeatures.updateTypeName ?? 'UnResolved-UpdateType',
        responseCode: response.responseCode,
        originalValues: originalValues,
        updateValues: updatedValues,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  static const _responseMsg = 'resp-msg';
  static const _isSuccess = 'is-success';

  Map<String, dynamic> _isUpdateSuccessful(final EndDeviceUpdateFuelStationFeatureResponse response) {
    if (response.exceptionCodes != null && response.exceptionCodes!.isNotEmpty) {
      return {_responseMsg: 'Request to update features failed with exceptions', _isSuccess: false};
    }
    if (!response.successfulUpdate) {
      if (response.responseCode == 'CALL-EXCEPTION') {
        return {
          _responseMsg: 'Transient issue happened while updating Features for fuel station. Retry',
          _isSuccess: false
        };
      }
      return {_responseMsg: 'Request to update features failed', _isSuccess: false};
    } else {
      bool exceptionDetected = false;
      response.updateResult?.forEach((addressComponent, updateExceptions) {
        exceptionDetected = exceptionDetected || (updateExceptions as List).isNotEmpty;
      });
      if (exceptionDetected) {
        return {_responseMsg: 'Update request partially failed for some features', _isSuccess: false};
      }
      bool invalidArgumentsDetected = false;
      response.invalidArguments?.forEach((addressComponent, invalidArgs) {
        invalidArgumentsDetected = invalidArgumentsDetected || DataUtils.isNotBlank(invalidArgs);
      });
      if (invalidArgumentsDetected) {
        return {_responseMsg: 'Features found invalid, please refresh / correct before update', _isSuccess: false};
      }
      return {_responseMsg: 'Features successfully updated. Also notified Pumped Team', _isSuccess: true};
    }
  }
}
