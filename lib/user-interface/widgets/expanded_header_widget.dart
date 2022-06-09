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
import 'package:pumped_end_device/user-interface/fuel-station-details/fuel_station_details_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_logo_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/qld_fuel_station_source_citation.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class ExpandedHeaderWidget extends StatelessWidget {
  final FuelStation fuelStation;
  final bool showPriceSource;
  ExpandedHeaderWidget({Key? key, required this.fuelStation, this.showPriceSource = true}) : super(key: key);

  final FuelStationDetailsScreenColorScheme colorScheme =
      getIt.get<FuelStationDetailsScreenColorScheme>(instanceName: fsDetailsScreenColorSchemeName);

  @override
  Widget build(final BuildContext context) {
    return Container(
        color: colorScheme.backgroundColor,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: <
              Widget>[
            FuelStationLogoWidget(width: 75, height: 75, image: NetworkImage(fuelStation.merchantLogoUrl)),
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Padding(padding: const EdgeInsets.only(bottom: 8, left: 8), child: _getFuelStationName(fuelStation)),
                  Padding(padding: const EdgeInsets.only(bottom: 8, left: 8), child: _getDistanceWidget(fuelStation)),
                  showPriceSource
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 8),
                          child: _getFuelAuthorityQuotePublisher(fuelStation, context))
                      : const SizedBox(width: 0),
                  _getRatingWidget(fuelStation)
                ]))
          ])
        ]));
  }

  Widget _getFuelStationName(final FuelStation fuelStation) {
    String fsName;
    if (fuelStation.fuelStationAddress.locality != null) {
      fsName = '${fuelStation.fuelStationName} ${fuelStation.fuelStationAddress.locality}';
    } else {
      fsName = fuelStation.fuelStationName;
    }
    fsName = fsName.toTitleCase();
    return Text(fsName,
        style: TextStyle(fontSize: 19, color: colorScheme.fuelStationTitleTextColor, fontWeight: FontWeight.w700),
        overflow: TextOverflow.ellipsis,
        maxLines: 2);
  }

  Widget _getFuelAuthorityQuotePublisher(final FuelStation fuelStation, final BuildContext context) {
    if (fuelStation.fuelQuotes().isNotEmpty) {
      final List<String?> publishers = fuelStation
          .fuelQuotes()
          .where((fq) => fq.fuelQuoteSource != null && fq.fuelQuoteSource != 'C')
          .map((fq) => fq.fuelQuoteSourceName)
          .toList();
      if (publishers.isNotEmpty) {
        return Row(children: [
          Text('Fuel Price Source ${publishers[0]} ',
              style:
                  TextStyle(fontSize: 16, color: colorScheme.fuelStationDetailsTextColor, fontWeight: FontWeight.w500)),
          _getFuelStationSourceCitationIcon(publishers, context, fuelStation)
        ]);
      }
    }
    return const SizedBox(width: 0);
  }

  Widget _getFuelStationSourceCitationIcon(
      final List<String?> publishers, final BuildContext context, final FuelStation fuelStation) {
    if (publishers[0] == 'qld') {
      return GestureDetector(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                context: context,
                builder: (context) => QldFuelStationSourceCitation(fuelStation: fuelStation),
                backgroundColor: colorScheme.backgroundColor);
          },
          child: Icon(Icons.info_outline, color: colorScheme.fuelStationDetailsTextColor, size: 20)); // Info icon
    } else {
      return const SizedBox(width: 0);
    }
  }

  Widget _getDistanceWidget(final FuelStation fuelStation) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Text('Petrol Station', style: TextStyle(fontSize: 16, color: colorScheme.fuelStationDetailsTextColor)),
      const SizedBox(width: 10),
      Icon(Icons.drive_eta, color: colorScheme.fuelStationDetailsTextColor, size: 20), // drive_eta icon
      Text(' ${DataUtils.toPrecision(fuelStation.distance, 2)} km',
          style: TextStyle(fontSize: 16, color: colorScheme.fuelStationDetailsTextColor))
    ]);
  }

  SingleChildRenderObjectWidget _getRatingWidget(final FuelStation fuelStation) {
    return fuelStation.rating != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text(' ${fuelStation.rating}',
                  style: TextStyle(fontSize: 14, color: colorScheme.fuelStationDetailsTextColor)),
              const SizedBox(width: 3),
              WidgetUtils.getRating(fuelStation.rating, 16)
            ]))
        : const SizedBox(width: 0);
  }
}
