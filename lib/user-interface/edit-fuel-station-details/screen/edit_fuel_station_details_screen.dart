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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-contact/edit_contact_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-features/edit_features_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-fuel-price-widgets/edit_fuel_price_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-operating-time-widget/edit_operating_time_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/suggest-edit/suggest_edit_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/expanded_header_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';
import 'package:pumped_end_device/util/log_util.dart';

class EditFuelStationDetailsScreen extends StatefulWidget {
  static const routeName = '/editFuelStationDetails2';
  const EditFuelStationDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EditFuelStationDetailsScreen> createState() => _EditFuelStationDetailsScreenState();
}

class _EditFuelStationDetailsScreenState extends State<EditFuelStationDetailsScreen>
    with SingleTickerProviderStateMixin {
  static const _tag = 'EditFuelStationDetailsScreen';
  late EditFuelStationDetailsParams params;

  @override
  void initState() {
    super.initState();
    underMaintenanceDocRef.snapshots().listen((event) {
      if (!mounted) return;
      WidgetUtils.showPumpedUnavailabilityMessage(event, context);
      LogUtil.debug(_tag, '${event.data}');
    });
  }

  @override
  Widget build(final BuildContext context) {
    params = ModalRoute.of(context)?.settings.arguments as EditFuelStationDetailsParams;
    return Scaffold(appBar: const PumpedAppBar(), body: _drawBody());
  }

  Widget _drawBody() {
    return SingleChildScrollView(
        child: Container(
            color: const Color(0xFFF0EDFF),
            child: Column(children: [
              ExpandedHeaderWidget(fuelStation: params.fuelStation, showPriceSource: false),
              _bodyContentWidget(params.fuelStation)
            ])));
  }

  Widget _bodyContentWidget(final FuelStation fuelStation) {
    if (params.editFuelPrices) {
      return EditFuelPriceWidget(params.fuelStation, 250);
    } else if (params.editDetails) {
      return EditContactWidget(params.fuelStation, 250);
    } else if (params.editOperatingTime) {
      return EditOperatingTimeWidget(params.fuelStation, 250);
    } else if (params.editFeatures){
      return EditFeaturesWidget(params.fuelStation, 250);
    } else if (params.suggestEdit) {
      return SuggestEditWidget(params.fuelStation, 250);
    }
    return const Text('Some Error Happened');
  }

  undoFunction() {
    setState(() {});
  }
}
