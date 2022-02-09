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

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:pumped_end_device/util/log_util.dart';

class LocationServiceSubscription {
  static const _tag = 'LocationServiceSubscription';

  final StreamSubscription<Position> _positionSubscription;

  LocationServiceSubscription(this._positionSubscription);
  
  void cancel(final Function whenCompleteFunction) {
    if (_positionSubscription != null) {
      _positionSubscription.cancel().whenComplete(() => whenCompleteFunction);
    } else {
      LogUtil.debug(_tag, "LocationDataSubscription is null. Cannot cancel");
    }
  }
}