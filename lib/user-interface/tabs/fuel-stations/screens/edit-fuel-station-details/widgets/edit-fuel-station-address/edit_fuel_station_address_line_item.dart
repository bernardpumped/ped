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

class EditFuelStationAddressLineItem extends StatefulWidget {
  final String _addressComponentName;
  final String _addressComponentType;
  final String _addressComponentValue;
  final TextEditingController _addressComponentEditingController;
  final bool _backendUpdateInProgress;
  final Function _onValueChangeListener;

  EditFuelStationAddressLineItem(this._addressComponentName, this._addressComponentType, this._addressComponentValue,
      this._addressComponentEditingController, this._backendUpdateInProgress, this._onValueChangeListener);

  @override
  _EditFuelStationAddressLineItemState createState() => _EditFuelStationAddressLineItemState();
}

class _EditFuelStationAddressLineItemState extends State<EditFuelStationAddressLineItem> {
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

  bool _addressComponentEnabled = false;

  @override
  void initState() {
    super.initState();
    _addressComponentEnabled = DataUtils.isBlank(widget._addressComponentValue);
    _setInitialState();
  }

  @override
  Widget build(final BuildContext context) {
    final CupertinoTextField addressComponentTextField = _buildTextField();
    return AnimatedContainer(
        height: _containerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _containerHeightChangeTime),
        padding: EdgeInsets.only(left: 40, right: 20, bottom: 5),
        child: Row(children: <Widget>[
          Expanded(flex: 1, child: Text(widget._addressComponentName)),
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_getAddressComponentField(addressComponentTextField), _getErrorMsgField()]))
        ]));
  }

  CupertinoTextField _buildTextField() {
    return CupertinoTextField(
        decoration: BoxDecoration(
            color: Colors.white,
            border: _addressComponentEnabled ? Border.all(color: Colors.blue) : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        clearButtonMode: OverlayVisibilityMode.editing,
        controller: widget._addressComponentEditingController, // Add this
        style: TextStyle(fontSize: 15),
        keyboardType: TextInputType.phone,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        enabled: _addressComponentEnabled && !widget._backendUpdateInProgress,
        placeholder:
            !_addressComponentEnabled ? widget._addressComponentValue : 'Enter ${widget._addressComponentName}',
        placeholderStyle:
            TextStyle(color: _addressComponentEnabled ? FontsAndColors.pumpedNonActionableIconColor : Colors.black87),
        key: PageStorageKey('edit-${widget._addressComponentValue}'),
        onChanged: (v) {
          _onValueChange();
        });
  }

  void _onValueChange() {
    if (_addressComponentEnabled) {
      final String enteredAddressComponent = widget._addressComponentEditingController.text;
      final bool isValid =
          DataUtils.isNotBlank(enteredAddressComponent) || enteredAddressComponent == widget._addressComponentValue;
      if (isValid) {
        widget._onValueChangeListener(
            widget._addressComponentType, enteredAddressComponent, widget._addressComponentValue);
        _setInitialState();
      } else {
        setState(() {
          _setUpdatedWidgetHeight();
        });
      }
    }
  }

  Widget _getErrorMsgField() {
    return AnimatedContainer(
        padding: EdgeInsets.only(top: _errorContainerHeight == _HEIGHT_OF_ERROR_MSG ? 5 : 0),
        height: _errorContainerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _errorMsgHeightChangeTime),
        child: Text(_errorMessage, style: TextStyle(color: Colors.red)));
  }

  Widget _getAddressComponentField(final CupertinoTextField addressComponentTextField) {
    return _addressComponentEnabled
        ? addressComponentTextField
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: IgnorePointer(child: addressComponentTextField),
            onTap: () {
              WidgetUtils.showToastMessage(
                  context, '${widget._addressComponentName} cannot be changed', Theme.of(context).primaryColor);
            });
  }

  void _setInitialState() {
    _errorContainerHeight = _HEIGHT_OF_NO_ERROR_MSG;
    _containerHeight = _HEIGHT_WITHOUT_ERROR_MSG;
    _errorMessage = "";
    _containerHeightChangeTime = _SLOW_DURATION;
    _errorMsgHeightChangeTime = _QUICK_DURATION;
  }

  void _setUpdatedWidgetHeight() {
    if (_addressComponentEnabled) {
      final bool isValid = DataUtils.isNotBlank(widget._addressComponentEditingController.text);
      if (!isValid) {
        _containerHeight = _HEIGHT_WITH_ERROR_MSG;
        _errorContainerHeight = _HEIGHT_OF_ERROR_MSG;
        _errorMessage = "${widget._addressComponentName} not valid";
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
}