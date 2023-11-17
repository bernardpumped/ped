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
import 'package:pumped_end_device/models/update_type.dart';
import 'package:pumped_end_device/user-interface/update-history/model/update_tile_data.dart';
import 'package:pumped_end_device/user-interface/update-history/screen/widget/update_history_details_item_widget.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';

class UpdateHistoryDetailsScreen extends StatelessWidget {
  static const routeName = '/ped/edit-history/details';
  const UpdateHistoryDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final UpdateTileData params = ModalRoute.of(context)?.settings.arguments as UpdateTileData;
    return Scaffold(
        appBar: const PumpedAppBar(title: 'Pumped Update History'),
        body: SingleChildScrollView(
            child: Container(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: double.infinity),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getBody(context, params)))));
  }

  List<Widget> _getBody(final BuildContext context, final UpdateTileData params) {
    final List<Widget> body = [];
    body.add(Padding(child: _getSubtitle(context, params), padding: const EdgeInsets.only(left: 20, top: 10)));
    body.add(const SizedBox(height: 8));
    for (var element in params.updateRecords) {
      body.add(UpdateHistoryDetailsItemWidget(element));
    }
    return body;
  }

  _getSubtitle(final BuildContext context, final UpdateTileData params) {
    return Row(children: [
      _getIcon(params),
      const SizedBox(width: 10),
      Text('${params.updateType.updateTypeReadableName} Updates',
          style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,
          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
    ]);
  }

  _getIcon(final UpdateTileData params) {
    IconData? iconData;
    if (params.updateType == UpdateType.price) {
      iconData = Icons.monetization_on_outlined;
    } else if (params.updateType == UpdateType.operatingTime) {
      iconData = Icons.access_time;
    } else if (params.updateType == UpdateType.fuelStationFeatures) {
      iconData = Icons.flag_outlined;
    } else if (params.updateType == UpdateType.addressDetails) {
      iconData = Icons.location_on_outlined;
    } else {
      iconData = Icons.comment_outlined;
    }
    return Icon(iconData, size: 30);
  }
}
