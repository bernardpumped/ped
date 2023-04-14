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
import 'package:flutter/services.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class EditPhoneNumberLineItem extends StatefulWidget {
  final String _phoneNumberName;
  final String? _phoneNumberValue;
  final String _addressComponentType;
  final TextEditingController _phoneEditingController;
  final bool _backendUpdateInProgress;
  final Function _onValueChangeListener;

  const EditPhoneNumberLineItem(this._phoneNumberName, this._addressComponentType, this._phoneNumberValue,
      this._phoneEditingController, this._backendUpdateInProgress, this._onValueChangeListener,
      {Key? key})
      : super(key: key);

  @override
  State<EditPhoneNumberLineItem> createState() => _EditPhoneNumberLineItemState();
}

class _EditPhoneNumberLineItemState extends State<EditPhoneNumberLineItem> {
  static const _heightWithoutErrorMsg = 75.0;
  static const _heightWithErrorMsg = 100.0;
  static const _heightOfErrorMsg = 25.0;
  static const _heightOfNoErrorMsg = 0.0;

  static const _quickDuration = 300;
  static const _slowDuration = 1000;

  double _containerHeight = _heightWithoutErrorMsg;
  double _errorContainerHeight = _heightOfNoErrorMsg;
  String _errorMessage = "";
  int _containerHeightChangeTime = _slowDuration;
  int _errorMsgHeightChangeTime = _quickDuration;
  bool _phoneEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneEnabled = DataUtils.isBlank(widget._phoneNumberValue);
    _setInitialState();
  }

  void _setInitialState() {
    _errorContainerHeight = _heightOfNoErrorMsg;
    _containerHeight = _heightWithoutErrorMsg;
    _errorMessage = "";
    _containerHeightChangeTime = _slowDuration;
    _errorMsgHeightChangeTime = _quickDuration;
  }

  void _setUpdatedWidgetHeight() {
    if (_phoneEnabled) {
      final bool isValid = DataUtils.isValidNumber(widget._phoneEditingController.text) ||
          DataUtils.isBlank(widget._phoneEditingController.text);
      if (!isValid) {
        _containerHeight = _heightWithErrorMsg;
        _errorContainerHeight = _heightOfErrorMsg;
        _errorMessage = "Phone Number is invalid - numbers only";
        _containerHeightChangeTime = _quickDuration;
        _errorMsgHeightChangeTime = _slowDuration;
      } else {
        _containerHeight = _heightWithoutErrorMsg;
        _errorContainerHeight = _heightOfNoErrorMsg;
        _errorMessage = "";
        _containerHeightChangeTime = _slowDuration;
        _errorMsgHeightChangeTime = _quickDuration;
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    final TextField phoneTextField = _buildTextField();
    return AnimatedContainer(
        height: _containerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _containerHeightChangeTime),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                child: Row(children: <Widget>[
                  Expanded(flex: 1, child: Text(widget._phoneNumberName, style: Theme.of(context).textTheme.titleSmall,
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                  Expanded(
                      flex: 3,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_getPhoneField(phoneTextField), _getErrorMsgField()]))
                ]))));
  }

  Widget _getErrorMsgField() {
    return AnimatedContainer(
        padding: EdgeInsets.only(top: _errorContainerHeight == _heightOfErrorMsg ? 5 : 0),
        height: _errorContainerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _errorMsgHeightChangeTime),
        child: Text(_errorMessage,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error),
            textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }

  Widget _getPhoneField(final TextField phoneTextField) {
    return _phoneEnabled
        ? phoneTextField
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: IgnorePointer(child: phoneTextField),
            onTap: () {
              WidgetUtils.showToastMessage(context, 'Phone number cannot be changed');
            });
  }

  TextField _buildTextField() {
    return TextField(
        controller: widget._phoneEditingController, // Add this
        style: Theme.of(context).textTheme.titleSmall,
        keyboardType: TextInputType.phone,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        enabled: _phoneEnabled && !widget._backendUpdateInProgress,
        decoration:
            InputDecoration(hintText: !_phoneEnabled ? widget._phoneNumberValue : 'Enter ${widget._phoneNumberName}'),
        key: PageStorageKey('edit-${widget._phoneNumberValue}'),
        onChanged: (v) {
          _onValueChange();
        });
  }

  void _onValueChange() {
    if (_phoneEnabled) {
      final String enteredPhoneNumber = widget._phoneEditingController.text;
      final bool isValid = DataUtils.isValidNumber(enteredPhoneNumber) || DataUtils.isBlank(enteredPhoneNumber);
      final bool valueUpdated = !DataUtils.stringEqual(enteredPhoneNumber, widget._phoneNumberValue, true);
      if (valueUpdated) {
        if (isValid) {
          widget._onValueChangeListener(widget._addressComponentType, enteredPhoneNumber, widget._phoneNumberValue);
          _setInitialState();
        }
        if (_errorMessage == "" && !isValid) {
          setState(() {
            _setUpdatedWidgetHeight();
          });
        }
      }
    }
  }
}
