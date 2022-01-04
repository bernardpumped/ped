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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalScrollListWidget extends StatelessWidget {
  final List<String> _imageUrls;

  HorizontalScrollListWidget(this._imageUrls);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150.0,
        child: ListView.builder(
            itemBuilder: (context, index) {
              return _buildImageView(_imageUrls[index]);
            },
            itemCount: _imageUrls.length,
            scrollDirection: Axis.horizontal));
  }

  Padding _buildImageView(final String imgUrl) {
    return Padding(
        padding: EdgeInsets.only(left: 5),
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
                color: Colors.white),
            width: 170.0));
  }
}
