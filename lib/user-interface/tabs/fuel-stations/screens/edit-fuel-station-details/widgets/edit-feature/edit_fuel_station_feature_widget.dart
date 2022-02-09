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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/post_end_device_fuel_station_feature_update.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/request/end_device_update_fuel_station_feature_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/end_device_update_fuel_station_feature_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/reponse-parser/end_device_update_fuel_station_feature_response_parser.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_feature_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/save_undo_button_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-feature/data_fuel_station_features.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_feature.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class EditFuelStationFeatureWidget extends StatefulWidget {
  final String _titleText;
  final String _widgetKey;
  final FuelStation _fuelStation;
  final String _fuelStationSource;
  final Function _widgetExpanded;
  final Function _setStateFunction;
  final Icon _leadingWidgetIcon;

  const EditFuelStationFeatureWidget(this._titleText, this._widgetKey, this._fuelStation,
      this._fuelStationSource, this._widgetExpanded, this._setStateFunction, this._leadingWidgetIcon, {Key key}) : super(key: key);

  @override
  _EditFuelStationFeatureWidgetState createState() => _EditFuelStationFeatureWidgetState();
}

class _EditFuelStationFeatureWidgetState extends State<EditFuelStationFeatureWidget> {
  static const _tag = 'EditFuelStationFeatureWidget';
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
    final theme = Theme.of(context).copyWith(backgroundColor: Colors.white);
    var title =
        Text(widget._titleText, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500));
    return Theme(
        data: theme,
        child: ExpansionTile(
            initiallyExpanded: widget._widgetExpanded(),
            leading: widget._leadingWidgetIcon,
            title: title,
            key: PageStorageKey<String>(widget._widgetKey),
            children: [
              _getFuelStationFeatures(),
              Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SaveUndoButtonWidget(
                      onCancel: onUndoOperation, onSave: onSaveOperation, onValueChange: _onValueChanged))
            ],
            onExpansionChanged: (expanded) {
              setState(() {
                widget._setStateFunction(expanded);
              });
            }));
  }

  _getFuelStationFeatures() {
    final List<FuelStationFeature> fuelStationFeatures = DataFuelStationFeatures.fuelStationFeatures;
    return Container(
      decoration: const BoxDecoration(color: Color(0x33eeeeee)),
      height: 190,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 20),
      child: GridView.count(
          key: const PageStorageKey<String>('fuel-station-features'),
          crossAxisCount: 3,
          scrollDirection: Axis.horizontal,
          childAspectRatio: .4,
          children: List.generate(fuelStationFeatures.length, (index) {
            return _getFeatureCard(fuelStationFeatures[index]);
          })),
    );
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
    });
  }

  Widget _getFeatureCard(final FuelStationFeature fuelStationFeature) {
    final Checkbox featureCheckBox = Checkbox(
        value: featureSelectStatusMap[fuelStationFeature.featureType],
        checkColor: Colors.teal,
        onChanged: (val) {
          _valueChangeListenerFunction(fuelStationFeature.featureType, val);
        },
        activeColor: Colors.white);
    return Card(
        child: Container(
            padding: const EdgeInsets.all(7),
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Expanded(
                  flex: 3,
                  child: fuelStationFeature.icon
                ),
              Expanded(
                  flex: 5,
                  child: Text(fuelStationFeature.featureName,
                      overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87))),
              Expanded(flex: 2, child: featureCheckBox)
            ])));
  }

  void onSaveOperation() async {
    if (updatedFeatureSelectStatusMap.isNotEmpty) {
      final List<String> enabledFeatures =
          updatedFeatureSelectStatusMap.entries.where((element) => element.value).map((e) => e.key).toList();
      final List<String> disabledFeatures =
          updatedFeatureSelectStatusMap.entries.where((element) => !element.value).map((e) => e.key).toList();
      const Uuid uuid = Uuid();
      final EndDeviceUpdateFuelStationFeatureRequest request = EndDeviceUpdateFuelStationFeatureRequest(
          uuid: uuid.v1(),
          fuelStationId: widget._fuelStation.stationId,
          fuelStationSource: widget._fuelStationSource,
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
      final int persistUpdateHistoryResult = await _persistUpdateHistory(request, response);
      LogUtil.debug(_tag,
          'endDeviceUpdateFuelStation::updateFuelStationFeature::persistenceResult : $persistUpdateHistoryResult');
      if (response.responseCode == 'SUCCESS') {
        WidgetUtils.showToastMessage(
            context, 'Updated fuel station features notified to pumped team', Theme.of(context).primaryColor);
      } else {
        WidgetUtils.showToastMessage(context, 'Error notifying update to pumped team', Theme.of(context).primaryColor);
      }
      Navigator.pop(context, _getUpdateResponse(request, response));
    }
  }

  void onUndoOperation() {
    setState(() {
      _copySelectionStatus();
      _onValueChanged = false;
    });
  }

  Future<int> _persistUpdateHistory(final EndDeviceUpdateFuelStationFeatureRequest request,
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
        updateType: UpdateType.fuelStationFeatures.updateTypeName,
        responseCode: response.responseCode,
        originalValues: originalValues,
        updateValues: updatedValues,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  UpdateFeatureResult _getUpdateResponse(final EndDeviceUpdateFuelStationFeatureRequest request,
      final EndDeviceUpdateFuelStationFeatureResponse response) {
    return UpdateFeatureResult(true, response.updateEpoch);
  }
}
