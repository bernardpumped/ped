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

import 'package:flutter/foundation.dart';

class LogUtil {
  static const _debug = 1;
  static const _info = 2;
  static const _error = 3;

  static const _logLevel = _debug;

  static void debug(final String tag, final String logStatement) {
    if (_debug >= _logLevel) {
      // debugPrint('[${DateTime.now()}]: DEBUG: $tag : $logStatement');
      debugPrint('[${DateTime.now()}]: DEBUG: $tag : $logStatement');
    }
  }

  static void info(final String tag, final String logStatement) {
    if (_info >= _logLevel) {
      debugPrint('[${DateTime.now()}]: INFO: $tag : $logStatement');
    }
  }

  static void error(final String tag, final String logStatement) {
    if (_error >= _logLevel) {
      debugPrint('[${DateTime.now()}]: ERROR: $tag : $logStatement');
    }
  }
}