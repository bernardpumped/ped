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

class EditActionButton extends StatelessWidget {
  final Function undoButtonAction;
  final Function saveButtonAction;
  const EditActionButton({required this.undoButtonAction, required this.saveButtonAction, Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          width: 120,
          height: 40,
          child: FloatingActionButton.extended(
              backgroundColor: Colors.indigo,
              onPressed: () {
                undoButtonAction();
              },
              icon: const Icon(Icons.restore),
              label: const Center(child: Text("Undo", style: TextStyle(fontSize: 15, color: Colors.white))))),
      const SizedBox(width: 20),
      AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          width: 120,
          height: 40,
          child: FloatingActionButton.extended(
              backgroundColor: Colors.indigo,
              onPressed: () {
                saveButtonAction();
              },
              icon: const Icon(Icons.sync),
              label: const Center(child: Text("Save", style: TextStyle(fontSize: 15, color: Colors.white)))))
    ]);
  }
}
