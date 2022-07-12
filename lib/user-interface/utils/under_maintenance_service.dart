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
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UnderMaintenanceService {
  static const _tag = 'UnderMaintenanceService';
  late DocumentReference underMaintenanceDocRef;
  late bool initialized;

  final Map<String, StreamSubscription> subscriptionMap = {};

  static final UnderMaintenanceService instance = UnderMaintenanceService._();

  UnderMaintenanceService._(){
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      underMaintenanceDocRef = FirebaseFirestore.instance.collection("pumped-documents").doc("under-maintenance");
      initialized = true;
    }
  }

  Future<UnderMaintenance> isUnderMaintenance() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final DocumentSnapshot snapshot = await underMaintenanceDocRef.get();
      final bool underMaintenance = snapshot['underMaintenance'] ?? false;
      if (underMaintenance) {
        final String underMaintenanceMsg = snapshot['maintenanceMessage'];
        return UnderMaintenance(underMaintenance, underMaintenanceMsg);
      }
    }
    return UnderMaintenance(false, 'Not Under Maintenance');
  }

  void registerSubscription(final String key, final BuildContext context, final Function function) {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      if (subscriptionMap.containsKey(key)) {
        LogUtil.debug(_tag, 'Subscription already registered for key $key');
      } else {
        LogUtil.debug(_tag, 'Registering Subscription for key $key');
      }
      subscriptionMap.putIfAbsent(
          key,
          () => underMaintenanceDocRef.snapshots().listen((event) {
                function(event, context);
              }));
    } else {
      LogUtil.debug(_tag, 'Platform does not support firebase yet');
    }
  }

  void cancelSubscription(final String key) {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      if (subscriptionMap.containsKey(key)) {
        subscriptionMap[key]?.cancel();
        LogUtil.debug(_tag, 'Cancelled subscription with key $key');
        subscriptionMap.remove(key);
        return;
      } else {
        LogUtil.debug(_tag, 'No subscription found with key $key for cancellation');
      }
    } else {
      LogUtil.debug(_tag, 'Platform does not support firebase yet');
    }
  }
}

class UnderMaintenance {
  final bool isUnderMaintenance;
  final String underMaintenanceMessage;

  UnderMaintenance(this.isUnderMaintenance, this.underMaintenanceMessage);
}
