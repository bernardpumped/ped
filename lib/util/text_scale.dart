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

import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class TextScale {
  static const _tag = "TextScale";

  static const systemTextScale = 'SYSTEM_TEXT_SCALE';
  static const systemTextScaleReadableName = 'System';
  static const systemTextScaleValue = 1.0;

  static const smallTextScale = 'SMALL_TEXT_SCALE';
  static const smallTextScaleReadableName = 'Small';
  static const smallTextScaleValue = 0.8;

  static const mediumTextScale = 'MEDIUM_TEXT_SCALE';
  static const mediumTextScaleReadableName = 'Medium';
  static const mediumTextScaleValue = 1.0;

  static const largeTextScale = 'LARGE_TEXT_SCALE';
  static const largeTextScaleReadableName = 'Large';
  static const largeTextScaleValue = 1.2;

  static const hugeTextScale = 'HUGE_TEXT_SCALE';
  static const hugeTextScaleReadableName = 'Huge';
  static const hugeTextScaleValue = 1.4;

  static getTextScale(final String textScaleId) {
    LogUtil.debug(_tag, 'textScale : $textScaleId value');
    if (DataUtils.isNotBlank(textScaleId)) {
      switch (textScaleId) {
        case systemTextScale:
          return systemTextScaleReadableName;
        case smallTextScale:
          return smallTextScaleReadableName;
        case mediumTextScale:
          return mediumTextScaleReadableName;
        case largeTextScale:
          return largeTextScaleReadableName;
        case hugeTextScale:
          return hugeTextScaleReadableName;
        default:
          throw Exception('Invalid textScale : $textScaleId');
      }
    }
  }

  static getTextScaleValue(final String textScaleId) {
    LogUtil.debug(_tag, 'textScaleValue : $textScaleId value');
    if (DataUtils.isNotBlank(textScaleId)) {
      switch (textScaleId) {
        case systemTextScale:
          return systemTextScaleValue;
        case smallTextScale:
          return smallTextScaleValue;
        case mediumTextScale:
          return mediumTextScaleValue;
        case largeTextScale:
          return largeTextScaleValue;
        case hugeTextScale:
          return hugeTextScaleValue;
        default:
          throw Exception('Invalid textScaleValue : $textScaleId');
      }
    }
  }
}