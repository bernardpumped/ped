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

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pumped_end_device/data/local/model/fuel_authority_price_metadata.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class AnimEditFuelPriceLineItemWidget extends StatefulWidget {
  final FuelQuote fuelQuote;
  final bool isFaStation;
  final String fuelName;
  final String currencyValueFormat;
  final TextEditingController? fuelPriceEditingController;
  final FuelAuthorityPriceMetadata? fuelAuthorityPriceMetadata;
  final Function quoteChangeListener;

  const AnimEditFuelPriceLineItemWidget(
      {Key? key,
      required this.isFaStation,
      required this.fuelQuote,
      required this.fuelName,
      this.fuelAuthorityPriceMetadata,
      required this.fuelPriceEditingController,
      required this.currencyValueFormat,
      required this.quoteChangeListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimEditFuelPriceLineItemWidgetState();
  }
}

class _AnimEditFuelPriceLineItemWidgetState extends State<AnimEditFuelPriceLineItemWidget> {
  static const double _defaultMinValue = 0.0;
  static const double _defaultMaxValue = 999.0;

  int digitsBeforeDecimal = 4;
  int digitsAfterDecimal = 0;

  final FocusNode _focus = FocusNode();
  static const _focusHeight = 90;
  static const _noFocusHeight = 60;
  static const _noFocusHintHeight = 0;
  static const _focusHintHeight = 30;
  double _height = _noFocusHeight.toDouble();
  double _hintHeight = _noFocusHintHeight.toDouble();
  static const _focusDurationMills = 1000;
  static const _noFocusDurationMills = 250;
  int _durationMills = _focusDurationMills;
  double? enteredPrice;
  String? trackingValue;
  late bool _isItError;

  bool decimalDeleted = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      if (_focus.hasFocus) {
        _height = _focusHeight.toDouble();
        _hintHeight = _focusHintHeight.toDouble();
        _durationMills = _focusDurationMills;
      } else {
        _height = _noFocusHeight.toDouble();
        _hintHeight = _noFocusHintHeight.toDouble();
        _durationMills = _noFocusDurationMills;
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    String hintMessage = 'No Price Range';
    _isItError = false;
    if (widget.fuelAuthorityPriceMetadata != null) {
      final minPrice = _getMinPrice(widget.fuelAuthorityPriceMetadata);
      final maxPrice = _getMaxPrice(widget.fuelAuthorityPriceMetadata);
      if (enteredPrice != null && (enteredPrice! < minPrice || enteredPrice! > maxPrice)) {
        hintMessage = 'Not in range $minPrice and $maxPrice';
        _isItError = true;
      } else {
        hintMessage = 'Price Range $minPrice - $maxPrice';
      }
    }
    digitsAfterDecimal = int.parse(widget.currencyValueFormat.substring(2, 4));

    final bool enabled = widget.fuelQuote.fuelQuoteSource != 'F' && !widget.isFaStation;
    if (!enabled) {
      return GestureDetector(
          child: Card(
              child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 3, bottom: 3),
                  height: _noFocusHeight.toDouble(),
                  child: _getFuelTypeQuoteValRow(_buildTextField(widget.fuelQuote)))),
          onTap: () {
            WidgetUtils.showToastMessage(context, 'Fuel Price cannot be changed');
          });
    } else {
      final Widget fuelQuoteTextField = _buildFuelQuoteTextField(widget.fuelPriceEditingController!);
      return Card(
          child: AnimatedContainer(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 3, bottom: 3),
              height: _height,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: Column(children: [
                _getFuelTypeQuoteValRow(fuelQuoteTextField),
                AnimatedContainer(
                    padding: EdgeInsets.only(top: _hintHeight != _noFocusHintHeight ? 10 : 0),
                    height: _hintHeight * (TextScaler.of<TextScalingFactor>(context)!.scaleFactor),
                    duration: Duration(milliseconds: _durationMills),
                    child: Text(hintMessage,
                        style: _isItError
                            ? Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error)
                            : Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center, textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor))
              ])));
    }
  }

  Widget _getFuelTypeQuoteValRow(final Widget fuelQuoteWidget) {
    return Expanded(
      child: Row(children: <Widget>[
        Expanded(
            flex: 9,
            child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(widget.fuelName, style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),)),
        Expanded(flex: 5, child: fuelQuoteWidget),
        Expanded(
            flex: 2,
            child: Padding(padding: const EdgeInsets.only(left: 15), child: _getFuelQuoteSourceIcon(widget.fuelQuote)))
      ])
    );
  }

  Widget _getFuelQuoteSourceIcon(final FuelQuote fuelQuote) {
    if (fuelQuote.quoteValue != null && fuelQuote.fuelQuoteSource != null) {
      if (fuelQuote.fuelAuthoritySource() || fuelQuote.crowdSourced()) {
        return fuelQuote.fuelQuoteSource == 'F'
            ? const Icon(Icons.info_outline, size: 25)
            : const Icon(Icons.people_outline, size: 25);
      }
    }
    return const SizedBox(width: 0);
  }

  static const _firstAllowedChar = 0;
  static const _firstAllowedCharDecimalPos = 3;
  static const _alternateDecimalPos = 3;

  _buildFuelQuoteTextField(final TextEditingController textEditingController) {
    int? firstAllowedChar;
    int? firstAllowedCharDecimalPos; //default value for decimal placement
    int? alternateDecimalPos;
    if (widget.fuelAuthorityPriceMetadata != null) {
      firstAllowedChar = widget.fuelAuthorityPriceMetadata?.allowedMaxFirstChar;
      firstAllowedCharDecimalPos = widget.fuelAuthorityPriceMetadata?.decPosForAllowedMaxForChar;
      alternateDecimalPos = widget.fuelAuthorityPriceMetadata?.alternatePos;
    }
    final int finalFirstAllowedChar = firstAllowedChar ?? _firstAllowedChar;
    final int finalFirstAllowedCharDecimalPos = firstAllowedCharDecimalPos ?? _firstAllowedCharDecimalPos;
    final int finalAlternateDecimalPos = alternateDecimalPos ?? _alternateDecimalPos;
    final String currencyFormat = r'^\d+\.?\d{0,' + digitsAfterDecimal.toString() + '}';
    return TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Tap to update',
            hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).hintColor)),
        focusNode: _focus,
        controller: textEditingController,
        style: Theme.of(context).textTheme.titleSmall,
        keyboardType: TextInputType.number,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(currencyFormat), allow: true),
          _PriceTextInputFormatter(digitsAfterDecimal + digitsBeforeDecimal)
        ],
        key: PageStorageKey('edit-fuel-price${widget.fuelQuote.fuelType}'),
        onChanged: (value) {
          int autoDecimalPlacement = finalFirstAllowedCharDecimalPos;
          String fuelPriceEntered = textEditingController.text;
          if (fuelPriceEntered != '') {
            final int firstChar = int.parse(fuelPriceEntered.substring(0, 1));
            if (firstChar == finalFirstAllowedChar) {
              autoDecimalPlacement = finalFirstAllowedCharDecimalPos;
            } else {
              autoDecimalPlacement = finalAlternateDecimalPos;
            }
            int? countCharsChanged;
            if (trackingValue != null) {
              countCharsChanged = textEditingController.text.compareTo(trackingValue.toString());
            }
            final String? deletedChar = DataUtils.charDeleted(trackingValue.toString(), textEditingController.text);
            if (deletedChar != null) {
              decimalDeleted = decimalDeleted ? decimalDeleted : deletedChar == '.';
            }
            if (!fuelPriceEntered.contains(".") &&
                countCharsChanged != 0 &&
                fuelPriceEntered.length == autoDecimalPlacement &&
                !decimalDeleted) {
              fuelPriceEntered = StringUtils.addCharAtPosition(fuelPriceEntered, '.', autoDecimalPlacement);
              textEditingController
                ..text = fuelPriceEntered
                ..selection = TextSelection.collapsed(offset: textEditingController.text.length);
            }
          } else {
            decimalDeleted = false;
          }
          trackingValue = textEditingController.text;
          setState(() {
            if (trackingValue == null || trackingValue == '') {
              enteredPrice = null;
            } else {
              enteredPrice = double.parse(trackingValue.toString());
            }
          });
          if (enteredPrice != null) {
            widget.quoteChangeListener(widget.fuelQuote.fuelType, enteredPrice);
          }
        });
  }

  double _getMaxPrice(final FuelAuthorityPriceMetadata? metaData) {
    if (metaData == null) {
      return _defaultMaxValue;
    }
    final double maxTolerancePercent = metaData.maxTolerancePercent;
    final double maxPrice = metaData.maxPrice + metaData.maxPrice * maxTolerancePercent / 100 - 0.1;
    return double.parse(maxPrice.toStringAsFixed(1));
  }

  double _getMinPrice(final FuelAuthorityPriceMetadata? metaData) {
    if (metaData == null) {
      return _defaultMinValue;
    }
    final double minTolerancePercent = metaData.minTolerancePercent;
    double minPrice = metaData.minPrice - metaData.minPrice * minTolerancePercent / 100 + 0.1;
    if (minPrice < 0) {
      minPrice = _defaultMinValue;
    }
    return double.parse(minPrice.toStringAsFixed(1));
  }

  Text _buildTextField(final FuelQuote fuelQuote) {
    return Text(fuelQuote.quoteValue != null ? fuelQuote.quoteValue.toString() : 'N/A',
        style: Theme.of(context).textTheme.titleSmall,
        textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
  }
}

class _PriceTextInputFormatter implements TextInputFormatter {
  final int maxLength;
  _PriceTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(final TextEditingValue oldValue, final TextEditingValue newValue) {
    final String newValueText = newValue.text;
    final int newValueTextLength = newValue.text.length;

    final String oldValueText = oldValue.text;
    final int oldValueTextLength = oldValue.text.length;

    if (newValueTextLength <= maxLength) {
      return TextEditingValue(text: newValueText, selection: TextSelection.collapsed(offset: newValueTextLength));
    } else {
      return TextEditingValue(text: oldValueText, selection: TextSelection.collapsed(offset: oldValueTextLength));
    }
  }
}
