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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/post_suggest_edit.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/request/suggest_edit_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/suggest_edit_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/reponse-parser/suggest_edit_response_parser.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_suggestion_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/edit_widget_expansion_tile.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/save_undo_button_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_type_attributes.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../fonts_and_colors.dart';

class SuggestEditWidget extends StatefulWidget {
  final Function setStateFunction;
  final Function isWidgetExpanded;
  final int fuelStationId;
  final String fuelStationSource;
  final String fuelStationName;

   const SuggestEditWidget(
      this.setStateFunction, this.isWidgetExpanded, this.fuelStationId, this.fuelStationName, this.fuelStationSource, {Key key}) : super(key: key);

  @override
  _SuggestEditWidgetState createState() => _SuggestEditWidgetState();
}

class _SuggestEditWidgetState extends State<SuggestEditWidget> {
  static const _tag = 'SuggestEditWidget';
  final TextEditingController _suggestEditTextEditingController = TextEditingController();
  bool _onValueChanged = false;
  bool _backendUpdateInProgress = false;
  bool _inputSuggestionValid = true;

  String _suggestion;

  static const suggestEditIcon = Icon(IconData(IconCodes.suggestEditIconCode, fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: FontsAndColors.pumpedNonActionableIconColor, size: 30);

  @override
  Widget build(final BuildContext context) {
    return EditWidgetExpansionTile(
        suggestEditIcon,
        'Have a suggestion to improve this station? Please let us know.',
        'suggest-edit',
        _suggestEditExpansionTileWidgetTree(),
        widget.isWidgetExpanded,
        widget.setStateFunction);
  }

  bool isValid(final String input) {
    return DataUtils.isNotBlank(input);
  }

  List<Widget> _suggestEditExpansionTileWidgetTree() {
    return [
      Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
              controller: _suggestEditTextEditingController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              key: const PageStorageKey("suggest-edit-text-field"),
              enabled: !_backendUpdateInProgress,
              maxLines: 5,
              onChanged: _onChangeListener,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: _inputSuggestionValid ? Colors.black45 : Colors.red)),
                  hintText: 'Enter your suggestion'))),
      SaveUndoButtonWidget(
          onSave: onSaveOperation,
          onCancel: onUndoOperation,
          onValueChange: _onValueChanged,
          saveButtonDisabled: _backendUpdateInProgress,
          undoButtonDisabled: _backendUpdateInProgress)
    ];
  }

  void _onChangeListener(final String text) {
    _suggestion = _suggestEditTextEditingController.text;
    if (!DataUtils.isBlank(_suggestion)) {
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

  void onSaveOperation() async {
    _inputSuggestionValid = isValid(_suggestion);
    if (!_inputSuggestionValid) {
      setState(() {});
      WidgetUtils.showToastMessage(context, 'No Valid suggestion provided', Colors.red);
      return;
    }
    var uuid = const Uuid();
    final SuggestEditRequest request = SuggestEditRequest(
        identityProvider: 'FIREBASE',
        oauthToken: 'dummy-token',
        oauthTokenSecret: 'dummy-token-secret',
        uuid: uuid.v1(),
        fuelStationId: widget.fuelStationId,
        fuelStationSource: widget.fuelStationSource,
        suggestion: _suggestion);
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
    final int persistUpdateHistoryResult = await _persistUpdateHistory(request, response);
    LogUtil.debug(_tag, 'SuggestEdit : persistUpdateHistory : result $persistUpdateHistoryResult');
    if (response.responseCode == 'SUCCESS') {
      WidgetUtils.showToastMessage(
          context, 'Successfully notified pumped team for suggestion', Theme.of(context).primaryColor);
      if (_onValueChanged) {
        setState(() {
          _onValueChanged = false;
        });
      }
    } else {
      LogUtil.debug(_tag, 'Error persisting suggestion ${response.responseCode}');
      WidgetUtils.showToastMessage(context, 'Error notifying pumped team', Theme.of(context).primaryColor);
    }
    Navigator.pop(context, _getUpdateResponse(request, response));
  }

  Future<int> _persistUpdateHistory(final SuggestEditRequest request, final SuggestEditResponse response) {
    final UpdateHistory updateHistory = UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: widget.fuelStationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: response.updateEpoch,
        updateType: UpdateType.suggestEdit.updateTypeName,
        responseCode: response.responseCode,
        originalValues: {UpdateTypeAttributes.suggestion: ''},
        updateValues: {UpdateTypeAttributes.suggestion: request.suggestion},
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  void onUndoOperation() {
    _suggestEditTextEditingController.clear();
    if (_onValueChanged) {
      setState(() {
        _onValueChanged = false;
      });
    }
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

  UpdateSuggestionResponse _getUpdateResponse(final SuggestEditRequest request, final SuggestEditResponse response) {
    return UpdateSuggestionResponse(true, response.updateEpoch);
  }
}
