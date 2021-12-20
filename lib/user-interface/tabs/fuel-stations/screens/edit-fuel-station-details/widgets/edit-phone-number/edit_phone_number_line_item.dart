/*
 *     Copyright (c) 2021.
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
  final String phoneNumber;
  final TextEditingController phoneEditingController;
  final bool _backendUpdateInProgress;
  final Function onValueChangeListener;

  EditPhoneNumberLineItem(this.title, this.phoneNumber, this.phoneEditingController, this.onValueChangeListener,
      this._backendUpdateInProgress);

  @override
  _EditPhoneNumberLineItemState createState() => _EditPhoneNumberLineItemState();
}

class _EditPhoneNumberLineItemState extends State<EditPhoneNumberLineItem> {
  static const _HEIGHT_WITHOUT_ERROR_MSG = 40.0;
  static const _HEIGHT_WITH_ERROR_MSG = 65.0;
  static const _HEIGHT_OF_ERROR_MSG = 20.0;
  static const _HEIGHT_OF_NO_ERROR_MSG = 0.0;

  static const _QUICK_DURATION = 300;
  static const _SLOW_DURATION = 1000;

  double _containerHeight;
  double _errorContainerHeight;
  String _errorMessage;
  int _containerHeightChangeTime;
  int _errorMsgHeightChangeTime;
  bool _phoneEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneEnabled = DataUtils.isBlank(widget.phoneNumber);
    _setInitialState();
  }

  void _setInitialState() {
    _errorContainerHeight = _HEIGHT_OF_NO_ERROR_MSG;
    _containerHeight = _HEIGHT_WITHOUT_ERROR_MSG;
    _errorMessage = "";
    _containerHeightChangeTime = _SLOW_DURATION;
    _errorMsgHeightChangeTime = _QUICK_DURATION;
  }

  void _setUpdatedWidgetHeight() {
    if (_phoneEnabled) {
      final bool isValid = DataUtils.isValidNumber(widget.phoneEditingController.text) ||
          DataUtils.isBlank(widget.phoneEditingController.text);
      if (!isValid) {
        _containerHeight = _HEIGHT_WITH_ERROR_MSG;
        _errorContainerHeight = _HEIGHT_OF_ERROR_MSG;
        _errorMessage = "Phone Number is invalid - numbers only";
        _containerHeightChangeTime = _QUICK_DURATION;
        _errorMsgHeightChangeTime = _SLOW_DURATION;
      } else {
        _containerHeight = _HEIGHT_WITHOUT_ERROR_MSG;
        _errorContainerHeight = _HEIGHT_OF_NO_ERROR_MSG;
        _errorMessage = "";
        _containerHeightChangeTime = _SLOW_DURATION;
        _errorMsgHeightChangeTime = _QUICK_DURATION;
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
        padding: EdgeInsets.only(left: 40, right: 20, bottom: 5),
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
        padding: EdgeInsets.only(top: _errorContainerHeight == _HEIGHT_OF_ERROR_MSG ? 5 : 0),
        height: _errorContainerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _errorMsgHeightChangeTime),
        child: Text(_errorMessage, style: TextStyle(color: Colors.red)));
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
            borderRadius: BorderRadius.all(Radius.circular(3))),
        clearButtonMode: OverlayVisibilityMode.editing,
        controller: widget.phoneEditingController,
        style: TextStyle(fontSize: 15),
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

  static const _TAG = 'EditPhoneNumberLineItem';

  void _onValueChange() {
    if (_phoneEnabled) {
      final String enteredPhoneNumber = widget.phoneEditingController.text;
      final bool isValid = DataUtils.isValidNumber(enteredPhoneNumber) || DataUtils.isBlank(enteredPhoneNumber);
      LogUtil.debug(_TAG, 'Entered Phone Number is |$enteredPhoneNumber| is valid $isValid');
      final bool valueUpdated = !DataUtils.stringEqual(enteredPhoneNumber, widget.phoneNumber, true);
      if (valueUpdated) {
        if (isValid) {
          widget.onValueChangeListener(widget.title, enteredPhoneNumber);
          _setInitialState();
        }
        if (_errorMessage == "" && !isValid || _errorMessage != null && isValid) {
          setState(() {
            _setUpdatedWidgetHeight();
          });
        }
      }
    }
  }
}
