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

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularImageWidget extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;
  final double width;
  final double height;
  final double margin;
  final Color color;
  final double marginWidth;

  CircularImageWidget(
      {@required this.imagePath,
      @required this.isNetworkImage,
      @required this.width,
      @required this.height,
      this.margin = 0,
      this.color = Colors.deepPurple,
      this.marginWidth = 1});

  @override
  Widget build(final BuildContext context) {
    final double innerCircleRadius = sqrt(width * width + height * height) / 2;
    return new Container(
        margin: EdgeInsets.all(margin),
        width: width,
        height: height,
        decoration: new BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: color, width: marginWidth), color: Colors.white),
        alignment: Alignment.center,
        child: Container(
            alignment: Alignment.center,
            width: innerCircleRadius,
            height: innerCircleRadius,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.scaleDown, image: isNetworkImage ? NetworkImage(imagePath) : AssetImage(imagePath)))));
  }
}
