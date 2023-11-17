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

class FuelStationLogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final ImageProvider image;
  final double padding;
  final double borderRadius;
  const FuelStationLogoWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.image,
      this.padding = 8,
      this.borderRadius = 10});

  @override
  Widget build(final BuildContext context) {
    return Card(
        elevation: 1,
        child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(padding),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(fit: BoxFit.scaleDown, image: image)))));
  }
}
