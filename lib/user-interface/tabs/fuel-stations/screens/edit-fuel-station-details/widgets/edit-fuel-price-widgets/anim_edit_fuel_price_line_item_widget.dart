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

import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pumped_end_device/data/local/model/fuel_authority_price_metadata.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class AnimEditFuelPriceLineItemWidget extends StatefulWidget {
  final FuelQuote fuelQuote;
  final String fuelName;
  final String currencyValueFormat;
  final TextEditingController fuelPriceEditingController;
  final FuelAuthorityPriceMetadata fuelAuthorityPriceMetadata;
  final Function quoteChangeListener;

  const AnimEditFuelPriceLineItemWidget(
      {Key key,
      this.fuelQuote,
      this.fuelName,
      this.fuelAuthorityPriceMetadata,
      this.fuelPriceEditingController,
      this.currencyValueFormat,
      this.quoteChangeListener})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnimEditFuelPriceLineItemWidgetState();
  }
}

class _AnimEditFuelPriceLineItemWidgetState extends State<AnimEditFuelPriceLineItemWidget> {
  static const double DEFAULT_MIN_VAL = 0.0;
  static const double DEFAULT_MAX_VAL = 999.0;
  int digitsBeforeDecimal = 4;
  int digitsAfterDecimal = 0;

  final FocusNode _focus = new FocusNode();
  static const _focusColor = Colors.white;
  static const _noFocusColor = Color(0x33eeeeee);
  static const _focusHeight = 72;
  static const _noFocusHeight = 42;
  static const _noFocusHintHeight = 0;
  static const _focusHintHeight = 30;
  static const _greyColor = Colors.grey;
  static const _exceptionColor = Colors.red;
  static const _blackColor = Colors.black87;
  static const _blueColor = Colors.blue;
  double _height = _noFocusHeight.toDouble();
  double _hintHeight = _noFocusHintHeight.toDouble();
  Color _color = _noFocusColor;
  static const _focusDurationMills = 1000;
  static const _noFocusDurationMills = 250;
  int _durationMills = _focusDurationMills;
  double enteredPrice;
  String trackingValue;
  Color _priceBoxColor = _greyColor;
  Color _hintTextColor = _blackColor;

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
        _color = _focusColor;
        _hintHeight = _focusHintHeight.toDouble();
        _durationMills = _focusDurationMills;
      } else {
        _height = _noFocusHeight.toDouble();
        _color = _noFocusColor;
        _hintHeight = _noFocusHintHeight.toDouble();
        _durationMills = _noFocusDurationMills;
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    String hintMessage = 'No Price Range';
    _priceBoxColor = _blueColor;
    _hintTextColor = _blueColor;
    if (widget.fuelAuthorityPriceMetadata != null) {
      final minPrice = _getMinPrice(widget.fuelAuthorityPriceMetadata);
      final maxPrice = _getMaxPrice(widget.fuelAuthorityPriceMetadata);
      if (enteredPrice != null && (enteredPrice < minPrice || enteredPrice > maxPrice)) {
        hintMessage = 'Not in range $minPrice and $maxPrice';
        _priceBoxColor = _exceptionColor;
        _hintTextColor = _exceptionColor;
      } else {
        hintMessage = 'Price Range $minPrice - $maxPrice';
      }
    }
    if (widget.currencyValueFormat != null) {
      digitsAfterDecimal = int.parse(widget.currencyValueFormat.substring(2, 4));
    }

    final bool enabled = widget.fuelQuote.fuelQuoteSource != 'F';
    final CupertinoTextField fuelQuoteTextField = _buildFuelQuoteTextField(enabled);
    return AnimatedContainer(
        padding: EdgeInsets.only(left: 30, right: 30, top: 3, bottom: 3),
        height: _height,
        decoration: BoxDecoration(color: _color),
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: Column(children: [
          Row(children: <Widget>[
            Expanded(
                flex: 5,
                child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(widget.fuelName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)))),
            Expanded(
                flex: 6,
                child: !enabled
                    ? GestureDetector(
/*
                     By default Gesture detector does not work with CupertinoTextField
                     So it is necessary  to set behavior: HitTestBehavior.translucent property.
                     https://github.com/flutter/flutter/issues/23454#issuecomment-489134285
                     Further it is required to wrap the CupertinoTextField in IgnorePointer
                     to enable gesture detector work.
                     Since we need to enable tap only when the fuelQuotes are absent so,
                     conditional logic based on enabled flag.
*/
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          WidgetUtils.showToastMessage(
                              context, 'Fuel Price cannot be changed', Theme.of(context).primaryColor);
                        },
                        child: IgnorePointer(child: fuelQuoteTextField))
                    : fuelQuoteTextField),
            Expanded(
                flex: 2,
                child: Padding(padding: EdgeInsets.only(left: 15), child: _getFuelQuoteSourceIcon(widget.fuelQuote)))
          ]),
          Row(children: [
            Expanded(child: Container(), flex: 3),
            Expanded(
                flex: 8,
                child: AnimatedContainer(
                    padding: EdgeInsets.only(top: _hintHeight != _noFocusHintHeight ? 10 : 0),
                    height: _hintHeight,
                    duration: Duration(milliseconds: _durationMills),
                    child: Text(hintMessage,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: _hintTextColor),
                        textAlign: TextAlign.center)))
          ])
        ]));
  }

  Widget _getFuelQuoteSourceIcon(final FuelQuote fuelQuote) {
    if (fuelQuote.quoteValue != null && fuelQuote.fuelQuoteSource != null) {
      if (fuelQuote.fuelAuthoritySource() || fuelQuote.crowdSourced()) {
        return fuelQuote.fuelQuoteSource == 'F'
            ? PumpedIcons.faSourceIcon_black54Size24
            : PumpedIcons.crowdSourceIcon_black54Size24;
      }
    }
    return Text('');
  }

  CupertinoTextField _buildFuelQuoteTextField(final bool enabled) {
    int firstAllowedChar = 0;
    int firstAllowedCharDecimalPos = 3; //default value for decimal placement
    int alternateDecimalPos = 3;
    if (widget.fuelAuthorityPriceMetadata != null) {
      firstAllowedChar = widget.fuelAuthorityPriceMetadata.allowedMaxFirstChar;
      firstAllowedCharDecimalPos = widget.fuelAuthorityPriceMetadata.decPosForAllowedMaxForChar;
      alternateDecimalPos = widget.fuelAuthorityPriceMetadata.alternatePos;
    }
    final int finalFirstAllowedChar = firstAllowedChar;
    final int finalFirstAllowedCharDecimalPos = firstAllowedCharDecimalPos;
    final int finalAlternateDecimalPos = alternateDecimalPos;
    final String quoteValue = widget.fuelQuote.quoteValue == null ? '' : widget.fuelQuote.quoteValue.toString();
    final String currencyFormat = r'^\d+\.?\d{0,' + digitsAfterDecimal.toString() + '}';
    return CupertinoTextField(
        focusNode: _focus,
        decoration: BoxDecoration(
            color: Colors.white,
            border: widget.fuelQuote.quoteValue == null
                ? Border.all(color: _priceBoxColor)
                : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        enabled: enabled,
        clearButtonMode: OverlayVisibilityMode.editing,
        controller: widget.fuelPriceEditingController,
        style: TextStyle(fontSize: 15),
        keyboardType: TextInputType.number,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        placeholder: quoteValue,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(currencyFormat), allow: true),
          _PriceTextInputFormatter(digitsAfterDecimal + digitsBeforeDecimal)
        ],
        placeholderStyle: TextStyle(color: Colors.black87),
        onChanged: (value) {
          int autoDecimalPlacement = finalFirstAllowedCharDecimalPos;
          String fuelPriceEntered = widget.fuelPriceEditingController.text;
          if (fuelPriceEntered != '') {
            final int firstChar = int.parse(fuelPriceEntered.substring(0, 1));
            if (firstChar == finalFirstAllowedChar) {
              autoDecimalPlacement = finalFirstAllowedCharDecimalPos;
            } else {
              autoDecimalPlacement = finalAlternateDecimalPos;
            }
            int countCharsChanged;
            if (trackingValue != null) {
              countCharsChanged = widget.fuelPriceEditingController.text.compareTo(trackingValue);
            }
            final String deletedChar = DataUtils.charDeleted(trackingValue, widget.fuelPriceEditingController.text);
            decimalDeleted = decimalDeleted ? decimalDeleted : deletedChar == '.';
            if (!fuelPriceEntered.contains(".") &&
                countCharsChanged != 0 &&
                fuelPriceEntered.length == autoDecimalPlacement &&
                !decimalDeleted) {
              fuelPriceEntered = StringUtils.addCharAtPosition(fuelPriceEntered, '.', autoDecimalPlacement);
              widget.fuelPriceEditingController
                ..text = fuelPriceEntered
                ..selection = TextSelection.collapsed(offset: widget.fuelPriceEditingController.text.length);
            }
          } else {
            decimalDeleted = false;
          }
          trackingValue = widget.fuelPriceEditingController.text;
          setState(() {
            if (trackingValue == null || trackingValue == '') {
              enteredPrice = null;
            } else {
              enteredPrice = double.parse(trackingValue);
            }
          });
          widget.quoteChangeListener(widget.fuelQuote.fuelType, enteredPrice);
        },
        key: PageStorageKey('edit-fuel-price${widget.fuelQuote.fuelType}'));
  }

  double _getMaxPrice(final FuelAuthorityPriceMetadata metaData) {
    if (metaData == null) {
      return DEFAULT_MAX_VAL;
    }
    if (null == metaData.maxPrice) {
      return DEFAULT_MAX_VAL;
    }
    final double maxTolerancePercent = metaData.maxTolerancePercent;
    if (null == maxTolerancePercent) {
      return DEFAULT_MAX_VAL;
    }
    final double maxPrice = metaData.maxPrice + metaData.maxPrice * maxTolerancePercent / 100 - 0.1;
    return double.parse(maxPrice.toStringAsFixed(1));
  }

  double _getMinPrice(final FuelAuthorityPriceMetadata metaData) {
    if (metaData == null) {
      return DEFAULT_MIN_VAL;
    }
    if (null == metaData.minPrice) {
      return DEFAULT_MIN_VAL;
    }
    final double minTolerancePercent = metaData.minTolerancePercent;
    if (null == minTolerancePercent) {
      return DEFAULT_MIN_VAL;
    }
    double minPrice = metaData.minPrice - metaData.minPrice * minTolerancePercent / 100 + 0.1;
    if (minPrice < 0) {
      minPrice = DEFAULT_MIN_VAL;
    }
    return double.parse(minPrice.toStringAsFixed(1));
  }
}

class _PriceTextInputFormatter implements TextInputFormatter {
  final int maxLength;
  _PriceTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(final TextEditingValue oldValue, final TextEditingValue newValue) {
    final String newValueText = newValue.text != null ? newValue.text : '';
    final int newValueTextLength = newValue.text != null ? newValue.text.length : 0;

    final String oldValueText = oldValue.text != null ? oldValue.text : '';
    final int oldValueTextLength = oldValue.text != null ? oldValue.text.length : 0;

    if (newValueTextLength <= maxLength) {
      return TextEditingValue(text: newValueText, selection: TextSelection.collapsed(offset: newValueTextLength));
    } else {
      return TextEditingValue(text: oldValueText, selection: TextSelection.collapsed(offset: oldValueTextLength));
    }
  }
}
