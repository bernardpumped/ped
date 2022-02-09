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
import 'package:pumped_end_device/data/local/model/fuel_authority_price_metadata.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/post_fuel_quotes_update.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/dto/fuel_quote_vo.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/request/alter_fuel_quotes_request.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/model/response/alter_fuel_quotes_response.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/datasource/remote/reponse-parser/alter_fuel_quotes_response_parser.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/edit_fuel_price_widget_data.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update_type.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_fuel_quote_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/utils/edit_fuel_price_utils.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/save_undo_button_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

import 'anim_edit_fuel_price_line_item_widget.dart';

class EditFuelPriceWidget extends StatefulWidget {
  final String _titleText;
  final String _widgetKey;
  final FuelStation _fuelStation;
  final Function _widgetExpanded;
  final Function _setStateFunction;
  final Icon _leadingWidgetIcon;

  const EditFuelPriceWidget(this._fuelStation, this._titleText, this._setStateFunction, this._widgetExpanded, this._widgetKey,
      this._leadingWidgetIcon, {Key key}) : super(key: key);

  @override
  _EditFuelPriceWidgetState createState() => _EditFuelPriceWidgetState();
}

class _EditFuelPriceWidgetState extends State<EditFuelPriceWidget> {
  static const _tag = 'EditFuelPriceWidget';
  final EditFuelPriceUtils _editFuelPriceUtils = EditFuelPriceUtils();

  Future<EditFuelPriceWidgetData> _editFuelPriceWidgetDataFuture;
  Map<String, FuelQuote> fuelTypeFuelQuote = {};
  bool onValueChanged = false;
  bool _backendUpdateInProgress = false;

  @override
  void initState() {
    super.initState();
    _editFuelPriceWidgetDataFuture = _editFuelPriceUtils.editFuelPriceWidgetData();
  }

