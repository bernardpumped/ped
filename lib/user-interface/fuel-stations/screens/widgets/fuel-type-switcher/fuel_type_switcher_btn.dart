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

class FuelTypeSwitcherButton extends StatelessWidget {
  final String _txtToDisplay;
  final Function() _trailingButtonAction;
  const FuelTypeSwitcherButton(this._txtToDisplay, this._trailingButtonAction, {Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
        onTap: () {
          _trailingButtonAction();
        },
        child: Container(
          // Intentionally using Theme.of(context).textTheme.headline1!.color! for fill color, because using primaryColor
          // for border does not work well when theme is dark.
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24), color: Theme.of(context).highlightColor),
            child: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14, top: 12, bottom: 12),
                child: Row(children: [
                  Icon(Icons.workspaces_outline, color: Theme.of(context).colorScheme.background, size: 25),
                  const SizedBox(width: 8),
                  Text(_txtToDisplay,
                      textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.background)),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.background, size: 25)
                ]))));
  }
}
