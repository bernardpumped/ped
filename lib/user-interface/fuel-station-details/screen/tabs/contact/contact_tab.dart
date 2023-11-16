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
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/model/request/get_fuel_station_operating_hrs_request.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/model/response/get_fuel_station_operating_hrs_response.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/response-parser/get_fuel_station_operating_hrs_response_parser.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/operating_hours_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/get_fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/horizontal_scroll_list_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class ContactTabWidget extends StatefulWidget {
  final FuelStation _fuelStation;

  const ContactTabWidget(this._fuelStation, {Key? key}) : super(key: key);

  @override
  State<ContactTabWidget> createState() => _ContactTabWidgetState();
}

class _ContactTabWidgetState extends State<ContactTabWidget> {
  static const _tag = 'OverviewTabWidget';

  @override
  void initState() {
    super.initState();
  }

  Future<GetFuelStationOperatingHrsResponse> _getFuelStationOperatingHrsFuture() async {
    try {
      final GetFuelStationOperatingHrsRequest request = GetFuelStationOperatingHrsRequest(
          requestUuid: const Uuid().v1(),
          fuelStationId: widget._fuelStation.stationId,
          fuelStationSource: widget._fuelStation.getFuelStationSource());
      return await GetFuelStationOperatingHrs(GetFuelStationOperatingHrsResponseParser()).execute(request);
    } on Exception catch (e, s) {
      LogUtil.debug(_tag, 'Exception occurred while calling GetFuelStationOperatingHrsNew.execute $s');
      return GetFuelStationOperatingHrsResponse(
          'CALL-EXCEPTION', s.toString(), {}, DateTime.now().millisecondsSinceEpoch, null);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final FuelStation fuelStation = widget._fuelStation;
    final FuelStationAddress fuelStationAddress = fuelStation.fuelStationAddress;
    final bool phonePresent = fuelStationAddress.phone1 != null || fuelStationAddress.phone2 != null;
    bool imgUrlsPresent = fuelStation.imgUrls != null && fuelStation.imgUrls!.isNotEmpty;
    return Column(children: <Widget>[
      imgUrlsPresent
          ? Container(
              margin: const EdgeInsets.only(top: 7, bottom: 7), child: HorizontalScrollListWidget(fuelStation.imgUrls!))
          : const SizedBox(width: 0),
      imgUrlsPresent
          ? const Divider(indent: 15, endIndent: 15, height: 0)
          : const SizedBox(width: 0),
      const SizedBox(height: 5),
      _getFuelStationAddressWidget(fuelStationAddress),
      Card(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: OperatingHoursWidget(
                  fuelStation: fuelStation, operatingHrsResponseFuture: _getFuelStationOperatingHrsFuture()))),
      phonePresent ? _getPhoneNumberWidget(fuelStationAddress) : const SizedBox(width: 0)
    ]);
  }

  Widget _getFuelStationAddressWidget(final FuelStationAddress fuelStationAddress) {
    return Card(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
              contentPadding: const EdgeInsets.only(left: 20, right: 5, top: 3, bottom: 7),
              leading: const Icon(Icons.location_on_outlined, size: 36),
              title: _getFuelStationAddress(fuelStationAddress)),
        ));
  }

  Widget _getPhoneNumberWidget(final FuelStationAddress fuelStationAddress) {
    return Card(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 5),
                leading: const Icon(Icons.phone_outlined, size: 40),
                title: _getPhone(fuelStationAddress))));
  }

  Widget _getFuelStationAddress(final FuelStationAddress fuelStationAddress) {
    String address = '${fuelStationAddress.addressLine1.toTitleCase()}, ${fuelStationAddress.locality?.toTitleCase()}, '
        '${fuelStationAddress.state} ${fuelStationAddress.zip}';
    return Text(address,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineSmall,
        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
  }

  Widget _getPhone(final FuelStationAddress fuelStationAddress) {
    String? phoneN;
    if (fuelStationAddress.phone1 != null) {
      phoneN = fuelStationAddress.phone1;
    }
    if (DataUtils.isNotBlank(phoneN)) {
      if (fuelStationAddress.phone2 != null) {
        phoneN = '$phoneN, ${fuelStationAddress.phone2}';
      }
    } else {
      phoneN = fuelStationAddress.phone2;
    }
    if (DataUtils.isNotBlank(phoneN)) {
      return Text(phoneN!, style: Theme.of(context).textTheme.headlineSmall,
          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
    } else {
      return const SizedBox(width: 0);
    }
  }
}
