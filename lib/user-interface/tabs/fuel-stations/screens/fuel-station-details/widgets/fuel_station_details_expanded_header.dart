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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/image_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/fuel_station_source_citation.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class FuelStationDetailsExpandedHeader extends StatelessWidget {
  static Color _fuelStationDetailsColors = FontsAndColors.pumpedFuelStationDetailsColor;
  static const _distanceIcon = Icon(IconData(IconCodes.distance_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: Colors.black87, size: 18);

  final FuelStation fuelStation;

  const FuelStationDetailsExpandedHeader({Key key, this.fuelStation}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ImageWidget(
                    imageUrl: fuelStation.merchantLogoUrl, width: 75, height: 75, padding: EdgeInsets.only(right: 20)),
                Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Padding(padding: EdgeInsets.only(bottom: 5), child: _getFuelStationName(fuelStation)),
                      Padding(padding: EdgeInsets.only(bottom: 5), child: _getDistanceWidget(fuelStation)),
                      Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: _getFuelAuthorityQuotePublisher(fuelStation, context)),
                      _getRatingWidget(fuelStation)
                    ]))
              ])
        ]));
  }

  Widget _getFuelStationName(final FuelStation fuelStation) {
    return Text(fuelStation.fuelStationName + ' ' + fuelStation.fuelStationAddress.locality,
        style: TextStyle(fontSize: 19, color: Colors.black87, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis);
  }

  Widget _getFuelAuthorityQuotePublisher(final FuelStation fuelStation, final BuildContext context) {
    if (fuelStation.fuelQuotes() != null) {
      final List<String> publishers = fuelStation
          .fuelQuotes()
          .where((fq) => fq.fuelQuoteSource != null && fq.fuelQuoteSource != 'C')
          .map((fq) => fq.fuelQuoteSourceName)
          .toList();
      if (publishers != null && publishers.length > 0) {
        return Row(children: [
          Text('Fuel Price Source ${publishers[0]}',
              style: TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
          _getFuelStationSourceCitationIcon(publishers, context, fuelStation)
        ]);
      }
    }
    return SizedBox(width: 0);
  }

  Widget _getFuelStationSourceCitationIcon(
      final List<String> publishers, final BuildContext context, final FuelStation fuelStation) {
    if (publishers[0] == 'qld') {
      return GestureDetector(
          onTap: () {
            showCupertinoDialog(
                context: context, builder: (context) => FuelStationSourceCitation(fuelStation: fuelStation));
          },
          child: PumpedIcons.faSourceIcon_black54Size20); // Info icon
    } else {
      return SizedBox(width: 0);
    }
  }

  Widget _getDistanceWidget(final FuelStation fuelStation) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Text('Petrol Station', style: TextStyle(fontSize: 14, color: _fuelStationDetailsColors)),
      SizedBox(width: 10),
      _distanceIcon, // drive_eta icon
      Text(' ${DataUtils.toPrecision(fuelStation.distance, 2)} km', style: TextStyle(color: _fuelStationDetailsColors))
    ]);
  }

  SingleChildRenderObjectWidget _getRatingWidget(final FuelStation fuelStation) {
    return fuelStation.rating != null
        ? Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              Text(' ${fuelStation.rating}', style: TextStyle(fontSize: 14, color: _fuelStationDetailsColors)),
              SizedBox(width: 3),
              WidgetUtils.getRating(fuelStation.rating, 16)
            ]))
        : SizedBox(width: 0);
  }
}
