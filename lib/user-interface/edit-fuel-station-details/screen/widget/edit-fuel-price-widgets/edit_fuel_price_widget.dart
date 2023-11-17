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
import 'package:pumped_end_device/data/local/model/fuel_authority_price_metadata.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/dto/fuel_quote_vo.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/request/alter_fuel_quotes_request.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/response/alter_fuel_quotes_response.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/post_fuel_quotes_update.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/reponse-parser/alter_fuel_quotes_response_parser.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/model/update-results/update_fuel_quote_result.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-fuel-price-widgets/utils/edit_fuel_price_widget_data.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit_action_buttons_widget.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-fuel-price-widgets/utils/edit_fuel_price_utils.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
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
  final EditFuelStationDetailsParams _params;
  final double _heightHeaderWidget;

  const EditFuelPriceWidget(this._params, this._heightHeaderWidget, {super.key});

  @override
  State<EditFuelPriceWidget> createState() => _EditFuelPriceWidgetState();
}

class _EditFuelPriceWidgetState extends State<EditFuelPriceWidget> {
  static const _tag = 'EditFuelPriceWidget';
  final EditFuelPriceUtils _editFuelPriceUtils = EditFuelPriceUtils();

  Future<EditFuelPriceWidgetData?>? _editFuelPriceWidgetDataFuture;
  final Map<String, FuelQuote> _fuelTypeFuelQuote = {};
  bool _onValueChanged = false;
  bool _fabVisible = false;
  late FuelStation _fuelStation;

  @override
  void initState() {
    super.initState();
    _editFuelPriceWidgetDataFuture = _editFuelPriceUtils.editFuelPriceWidgetData();
    _fuelStation = widget._params.fuelStation;
  }

