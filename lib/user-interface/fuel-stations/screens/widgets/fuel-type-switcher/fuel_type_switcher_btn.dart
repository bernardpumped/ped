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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: Colors.indigo),
            child: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14, top: 12, bottom: 12),
                child: Row(children: [
                  const Icon(Icons.workspaces_outline, color: Colors.white, size: 25),
                  const SizedBox(width: 8),
                  Text(_txtToDisplay,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal)),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.white, size: 25)
                ]))));
  }
}
