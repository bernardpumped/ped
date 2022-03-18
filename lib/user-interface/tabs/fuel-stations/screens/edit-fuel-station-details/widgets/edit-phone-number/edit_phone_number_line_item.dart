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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class EditPhoneNumberLineItem extends StatefulWidget {
  final String title;
  final String? phoneNumber;
  final TextEditingController phoneEditingController;
  final bool _backendUpdateInProgress;
  final Function onValueChangeListener;

  const EditPhoneNumberLineItem(this.title, this.phoneNumber, this.phoneEditingController, this.onValueChangeListener,
      this._backendUpdateInProgress, {Key? key}) : super(key: key);

  @override
  _EditPhoneNumberLineItemState createState() => _EditPhoneNumberLineItemState();
}

class _EditPhoneNumberLineItemState extends State<EditPhoneNumberLineItem> {
  static const _heightWithoutErrorMsg = 40.0;
  static const _heightWithErrorMsg = 65.0;
  static const _heightOfErrorMsg = 20.0;
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
    _phoneEnabled = DataUtils.isBlank(widget.phoneNumber);
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
      final bool isValid = DataUtils.isValidNumber(widget.phoneEditingController.text) ||
          DataUtils.isBlank(widget.phoneEditingController.text);
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
    final CupertinoTextField phoneTextField = _buildTextField();
    return AnimatedContainer(
        height: _containerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _containerHeightChangeTime),
        padding: const EdgeInsets.only(left: 40, right: 20, bottom: 5),
        child: Row(children: <Widget>[
          Expanded(flex: 1, child: Text(widget.title)),
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_getPhoneField(phoneTextField), _getErrorMsgField()]))
        ]));
  }

  Widget _getErrorMsgField() {
    return AnimatedContainer(
        padding: EdgeInsets.only(top: _errorContainerHeight == _heightOfErrorMsg ? 5 : 0),
        height: _errorContainerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _errorMsgHeightChangeTime),
        child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));
  }

  Widget _getPhoneField(final CupertinoTextField phoneTextField) {
    return _phoneEnabled
        ? phoneTextField
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: IgnorePointer(child: phoneTextField),
            onTap: () {
              WidgetUtils.showToastMessage(context, 'Phone number cannot be changed', Theme.of(context).primaryColor);
            });
  }

  CupertinoTextField _buildTextField() {
    return CupertinoTextField(
        decoration: BoxDecoration(
            color: Colors.white,
            border: _phoneEnabled ? Border.all(color: Colors.blue) : Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        clearButtonMode: OverlayVisibilityMode.editing,
        controller: widget.phoneEditingController,
        style: const TextStyle(fontSize: 15),
        keyboardType: TextInputType.phone,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        enabled: _phoneEnabled && !widget._backendUpdateInProgress,
        placeholder: !_phoneEnabled ? widget.phoneNumber : 'Enter Phone',
        placeholderStyle:
            TextStyle(color: _phoneEnabled ? FontsAndColors.pumpedNonActionableIconColor : Colors.black87),
        key: PageStorageKey('edit-${widget.phoneNumber}'),
        onChanged: (v) {
          _onValueChange();
        });
  }

  static const _tag = 'EditPhoneNumberLineItem';

  void _onValueChange() {
    if (_phoneEnabled) {
      final String enteredPhoneNumber = widget.phoneEditingController.text;
      final bool isValid = DataUtils.isValidNumber(enteredPhoneNumber) || DataUtils.isBlank(enteredPhoneNumber);
      LogUtil.debug(_tag, 'Entered Phone Number is |$enteredPhoneNumber| is valid $isValid');
      final bool valueUpdated = !DataUtils.stringEqual(enteredPhoneNumber, widget.phoneNumber, true);
      if (valueUpdated) {
        if (isValid) {
          widget.onValueChangeListener(widget.title, enteredPhoneNumber);
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
