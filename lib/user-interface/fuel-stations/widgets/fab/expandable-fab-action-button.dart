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

@immutable
class ExpandableFabActionButton extends StatelessWidget {
  const ExpandableFabActionButton({
    Key? key,
    this.onPressed,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
        labelPadding: const EdgeInsets.all(5.0),
        avatar: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.secondary, child: icon),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(8.0));
  }
}