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
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/data/remote/model/dto/fuel_quote_update_exception_codes.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';

class UpdateHistoryDetailsPriceItemWidget extends StatelessWidget {
  final String valueType;
  final dynamic originalValue;
  final dynamic updateValue;
  final Map<String, dynamic>? serverExceptions;
  final List<dynamic> recordLevelExceptions;

  const UpdateHistoryDetailsPriceItemWidget(
      {super.key,
      required this.valueType,
      this.originalValue,
      this.updateValue,
      this.serverExceptions,
      required this.recordLevelExceptions});
  @override
  Widget build(final BuildContext context) {
    final String fuelType = valueType;
    final String originalFuelQuoteValue = originalValue == null ? '----' : originalValue.toString();
    final double updatedFuelQuoteValue = updateValue;
    final updateStatus = _getUpdateResult();
    return Card(
        margin: const EdgeInsets.all(2),
        child: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('Fuel Type', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text(fuelType, style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('Old Price', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text(originalFuelQuoteValue, style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('New Price', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text('$updatedFuelQuoteValue', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])),
          Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: Text('Status', style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                Expanded(flex: 1, child: Text(updateStatus, style: Theme.of(context).textTheme.bodyLarge,
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])),
          _getUpdateResult() == 'Failed'
              ? Padding(
                  padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 12),
                  child: Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Details', style: Theme.of(context).textTheme.bodyLarge,
                        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                    Expanded(
                        flex: 1,
                        child: Text(_getTranslatedUpdateResult(), style: Theme.of(context).textTheme.bodyLarge,
                            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor))
                  ]))
              : const SizedBox(height: 12)
        ]));
  }

  String _getUpdateResult() {
    if (serverExceptions == null || serverExceptions!.isEmpty) {
      if (recordLevelExceptions.isEmpty) {
        return 'Success';
      }
    }
    return 'Failed';
  }

  String _getTranslatedUpdateResult() {
    List<String> translatedResultCode = [];
    for (final String resultCode in recordLevelExceptions) {
      switch (resultCode) {
        case FuelQuoteUpdateExceptionCodes.updateFreqExceeded:
          translatedResultCode.add('Successive updates quick');
          break;
        case FuelQuoteUpdateExceptionCodes.priceNotInRange:
          translatedResultCode.add('Price not in range');
          break;
        case FuelQuoteUpdateExceptionCodes.versionMismatch:
          translatedResultCode.add('Stale update, please refresh');
          break;
        case FuelQuoteUpdateExceptionCodes.priceNotChanged:
          translatedResultCode.add('Same as old price');
          break;
        case FuelQuoteUpdateExceptionCodes.fuelMeasureNotConfiguredForMarketRegion:
          translatedResultCode.add('Invalid value - fuel measure');
          break;
        case FuelQuoteUpdateExceptionCodes.fuelPriceNotConfiguredForMarketRegion:
          translatedResultCode.add('Invalid value - currency');
          break;
        case FuelQuoteUpdateExceptionCodes.fuelTypeNotConfiguredForMarketRegion:
          translatedResultCode.add('Fuel not configured for your region');
          break;
        case FuelQuoteUpdateExceptionCodes.invalidParamForFuelQuote:
          translatedResultCode.add('Invalid fuel price');
          break;
        case FuelQuoteUpdateExceptionCodes.noFuelQuotesProvided:
          translatedResultCode.add('No updated value provided');
          break;
        case FuelQuoteUpdateExceptionCodes.updatingFuelQuoteOfMultipleStations:
          translatedResultCode.add('Can update only one station at a time');
          break;
        case FuelQuoteUpdateExceptionCodes.fuelQuoteFuelAuthoritySource:
          translatedResultCode.add('Cannot change fuel quotes provided by fuel authority');
          break;
        case FuelQuoteUpdateExceptionCodes.fuelQuoteMerchantSource:
          translatedResultCode.add('Cannot change fuel quote provided by merchant');
          break;
      }
    }
    if (translatedResultCode.isEmpty) {
      return 'Failed';
    } else {
      return translatedResultCode.join(', ');
    }
  }
}
