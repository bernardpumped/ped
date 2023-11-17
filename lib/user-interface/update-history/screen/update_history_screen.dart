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
import 'package:pumped_end_device/data/local/dao2/update_history_dao.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/nav-drawer/nav_drawer_widget.dart';
import 'package:pumped_end_device/user-interface/update-history/model/update_tile_data.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_distribution_pie_chart.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_tile.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/under_maintenance_service.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UpdateHistoryScreen extends StatefulWidget {
  static const routeName = '/ped/edit-history/summary';
  static const viewLabel = 'Updates History';
  static const viewIcon = Icons.update_outlined;
  static const viewSelectedIcon = Icons.update;

  const UpdateHistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdateHistoryScreenState();
  }
}

class _UpdateHistoryScreenState extends State<UpdateHistoryScreen> {
  static const _tag = 'UpdateHistoryScreen';
  Future<List<UpdateHistory>>? updateHistoryFuture;
  final UnderMaintenanceService _underMaintenanceService =
      getIt.get<UnderMaintenanceService>(instanceName: underMaintenanceServiceName);

  @override
  void initState() {
    super.initState();
    _underMaintenanceService.registerSubscription(_tag, context, (event, context) {
      if (!mounted) return;
      WidgetUtils.showPumpedUnavailabilityMessage(event, context);
      LogUtil.debug(_tag, '${event.data}');
    });
    updateHistoryFuture = UpdateHistoryDao.instance.getAllUpdateHistory();
  }

  @override
  void dispose() {
    _underMaintenanceService.cancelSubscription(_tag);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: const PumpedAppBar(title: UpdateHistoryScreen.viewLabel, icon: UpdateHistoryScreen.viewSelectedIcon),
        drawer: const NavDrawerWidget(),
        body: SingleChildScrollView(
            child: Container(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: double.infinity),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_futureBuilder()]))));
  }

  _futureBuilder() {
    final List<Widget> widgets = [];
    return FutureBuilder<List<UpdateHistory>>(
        future: updateHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<UpdateHistory> data = snapshot.data!;
            final Map<UpdateType, double> successMap = _getUpdateTypeSuccessMap(data);
            final List<UpdateTileData> tileData = _getUpdateTileData(data);
            widgets.add(UpdateDistributionPieChart(successMap));
            for (var element in tileData) {
              if (element.success > 0 || element.failure > 0 || element.pending > 0) {
                widgets.add(UpdateTile(element));
              }
            }
            return Column(children: widgets);
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error Loading',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
                    textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Map<UpdateType, double> _getUpdateTypeSuccessMap(final List<UpdateHistory> updateHistoryRecords) {
    final Map<UpdateType, double> map = {};
    for (var updateHistory in updateHistoryRecords) {
      bool successResult = false;
      final String updateTypeName = updateHistory.updateType;
      final UpdateType updateType = _updateTypeNameToUpdateType[updateTypeName];
      if (_isSuccessResult(updateHistory)) {
        successResult = true;
      }
      if (successResult) {
        double successCount = map[updateType] ?? 0;
        if (successCount == 0) {
          successCount = 1;
        } else {
          successCount += 1;
        }
        map[updateType] = successCount;
      }
    }
    return map;
  }

  List<UpdateTileData> _getUpdateTileData(final List<UpdateHistory> updateHistoryRecords) {
    Map<UpdateType, UpdateTileData> map = {};
    for (var updateHistory in updateHistoryRecords) {
      final String updateTypeName = updateHistory.updateType;
      final UpdateType updateType = _updateTypeNameToUpdateType[updateTypeName];
      final UpdateTileData updateTileData = map.putIfAbsent(updateType, () => UpdateTileData(updateType, 0, 0, 0));
      updateTileData.updateRecords.add(updateHistory);
      if (_isSuccessResult(updateHistory)) {
        updateTileData.success++;
      } else if (updateHistory.responseCode == 'PENDING') {
        updateTileData.pending++;
      } else {
        updateTileData.failure++;
      }
    }
    return map.values.toList();
  }

  bool _isSuccessResult(final UpdateHistory updateHistory) {
    int size = 0;
    if (updateHistory.recordLevelExceptionCodes != null) {
      updateHistory.recordLevelExceptionCodes!.forEach((key, value) {
        List<dynamic> expCodes = value == null ? [] : value!;
        size += expCodes.length;
      });
    }
    return (updateHistory.responseCode == 'SUCCESS' &&
        (updateHistory.invalidArguments == null || updateHistory.invalidArguments!.isEmpty) &&
        size == 0);
  }

  final Map _updateTypeNameToUpdateType = {
    UpdateType.operatingTime.updateTypeName: UpdateType.operatingTime,
    UpdateType.price.updateTypeName: UpdateType.price,
    UpdateType.addressDetails.updateTypeName: UpdateType.addressDetails,
    UpdateType.phoneNumber.updateTypeName: UpdateType.phoneNumber,
    UpdateType.suggestEdit.updateTypeName: UpdateType.suggestEdit,
    UpdateType.fuelStationFeatures.updateTypeName: UpdateType.fuelStationFeatures
  };

  UpdateType? getUpdateType(final String updateTypeName) {
    return _updateTypeNameToUpdateType[updateTypeName];
  }
}
