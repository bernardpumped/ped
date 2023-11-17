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

class EditFuelStationAddressLineItem extends StatefulWidget {
  final String _addressComponentName;
  final String _addressComponentType;
  final String? _addressComponentValue;
  final TextEditingController _addressComponentEditingController;
  final bool _backendUpdateInProgress;
  final Function _onValueChangeListener;

  const EditFuelStationAddressLineItem(
      this._addressComponentName,
      this._addressComponentType,
      this._addressComponentValue,
      this._addressComponentEditingController,
      this._backendUpdateInProgress,
      this._onValueChangeListener,
      {Key? key})
      : super(key: key);

  @override
  State<EditFuelStationAddressLineItem> createState() => _EditFuelStationAddressLineItemState();
}

class _EditFuelStationAddressLineItemState extends State<EditFuelStationAddressLineItem> {
  static const _heightWithoutErrorMsg = 75.0;
  static const _heightWithErrorMsg = 100.0;
  static const _heightOfErrorMsg = 25.0;
  static const _heightOfNoErrorMsg = 0.0;

  static const _quickDuration = 300;
  static const _slowDuration = 1000;

  double? _containerHeight = _heightWithoutErrorMsg;
  double _errorContainerHeight = _heightOfNoErrorMsg;
  String _errorMessage = "";
  int _containerHeightChangeTime = _slowDuration;
  int _errorMsgHeightChangeTime = _quickDuration;

  bool _addressComponentEnabled = false;

  @override
  void initState() {
    super.initState();
    _addressComponentEnabled = DataUtils.isBlank(widget._addressComponentValue);
    _setInitialState();
  }

  @override
  Widget build(final BuildContext context) {
    final TextField addressComponentTextField = _buildTextField();
    return AnimatedContainer(
        height: _containerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _containerHeightChangeTime),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
                child: Row(children: <Widget>[
                  Expanded(
                      flex: 1, child: Text(widget._addressComponentName, style: Theme.of(context).textTheme.titleSmall,
                      textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
                  Expanded(
                      flex: 3,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_getAddressComponentField(addressComponentTextField), _getErrorMsgField()]))
                ]))));
  }

  TextField _buildTextField() {
    return TextField(
        controller: widget._addressComponentEditingController, // Add this
        style: Theme.of(context).textTheme.titleSmall,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        enabled: _addressComponentEnabled && !widget._backendUpdateInProgress,
        decoration: InputDecoration(
            hintText:
                !_addressComponentEnabled ? widget._addressComponentValue : 'Enter ${widget._addressComponentName}'),
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
        padding: EdgeInsets.only(top: _errorContainerHeight == _heightOfErrorMsg ? 5 : 0),
        height: _errorContainerHeight,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: _errorMsgHeightChangeTime),
        child: Text(_errorMessage,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error),
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }

  Widget _getAddressComponentField(final TextField addressComponentTextField) {
    return _addressComponentEnabled
        ? addressComponentTextField
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: IgnorePointer(child: addressComponentTextField),
            onTap: () {
              WidgetUtils.showToastMessage(context, '${widget._addressComponentName} cannot be changed');
            });
  }

  void _setInitialState() {
    _errorContainerHeight = _heightOfNoErrorMsg;
    _containerHeight = _heightWithoutErrorMsg;
    _errorMessage = "";
    _containerHeightChangeTime = _slowDuration;
    _errorMsgHeightChangeTime = _quickDuration;
  }

  void _setUpdatedWidgetHeight() {
    if (_addressComponentEnabled) {
      final bool isValid = DataUtils.isNotBlank(widget._addressComponentEditingController.text);
      if (!isValid) {
        _containerHeight = _heightWithErrorMsg;
        _errorContainerHeight = _heightOfErrorMsg;
        _errorMessage = "${widget._addressComponentName} not valid";
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
}
