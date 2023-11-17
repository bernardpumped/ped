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
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-contact/edit_contact_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-features/edit_features_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-fuel-price-widgets/edit_fuel_price_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/edit-operating-time-widget/edit_operating_time_widget.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/widget/suggest-edit/suggest_edit_widget.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/widgets/expanded_header_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_app_bar.dart';

class EditFuelStationDetailsScreen extends StatefulWidget {
  static const routeName = '/ped/fuel-stations/details/edit';
  const EditFuelStationDetailsScreen({super.key});

  @override
  State<EditFuelStationDetailsScreen> createState() => _EditFuelStationDetailsScreenState();
}

class _EditFuelStationDetailsScreenState extends State<EditFuelStationDetailsScreen>
    with SingleTickerProviderStateMixin {
  late EditFuelStationDetailsParams params;

  @override
  Widget build(final BuildContext context) {
    params = ModalRoute.of(context)?.settings.arguments as EditFuelStationDetailsParams;
    return Scaffold(
        appBar: const PumpedAppBar(title: 'Edit Fuel Station Details', icon: Icons.edit_location_alt_outlined),
        body: _drawBody());
  }

  Widget _drawBody() {
    return SingleChildScrollView(
        child: Column(children: [
      ExpandedHeaderWidget(fuelStation: params.fuelStation, showPriceSource: false),
      _bodyContentWidget(params.fuelStation)
    ]));
  }

  Widget _bodyContentWidget(final FuelStation fuelStation) {
    if (params.editFuelPrices) {
      return EditFuelPriceWidget(params, 250);
    } else if (params.editDetails) {
      return EditContactWidget(params, 250);
    } else if (params.editOperatingTime) {
      return EditOperatingTimeWidget(params, 250);
    } else if (params.editFeatures) {
      return EditFeaturesWidget(params, 250);
    } else if (params.suggestEdit) {
      return SuggestEditWidget(params, 250);
    }
    return Text('Some Error Happened', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
  }

  undoFunction() {
    setState(() {});
  }
}
