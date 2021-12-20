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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class SaveUndoButtonWidget extends StatefulWidget {
  final Function onSave;
  final Function onCancel;
  final bool onValueChange;
  final bool saveButtonDisabled;
  final bool undoButtonDisabled;
  SaveUndoButtonWidget(
      {this.onSave,
      this.onCancel,
      this.onValueChange = false,
      this.saveButtonDisabled = false,
      this.undoButtonDisabled = false});

  @override
  _SaveUndoButtonWidgetState createState() => _SaveUndoButtonWidgetState();
}

class _SaveUndoButtonWidgetState extends State<SaveUndoButtonWidget> {
  static const _TAG = 'SaveUndoButtonWidget';
  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      height: widget.onValueChange ? 50 : 0,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: _getButtonRow(),
    );
  }

  Row _getButtonRow() {
    return Row(children: [
      WidgetUtils.getRoundedElevatedButton(
          child: Text('Undo'),
          backgroundColor: FontsAndColors.vividBlueTextColor,
          foreGroundColor: Colors.white,
          borderRadius: 18.0,
          onPressed: () {
            if (!widget.undoButtonDisabled) {
              widget.onCancel();
            } else {
              LogUtil.debug(_TAG, 'Undo button is disabled');
            }
          }),
      WidgetUtils.getRoundedElevatedButton(
          child: Text('Save'),
          backgroundColor: FontsAndColors.vividBlueTextColor,
          foreGroundColor: Colors.white,
          borderRadius: 18.0,
          onPressed: () {
            if (!widget.saveButtonDisabled) {
              widget.onSave();
            } else {
              LogUtil.debug(_TAG, 'Save Button is disabled');
            }
          })
    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }
}
