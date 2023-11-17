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
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/request/suggest_edit_request.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/suggest_edit_response.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/post_suggest_edit.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/reponse-parser/suggest_edit_response_parser.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/update-results/update_suggestion_result.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit_action_buttons_widget.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_type_attributes.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class SuggestEditWidget extends StatefulWidget {
  final EditFuelStationDetailsParams _params;
  final double _heightHeaderWidget;

  const SuggestEditWidget(this._params, this._heightHeaderWidget, {super.key});

  @override
  State<SuggestEditWidget> createState() => _SuggestEditWidgetState();
}

class _SuggestEditWidgetState extends State<SuggestEditWidget> {
  static const _tag = 'SuggestEditWidget';
  final TextEditingController _suggestEditTextEditingController = TextEditingController();
  bool _onValueChanged = false;
  bool _backendUpdateInProgress = false;
  bool _inputSuggestionValid = true;

  bool _fabVisible = false;
  String? _suggestion;
  late FuelStation _fuelStation;

  @override
  void initState() {
    super.initState();
    _fuelStation = widget._params.fuelStation;
  }

  @override
  Widget build(final BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _getTitleWidget(),
      const SizedBox(height: 10),
      Stack(children: [
        SizedBox(height: MediaQuery.of(context).size.height - widget._heightHeaderWidget, child: _getBody()),
        Positioned(
            bottom: 25,
            right: 25,
            child: Visibility(
                visible: _fabVisible,
                child: EditActionButton(
                    undoButtonAction: _onFeaturesEditUndo, saveButtonAction: _onFeaturesEditSave, tag: _tag)))
      ])
    ]);
  }

  _getTitleWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(Icons.comment, size: 30),
          const SizedBox(width: 10),
          Text('Suggest Edit', style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
        ]));
  }

  _onFeaturesEditSave() async {
    _inputSuggestionValid = isValid(_suggestion);
    if (!_inputSuggestionValid) {
      setState(() {});
      WidgetUtils.showToastMessage(context, 'No Valid suggestion provided', isErrorToast: true);
      return;
    }
    var uuid = const Uuid();
    final SuggestEditRequest request = SuggestEditRequest(
        identityProvider: 'FIREBASE',
        oauthToken: widget._params.oauthToken,
        oauthTokenSecret: '',
        uuid: uuid.v1(),
        fuelStationId: _fuelStation.stationId,
        fuelStationSource: _fuelStation.getFuelStationSource(),
        suggestion: _suggestion!);
    SuggestEditResponse response;
    try {
      lockInputs();
      response = await PostSuggestEdit(SuggestEditResponseParser()).execute(request);
    } on Exception catch (e, s) {
      LogUtil.debug(_tag, 'Exception occurred while calling PostSuggestEdit.execute $s');
      response = SuggestEditResponse(
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
    final dynamic persistUpdateHistoryResult = await _persistUpdateHistory(request, response);
    LogUtil.debug(_tag, 'SuggestEdit : persistUpdateHistory : result $persistUpdateHistoryResult');
    if (!mounted) return;
    if (response.responseCode == 'SUCCESS') {
      WidgetUtils.showToastMessage(context, 'Successfully notified pumped team for suggestion');
      if (_onValueChanged) {
        setState(() {
          _onValueChanged = false;
        });
      }
    } else {
      LogUtil.debug(_tag, 'Error persisting suggestion ${response.responseCode}');
      WidgetUtils.showToastMessage(context, 'Transient issue occurred while posting suggested edit', isErrorToast: true);
    }
    Navigator.pop(context, _getUpdateResponse(request, response));
  }

  bool isValid(final String? input) {
    return DataUtils.isNotBlank(input);
  }

  void lockInputs() {
    LogUtil.debug(_tag, 'locking the inputs');
    setState(() {
      _backendUpdateInProgress = true;
    });
  }

  void unlockInputs() {
    LogUtil.debug(_tag, 'unlocking the inputs');
    _suggestEditTextEditingController.clear();
    _inputSuggestionValid = true;
    setState(() {
      _backendUpdateInProgress = false;
      _onValueChanged = false;
    });
  }

  _onFeaturesEditUndo() {
    _suggestEditTextEditingController.clear();
    if (_onValueChanged) {
      setState(() {
        _onValueChanged = false;
        _fabVisible = false;
      });
    }
  }

  _getBody() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
            controller: _suggestEditTextEditingController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            key: const PageStorageKey("suggest-edit-text-field"),
            enabled: !_backendUpdateInProgress,
            maxLines: 8,
            onChanged: _onChangeListener,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                hintText: 'Enter your suggestion')));
  }

  void _onChangeListener(final String text) {
    _suggestion = _suggestEditTextEditingController.text;
    if (!DataUtils.isBlank(_suggestion)) {
      if (!_onValueChanged) {
        setState(() {
          _onValueChanged = true;
          _fabVisible = _onValueChanged;
        });
      }
    } else {
      if (_onValueChanged) {
        setState(() {
          _onValueChanged = false;
          _fabVisible = _onValueChanged;
        });
      }
    }
  }

  Future<dynamic> _persistUpdateHistory(final SuggestEditRequest request, final SuggestEditResponse response) {
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
        updateType: UpdateType.suggestEdit.updateTypeName!,
        responseCode: response.responseCode,
        originalValues: {UpdateTypeAttributes.suggestion: ''},
        updateValues: {UpdateTypeAttributes.suggestion: request.suggestion},
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  UpdateSuggestionResponse _getUpdateResponse(final SuggestEditRequest request, final SuggestEditResponse response) {
    int updateEpoch = response.updateEpoch;
    if (response.updateEpoch > 1700000000) {
      //Ths is interim, till the Pumped fix is not pushed back.
      updateEpoch = response.updateEpoch ~/ 1000;
    }
    return UpdateSuggestionResponse(true, updateEpoch);
  }
}
