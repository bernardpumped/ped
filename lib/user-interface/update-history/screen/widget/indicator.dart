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

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator(
      {Key? key,
      required this.color,
      required this.text,
      required this.isSquare,
      this.size = 16,
      this.textColor = Colors.indigo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: isSquare ? BoxShape.rectangle : BoxShape.circle, color: color)),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor))
    ]);
  }
}