  @override
  Widget build(final BuildContext context) {
    widget._fuelStation.fuelQuotes().forEach((fuelQuote) {
      fuelTypeFuelQuote.putIfAbsent(fuelQuote.fuelType, () => fuelQuote);
    });
    final theme = Theme.of(context).copyWith(backgroundColor: Colors.white);
    final title =
        Text(widget._titleText, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500));
    return FutureBuilder<EditFuelPriceWidgetData>(
      future: _editFuelPriceWidgetDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          LogUtil.debug(_tag, 'Error loading EditFuelPriceWidgetData ${snapshot.error}');
          return Theme(data: theme, child: const Center(child: Text('Error Loading fuel-types')));
        } else if (snapshot.hasData) {
          final EditFuelPriceWidgetData editFuelPriceWidgetData = snapshot.data;
          return Theme(
              data: theme,
              child: ExpansionTile(
                  initiallyExpanded: widget._widgetExpanded(),
                  leading: widget._leadingWidgetIcon,
                  title: title,
                  key: PageStorageKey<String>(widget._widgetKey),
                  children: _editFuelTypePriceWidget(editFuelPriceWidgetData),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      widget._setStateFunction(expanded);
                    });
                  }));
        } else {
          return Theme(data: theme, child: const Center(child: Text('Loading')));
        }
      },
    );
  }

  final Map<String, TextEditingController> fuelPriceEditingControllers = {};
  final Map<String, double> outOfRangeFuelQuotes = {};

  List<Widget> _editFuelTypePriceWidget(final EditFuelPriceWidgetData editFuelPriceWidgetData) {
    final List<FuelType> fuelTypesForMarketRegion = editFuelPriceWidgetData.fuelTypesForMarketRegion;
    final Map<String, FuelType> allowedFuelTypesMap = {};
    for (var fuelType in fuelTypesForMarketRegion) {
      allowedFuelTypesMap.putIfAbsent(fuelType.fuelType, () => fuelType);
    }
    final Map<String, FuelAuthorityPriceMetadata> fuelTypePriceMetadata = {};
    final List<FuelAuthorityPriceMetadata> priceMetadata = editFuelPriceWidgetData.fuelAuthorityPriceMetadata;
    if (priceMetadata != null) {
      for (var element in priceMetadata) {
        fuelTypePriceMetadata.putIfAbsent(element.fuelType, () => element);
      }
    }
    final List<FuelQuote> fuelTypeFuelQuotes = widget._fuelStation.fuelQuotes();
    _sortFuelQuotes(fuelTypeFuelQuotes);
    final List<Widget> children = [];

    for (var fuelQuote in fuelTypeFuelQuotes) {
      String fuelType = fuelQuote.fuelType;
      TextEditingController fuelPriceEditingController;
      if (fuelQuote.fuelQuoteSource != 'F') {
        if (!fuelPriceEditingControllers.containsKey(fuelType)) {
          fuelPriceEditingController = fuelPriceEditingControllers.putIfAbsent(fuelType, () => TextEditingController());
        } else {
          fuelPriceEditingController = fuelPriceEditingControllers[fuelType];
        }
      }
      children.add(AnimEditFuelPriceLineItemWidget(
          key: PageStorageKey('$fuelType-${widget._fuelStation.stationId}'),
          fuelQuote: fuelQuote,
          quoteChangeListener: onFuelPriceChanged,
          fuelName: allowedFuelTypesMap[fuelType].fuelName,
          currencyValueFormat: editFuelPriceWidgetData.currencyValueFormat,
          fuelAuthorityPriceMetadata: fuelTypePriceMetadata[fuelType],
          fuelPriceEditingController: fuelPriceEditingController));
    }
    children.add(Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        child: SaveUndoButtonWidget(
            onSave: onSave,
            onCancel: onCancel,
            onValueChange: onValueChanged,
            saveButtonDisabled: _backendUpdateInProgress,
            undoButtonDisabled: _backendUpdateInProgress)));
    return children;
  }

  void _sortFuelQuotes(final List<FuelQuote> fuelQuotes) {
    fuelQuotes.sort((a, b) {
      if (a.quoteValue != null && b.quoteValue != null || a.quoteValue == null && b.quoteValue == null) {
        return a.fuelType.compareTo(b.fuelType);
      } else if (a.quoteValue != null) {
        return -1;
      } else {
        return 1;
      }
    });
  }

  void onSave() async {
    final List<FuelQuote> updatedFuelQuotes = [];
    final Map<String, dynamic> originalPrices = {};
    final Map<String, dynamic> updatedPrices = {};
    changedFuelQuotes.forEach((fuelType, newQuoteValue) {
      final FuelQuote oldFuelQuote = fuelTypeFuelQuote[fuelType];
      if (oldFuelQuote.quoteValue != newQuoteValue) {
        updatedFuelQuotes.add(DataUtils.duplicateWithOverrideQuoteValue(oldFuelQuote, newQuoteValue));
        originalPrices.putIfAbsent(oldFuelQuote.fuelType, () => oldFuelQuote.quoteValue);
        updatedPrices.putIfAbsent(oldFuelQuote.fuelType, () => newQuoteValue);
      }
    });
    if (updatedFuelQuotes.isNotEmpty) {
      final List<FuelQuoteVo> updatedFuelQuoteVos = [];
      for (var updatedFuelQuotes in updatedFuelQuotes) {
        updatedFuelQuoteVos.add(FuelQuoteVo.getFuelQuoteVo(updatedFuelQuotes));
      }
      final AlterFuelQuotesRequest request = AlterFuelQuotesRequest(
          fuelStationId: widget._fuelStation.stationId,
          fuelStationSource: widget._fuelStation.isFaStation ? "F" : "G",
          fuelQuoteVos: updatedFuelQuoteVos,
          oauthToken: 'my-dummy-oauth-token',
          oauthTokenSecret: 'my-dummy-oauth-token-secret',
          uuid: const Uuid().v1(),
          identityProvider: 'FIREBASE',
          oauthValidatorType: 'FIREBASE');
      AlterFuelQuotesResponse response;
      try {
        _lockInputs();
        response = await PostFuelQuotesUpdate(AlterFuelQuotesResponseParser()).execute(request);
      } on Exception catch (e, s) {
        LogUtil.debug(_tag, 'Exception occurred while calling PostFuelQuotesUpdate.execute $s');
        response = AlterFuelQuotesResponse(
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
      final int insertRecordResult = await _persistUpdateHistory(response, request, originalPrices, updatedPrices);
      LogUtil.debug(_tag, 'UpdateHistory inserted for :: UpdateFuelPrices :: result $insertRecordResult');
      if (response.responseCode == 'SUCCESS') {
        // TODO show appropriate message here.
        WidgetUtils.showToastMessage(
            context, 'Updated Fuel Quotes notified to pumped team', Theme.of(context).primaryColor);
      } else {
        WidgetUtils.showToastMessage(
            context, 'Error notifying Fuel Quote update to pumped team', Theme.of(context).primaryColor);
      }
      Navigator.pop(context, _getUpdateResponse(response, originalPrices, updatedPrices));
    }
  }

  Future<int> _persistUpdateHistory(final AlterFuelQuotesResponse response, final AlterFuelQuotesRequest request,
      final Map<String, dynamic> originalPrices, final Map<String, dynamic> updatedPrices) async {
    final UpdateHistory updateHistory = UpdateHistory(
        updateHistoryId: request.uuid,
        fuelStationId: request.fuelStationId,
        fuelStation: widget._fuelStation.fuelStationName,
        fuelStationSource: request.fuelStationSource,
        updateEpoch: response.updateEpoch,
        updateType: UpdateType.price.updateTypeName,
        responseCode: response.responseCode,
        originalValues: originalPrices,
        updateValues: updatedPrices,
        recordLevelExceptionCodes: response.updateResult,
        uberLevelExceptionCodes: response.exceptionCodes,
        invalidArguments: response.invalidArguments,
        responseDetails: response.responseDetails);
    return await UpdateHistoryDao.instance.insertUpdateHistory(updateHistory);
  }

  final Map<String, double> changedFuelQuotes = {};

  onFuelPriceChanged(final String fuelType, final double newQuoteValue) {
    if (fuelTypeFuelQuote[fuelType].quoteValue != newQuoteValue) {
      if (changedFuelQuotes.containsKey(fuelType)) {
        changedFuelQuotes.remove(fuelType);
      }
      changedFuelQuotes.putIfAbsent(fuelType, () => newQuoteValue);
    } else {
      if (changedFuelQuotes.containsKey(fuelType)) {
        changedFuelQuotes.remove(fuelType);
      }
    }
    if (changedFuelQuotes.isNotEmpty && !onValueChanged) {
      setState(() {
        onValueChanged = true;
      });
    } else {
      if (changedFuelQuotes.isEmpty && onValueChanged) {
        setState(() {
          onValueChanged = false;
        });
      }
    }
  }

  void onCancel() {
    setState(() {
      fuelPriceEditingControllers.forEach((fuelType, textEditingController) {
        textEditingController.clear();
      });
      onValueChanged = false;
      changedFuelQuotes.clear();
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
    });
  }

  UpdateFuelQuoteResult _getUpdateResponse(final AlterFuelQuotesResponse response,
      final Map<String, dynamic> originalPrices, final Map<String, dynamic> updatedPrices) {
    return UpdateFuelQuoteResult(
        isUpdateSuccessful: response.successfulUpdate,
        updateEpoch: response.updateEpoch,
        originalValues: originalPrices ?? {},
        updateValues: updatedPrices ?? {},
        invalidArguments: response.invalidArguments ?? {},
        recordLevelExceptionCodes: response.updateResult ?? {});
  }
}
