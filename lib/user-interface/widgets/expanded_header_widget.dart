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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/contact/widget/action_bar.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/sa_fuel_station_source_citation.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_logo_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/qld_fuel_station_source_citation.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class ExpandedHeaderWidget extends StatelessWidget {
  final FuelStation fuelStation;
  final bool showPriceSource;
  const ExpandedHeaderWidget({Key? key, required this.fuelStation, this.showPriceSource = true}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Card(
        // margin: const EdgeInsets.all(6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FuelStationLogoWidget(width: 130, height: 130, image: NetworkImage(fuelStation.merchantLogoUrl)),
                Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 8, top: 12),
                          child: _getFuelStationName(context, fuelStation)),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 8),
                          child: _getDistanceWidget(context, fuelStation)),
                      showPriceSource
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 8),
                              child: _getFuelAuthorityQuotePublisher(fuelStation, context))
                          : const SizedBox(width: 0),
                      _getRatingWidget(context, fuelStation)
                    ]))
              ]),
          ActionBar(fuelStation: fuelStation)
        ]));
  }

  Widget _getFuelStationName(final BuildContext context, final FuelStation fuelStation) {
    String fsName;
    if (fuelStation.fuelStationAddress.locality != null) {
      fsName = '${fuelStation.fuelStationName} ${fuelStation.fuelStationAddress.locality}';
    } else {
      fsName = fuelStation.fuelStationName;
    }
    fsName = fsName.toTitleCase();
    if (fuelStation.isFaStation && 'unmatched' == fuelStation.fuelAuthMatchStatus) {
      fsName = '$fsName**';
    }
    return Text(fsName, style: Theme.of(context).textTheme.displayMedium, overflow: TextOverflow.ellipsis, maxLines: 2,
        textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor);
  }

  Widget _getFuelAuthorityQuotePublisher(final FuelStation fuelStation, final BuildContext context) {
    if (fuelStation.fuelQuotes().isNotEmpty) {
      final List<String?> publishers = fuelStation.getPublishers();
      if (publishers.isNotEmpty) {
        return Row(children: [
          Text('Fuel Price Source ${publishers[0]} ', style: Theme.of(context).textTheme.titleLarge,
              textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
          _getFuelStationSourceCitationIcon(publishers, context, fuelStation)
        ]);
      }
    }
    return const SizedBox(width: 0);
  }

  Widget _getFuelStationSourceCitationIcon(
      final List<String?> publishers, final BuildContext context, final FuelStation fuelStation) {
    Widget content = (publishers[0] == 'qld')
        ? QldFuelStationSourceCitation(fuelStation: fuelStation)
        : ((publishers[0] == 'sa') ? const SaFuelStationSourceCitation() : const SizedBox(width: 0));
    if (publishers[0] == 'qld' || publishers[0] == 'sa') {
      return GestureDetector(
          onTap: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (final BuildContext context) {
                  return AlertDialog(
                      contentPadding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), side: const BorderSide(width: 0.2)),
                      content: content);
                });
          },
          child: const Icon(Icons.info_outline, size: 24)); // Info icon
    } else {
      return const SizedBox(width: 0);
    }
  }

  Widget _getDistanceWidget(final BuildContext context, final FuelStation fuelStation) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Text('Petrol Station', style: Theme.of(context).textTheme.titleLarge,
          textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
      const SizedBox(width: 10),
      const Icon(Icons.drive_eta, size: 20), // drive_eta icon
      Text(' ${DataUtils.toPrecision(fuelStation.distance, 2)} km', style: Theme.of(context).textTheme.titleLarge,
          textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor)
    ]);
  }

  SingleChildRenderObjectWidget _getRatingWidget(final BuildContext context, final FuelStation fuelStation) {
    return fuelStation.rating != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 3, left: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text(' ${fuelStation.rating}', style: Theme.of(context).textTheme.titleLarge,
                  textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
              const SizedBox(width: 3),
              RatingBarIndicator(
                  rating: fuelStation.rating!,
                  itemBuilder: (context, index) => Icon(Icons.star, color: Theme.of(context).highlightColor),
                  itemCount: 5,
                  itemSize: 22,
                  direction: Axis.horizontal) //22 comes from titleLarge
            ]))
        : const SizedBox(width: 0);
  }
}