  @override
  Widget build(final BuildContext context) {
    _fuelStation.fuelQuotes().forEach((fuelQuote) {
      _fuelTypeFuelQuote.putIfAbsent(fuelQuote.fuelType, () => fuelQuote);
    });
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
                    undoButtonAction: _onFuelPriceChangeUndo, saveButtonAction: _onFuelPriceSave, tag: _tag)))
      ])
    ]);
  }

  _updateFabVisibility(bool showFab) {
    setState(() {
      _fabVisible = showFab;
    });
  }

  _getTitleWidget() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(Icons.monetization_on_outlined, size: 30),
          const SizedBox(width: 10),
          Text('Update Fuel Prices', style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
        ]));
  }

  FutureBuilder<EditFuelPriceWidgetData?> _buildFutureBuilder() {
    return FutureBuilder<EditFuelPriceWidgetData?>(
        future: _editFuelPriceWidgetDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            LogUtil.debug(_tag, 'Error loading EditFuelPriceWidgetData ${snapshot.error}');
            return Center(child: Text('Error Loading fuel-types', style: Theme.of(context).textTheme.titleSmall,
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
          } else if (snapshot.hasData) {
            return Column(children: _editFuelTypePriceWidget(snapshot.data!));
          } else {
            return Center(child: Text('Loading', style: Theme.of(context).textTheme.titleSmall,
                textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
          }
        });
  }

  final Map<String, TextEditingController> fuelPriceEditingControllers = {};
  final Map<String, AnimEditFuelPriceLineItemWidget> fuelPriceLineItemWidgets = {};
  final Map<String, FuelAuthorityPriceMetadata> fuelTypePriceMetadata = {};
  final Map<String, double> outOfRangeFuelQuotes = {};

  List<Widget> _editFuelTypePriceWidget(final EditFuelPriceWidgetData editFuelPriceWidgetData) {
    final List<FuelType> fuelTypesForMarketRegion = editFuelPriceWidgetData.fuelTypesForMarketRegion;
    final Map<String, FuelType> allowedFuelTypesMap = {};
    for (var fuelType in fuelTypesForMarketRegion) {
      allowedFuelTypesMap.putIfAbsent(fuelType.fuelType, () => fuelType);
    }
    final List<FuelAuthorityPriceMetadata> priceMetadata = editFuelPriceWidgetData.fuelAuthorityPriceMetadata;
    for (var element in priceMetadata) {
      fuelTypePriceMetadata.putIfAbsent(element.fuelType, () => element);
    }
    _sortFuelQuotes(_fuelStation.fuelQuotes());
    final List<Widget> children = [];

    for (var fuelQuote in _fuelStation.fuelQuotes()) {
      final String fuelType = fuelQuote.fuelType;
      TextEditingController? fuelPriceEditingController;
      if (fuelQuote.fuelQuoteSource != 'F' && !_fuelStation.isFaStation) {
        if (!fuelPriceEditingControllers.containsKey(fuelType)) {
          fuelPriceEditingController = fuelPriceEditingControllers.putIfAbsent(fuelType, () => TextEditingController());
        } else {
          fuelPriceEditingController = fuelPriceEditingControllers[fuelType]!;
        }
        if (fuelQuote.quoteValue != null) {
          fuelPriceEditingController.text = fuelQuote.quoteValue.toString();
        }
      }
      var fuelPriceLineItemWidget = AnimEditFuelPriceLineItemWidget(
          key: PageStorageKey('$fuelType-${_fuelStation.stationId}'),
          isFaStation: _fuelStation.isFaStation,
          fuelQuote: fuelQuote,
          quoteChangeListener: _onFuelPriceChange,
          fuelName: allowedFuelTypesMap[fuelType]?.fuelName as String,
          currencyValueFormat: editFuelPriceWidgetData.currencyValueFormat,
          fuelAuthorityPriceMetadata: fuelTypePriceMetadata[fuelType],
          fuelPriceEditingController: fuelPriceEditingController);
      fuelPriceLineItemWidgets.putIfAbsent(fuelType, () => fuelPriceLineItemWidget);
      children.add(fuelPriceLineItemWidget);
    }
    children.add(const SizedBox(height: 70));
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

  void _onFuelPriceSave() async {
    final List<FuelQuote> updatedFuelQuotes = [];
    final Map<String, dynamic> originalPrices = {};
    final Map<String, dynamic> updatedPrices = {};
    final List<String> badPriceFuelTypes = [];
    changedFuelQuotes.forEach((fuelType, newQuoteValue) {
      final FuelQuote oldFuelQuote = _fuelTypeFuelQuote[fuelType] as FuelQuote;
      if (oldFuelQuote.quoteValue != newQuoteValue) {
        if (_quoteValueInRange(fuelType, newQuoteValue)) {
          updatedFuelQuotes.add(DataUtils.duplicateWithOverrideQuoteValue(oldFuelQuote, newQuoteValue));
          originalPrices.putIfAbsent(oldFuelQuote.fuelType, () => oldFuelQuote.quoteValue);
          updatedPrices.putIfAbsent(oldFuelQuote.fuelType, () => newQuoteValue);
        } else {
          badPriceFuelTypes.add(fuelType);
        }
      }
    });
    if (badPriceFuelTypes.isNotEmpty) {
      String badPriceFuelTypesStr = badPriceFuelTypes.join(",");
      WidgetUtils.showToastMessage(
          context, 'First fix out of range price of $badPriceFuelTypesStr, and then try saving');
      return;
    }
    if (updatedFuelQuotes.isNotEmpty) {
      final List<FuelQuoteVo> updatedFuelQuoteVos = [];
      for (var updatedFuelQuotes in updatedFuelQuotes) {
        updatedFuelQuoteVos.add(FuelQuoteVo.getFuelQuoteVo(updatedFuelQuotes));
      }
      final AlterFuelQuotesRequest request = AlterFuelQuotesRequest(
          fuelStationId: _fuelStation.stationId,
          fuelStationSource: _fuelStation.getFuelStationSource(),
          fuelQuoteVos: updatedFuelQuoteVos,
          oauthToken: widget._params.oauthToken,
          oauthTokenSecret: '',
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
      final dynamic insertRecordResult = await _persistUpdateHistory(response, request, originalPrices, updatedPrices);
      LogUtil.debug(_tag, 'UpdateHistory inserted for :: UpdateFuelPrices :: result $insertRecordResult');
      if (!mounted) return;
      final Map<String, dynamic> responseParseMap = _isUpdateSuccessful(response);
      WidgetUtils.showToastMessage(context, responseParseMap[_responseMsg],
          isErrorToast: !responseParseMap[_isSuccess]!);
      Navigator.pop(context, _getUpdateResponse(response, originalPrices, updatedPrices));
    }
  }

  Future<dynamic> _persistUpdateHistory(final AlterFuelQuotesResponse response, final AlterFuelQuotesRequest request,
      final Map<String, dynamic> originalPrices, final Map<String, dynamic> updatedPrices) async {
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
        updateType: UpdateType.price.updateTypeName!,
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

  _onFuelPriceChange(final String fuelType, final double newQuoteValue) {
    if (_fuelTypeFuelQuote[fuelType]?.quoteValue != newQuoteValue) {
      if (changedFuelQuotes.containsKey(fuelType)) {
        changedFuelQuotes.remove(fuelType);
      }
      changedFuelQuotes.putIfAbsent(fuelType, () => newQuoteValue);
    } else {
      if (changedFuelQuotes.containsKey(fuelType)) {
        changedFuelQuotes.remove(fuelType);
      }
    }
    if (changedFuelQuotes.isNotEmpty && !_onValueChanged) {
      _onValueChanged = true;
      _updateFabVisibility(_onValueChanged);
    } else {
      if (changedFuelQuotes.isEmpty && _onValueChanged) {
        _onValueChanged = false;
        _updateFabVisibility(_onValueChanged);
      }
    }
  }

  void _onFuelPriceChangeUndo() {
    setState(() {
      fuelPriceEditingControllers.forEach((fuelType, textEditingController) {
        textEditingController.text = '';
      });
      _onValueChanged = false;
      _updateFabVisibility(_onValueChanged);
      changedFuelQuotes.clear();
    });
  }

  void _lockInputs() {
    setState(() {
    });
  }

  void _unlockInputs() {
    setState(() {
    });
  }

  UpdateFuelQuoteResult _getUpdateResponse(final AlterFuelQuotesResponse response,
      final Map<String, dynamic> originalPrices, final Map<String, dynamic> updatedPrices) {
    int updateEpoch = response.updateEpoch;
    if (response.updateEpoch > 1700000000) {
      //Ths is interim, till the Pumped fix is not pushed back.
      updateEpoch = response.updateEpoch ~/ 1000;
    }
    return UpdateFuelQuoteResult(
        isUpdateSuccessful: response.successfulUpdate,
        updateEpoch: updateEpoch,
        originalValues: originalPrices,
        updateValues: updatedPrices,
        invalidArguments: response.invalidArguments,
        recordLevelExceptionCodes: response.updateResult);
  }

  bool _quoteValueInRange(final String fuelType, final double newQuoteValue) {
    final FuelAuthorityPriceMetadata? metadata = fuelTypePriceMetadata[fuelType];
    if (metadata != null) {
      return newQuoteValue >= (metadata.minPrice * (1.0 - metadata.minTolerancePercent / 100.0)) &&
          newQuoteValue <= (metadata.maxPrice * (1.0 + metadata.maxTolerancePercent / 100.0));
    }
    return true;
  }

  static const _responseMsg = 'resp-msg';
  static const _isSuccess = 'is-success';

  Map<String, dynamic> _isUpdateSuccessful(final AlterFuelQuotesResponse response) {
    if (response.exceptionCodes != null && response.exceptionCodes!.isNotEmpty) {
      return {_responseMsg: 'Issue occurred while executing request', _isSuccess: false};
    }
    if (!response.successfulUpdate) {
      if (response.responseCode == 'CALL-EXCEPTION') {
        return {_responseMsg: 'Transient issue occurred while updating fuel prices, please retry', _isSuccess: false};
      }
      return {_responseMsg: 'Issue occurred while calling Pumped to update.', _isSuccess: false};
    } else {
      bool exceptionDetected = false;
      response.updateResult?.forEach((fuelType, updateExceptions) {
        exceptionDetected = exceptionDetected || (updateExceptions as List).isNotEmpty;
      });
      if (exceptionDetected) {
        return {_responseMsg: 'Issues occurred while updating a few fuel quotes', _isSuccess: false};
      }
      bool invalidArgsException = false;
      response.invalidArguments?.forEach((key, value) {
        invalidArgsException = invalidArgsException || DataUtils.isNotBlank(value);
      });
      if (invalidArgsException) {
        return {_responseMsg: 'Data found invalid, please refresh / correct before update', _isSuccess: false};
      }
      return {_responseMsg: 'Data successfully updated. Also notified Pumped Team', _isSuccess: true};
    }
  }
}
