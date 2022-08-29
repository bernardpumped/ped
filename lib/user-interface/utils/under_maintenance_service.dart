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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UnderMaintenanceService {
  static const _tag = 'UnderMaintenanceService';
  late bool initialized;

  final Map<String, StreamSubscription> subscriptionMap = {};

  static final UnderMaintenanceService instance = UnderMaintenanceService._();

  UnderMaintenanceService._(){
    initialized = true;
  }

  Future<UnderMaintenance> isUnderMaintenance() async {
    return UnderMaintenance(false, 'Not Under Maintenance');
  }

  void registerSubscription(final String key, final BuildContext context, final Function function) {
    LogUtil.debug(_tag, 'Registering a subscription for function with key $key');
    // Implement a mechanism, which keeps checking the unavailability over the time,
    // It also registers a function against a key.
    // The functions are invoked
  }

  void cancelSubscription(final String key) {
    LogUtil.debug(_tag, 'Registering a subscription for function with key $key');
    //  Implement the logic to cancel subscription.
  }
}

class UnderMaintenance {
  final bool isUnderMaintenance;
  final String underMaintenanceMessage;

  UnderMaintenance(this.isUnderMaintenance, this.underMaintenanceMessage);
}
