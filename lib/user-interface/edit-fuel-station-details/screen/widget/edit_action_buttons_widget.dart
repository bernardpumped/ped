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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/log_util.dart';

class EditActionButton extends StatelessWidget {
  static const _tag = 'EditActionButton';
  final String tag;
  final Function undoButtonAction;
  final Function saveButtonAction;
  const EditActionButton({required this.undoButtonAction, required this.saveButtonAction, required this.tag, super.key});

  @override
  Widget build(final BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          child: OutlinedButton(
              onPressed: () {
                LogUtil.debug(_tag, 'undo Button clicked');
                undoButtonAction();
              },
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(children: [const Icon(Icons.history, size: 24), const SizedBox(width: 10),
                    Text('Undo', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)])))),
      const SizedBox(width: 20),
      AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          child: OutlinedButton(
              onPressed: () {
                LogUtil.debug(_tag, 'undo Button clicked');
                saveButtonAction();
              },
              child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(children: [const Icon(Icons.sync, size: 24), const SizedBox(width: 10),
                    Text('Save', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)]))))
    ]);
  }
}
