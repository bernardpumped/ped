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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_logo_widget.dart';
import 'package:pumped_end_device/util/app_theme.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationListItemWidget extends StatelessWidget {
  static const _tag = 'FuelStationListItemWidget';
  final FuelStation fuelStation;
  final FuelType selectedFuelType;
  final Function parentRefresh;
  final Function setSelectedFuelStation;

  const FuelStationListItemWidget(
      {Key? key,
      required this.fuelStation,
      required this.selectedFuelType,
      required this.parentRefresh,
      required this.setSelectedFuelStation})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final FuelQuote? selectedFuelQuote = fuelStation.fuelTypeFuelQuoteMap[selectedFuelType.fuelType];
    return GestureDetector(
        onTap: () {
          LogUtil.debug(_tag, 'Calling onTap of GestureDetector');
          setSelectedFuelStation(fuelStation);
        },
        child: Card(
            margin: const EdgeInsets.all(4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    FuelStationLogoWidget(width: 100, height: 100, image: NetworkImage(fuelStation.merchantLogoUrl)),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          _getOpenCloseRatingDistanceWidget(context),
                          Padding(
                              padding: const EdgeInsets.only(left: 13, top: 5), child: _getStationNameWidget(context)),
                          Padding(
                              padding: const EdgeInsets.only(left: 13, top: 5),
                              child: _getStationAddressWidget(context))
                        ]))
                  ]),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    IntrinsicHeight(child: _getOffersWidget(context)),
                    const SizedBox(width: 15),
                    IntrinsicHeight(child: _getPriceWithDetailsWidget(selectedFuelQuote, context))
                  ])
                ]))));
  }

  Widget _getOpenCloseRatingDistanceWidget(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      _getOpenCloseWidget(context),
      const SizedBox(width: 10),
      _getRatingWidget(context),
      const SizedBox(width: 10),
      _getDistanceWidget(context)
    ]);
  }

  Widget _getStationAddressWidget(final BuildContext context) {
    return Text(
        '${fuelStation.fuelStationAddress.addressLine1}, ${fuelStation.fuelStationAddress.locality}'.toTitleCase(),
        style: Theme.of(context).textTheme.subtitle1!.copyWith(overflow: TextOverflow.ellipsis),
        maxLines: 1);
  }

  Widget _getStationNameWidget(final BuildContext context) => Text(fuelStation.fuelStationName.toTitleCase(),
      style: Theme.of(context).textTheme.headline4!.copyWith(overflow: TextOverflow.ellipsis));

  Widget _getRatingWidget(final BuildContext context) {
    if (fuelStation.rating != null) {
      final Widget childWidget = Row(children: [
        Text(fuelStation.rating.toString(), style: Theme.of(context).textTheme.caption),
        const SizedBox(width: 2),
        const Icon(Icons.star, size: 20)
      ]);
      return _getElevatedBoxSingleChild(childWidget, context);
    }
    return const SizedBox(width: 0);
  }

  Widget _getDistanceWidget(final BuildContext context) {
    int precisionDigits =
        fuelStation.distance >= 10 ? 0 : (fuelStation.distance >= 1 && fuelStation.distance < 10 ? 1 : 2);
    double distanced = DataUtils.toPrecision(fuelStation.distance, precisionDigits);
    String distance;
    if (distanced.toInt() == distanced) {
      distance = '${distanced.toInt()} km';
    } else {
      distance = "$distanced km";
    }
    final child1 = Text(distance, style: Theme.of(context).textTheme.caption);
    return _getElevatedBoxSingleChild(child1, context);
  }

  Widget _getOpenCloseWidget(final BuildContext context) {
    if (fuelStation.status != null && fuelStation.status != Status.unknown) {
      final String status = fuelStation.status!.statusName!;
      final Color color = (fuelStation.status == Status.open || fuelStation.status == Status.open24Hrs)
          ? AppTheme.stationOpenColor
          : AppTheme.stationCloseColor;
      final childWidget = Text(status, style: Theme.of(context).textTheme.caption!.copyWith(color: color));
      return _getElevatedBoxSingleChild(childWidget, context);
    }
    return const SizedBox(width: 0);
  }

  Widget _getOffersWidget(final BuildContext context) {
    if (fuelStation.promos > 0 || fuelStation.services > 0) {
      Widget child1 = Text('Offers', style: Theme.of(context).textTheme.caption);
      Widget? child2;
      if (fuelStation.promos > 0) {
        child2 = Row(children: [
          const Icon(Icons.shopping_cart, size: 24),
          const SizedBox(width: 10),
          Text(fuelStation.promos.toString(), style: Theme.of(context).textTheme.subtitle1)
        ]);
      }
      Widget? child3;
      if (fuelStation.services > 0) {
        child3 = Row(children: [
          const Icon(Icons.car_repair, size: 24),
          // SvgPicture.asset('assets/images/ic_car_service.svg',
          //     width: 24, height: 24, fit: BoxFit.fill, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Text(fuelStation.services.toString(), style: Theme.of(context).textTheme.subtitle1)
        ]);
      }
      Widget rowOfChildren;
      if (child2 != null && child3 != null) {
        rowOfChildren = IntrinsicHeight(
            child: Row(children: [
          child2,
          const SizedBox(width: 10),
          const VerticalDivider(width: .5),
          const SizedBox(width: 10),
          child3
        ]));
      } else if (child2 != null) {
        rowOfChildren = child2;
      } else {
        rowOfChildren = child3!;
      }

      return Material(
          elevation: .5,
          shadowColor: Theme.of(context).shadowColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).backgroundColor),
              child: Column(children: [child1, const SizedBox(height: 7), rowOfChildren])));
    }
    return const SizedBox(width: 0);
  }

  Widget _getPriceWithDetailsWidget(final FuelQuote? selectedFuelQuote, final BuildContext context) {
    if (selectedFuelQuote != null && selectedFuelQuote.quoteValue != null) {
      Widget child1 = Text('Price', style: Theme.of(context).textTheme.caption);
      final Widget child2 = Row(children: <Widget>[
        Text("${selectedFuelQuote.quoteValue}", style: Theme.of(context).textTheme.subtitle1),
        Text("￠", style: Theme.of(context).textTheme.overline)
      ]);
      final Column priceColumn = Column(children: [child1, const SizedBox(height: 8), child2]);

      DateTime publishDate = DateTime.fromMillisecondsSinceEpoch(selectedFuelQuote.publishDate! * 1000);
      DateTime curDate = DateTime.now();
      String publishDateString;
      if (publishDate.year != curDate.year) {
        publishDateString = DateFormat('dd-MMM-yyyy').format(publishDate);
      } else {
        publishDateString = DateFormat('dd-MMM HH:mm').format(publishDate);
      }

      Widget child3 = Text('Last Update', style: Theme.of(context).textTheme.caption);
      Widget child4 = Text(publishDateString, style: Theme.of(context).textTheme.subtitle1);
      final Column pubDateColumn = Column(children: [child3, const SizedBox(height: 8), child4]);
      return Material(
          elevation: .5,
          shadowColor: Theme.of(context).shadowColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).backgroundColor),
              child: Row(children: [
                priceColumn,
                const SizedBox(width: 10),
                const VerticalDivider(width: .5),
                const SizedBox(width: 10),
                pubDateColumn
              ])));
    }
    return const SizedBox(width: 0);
  }

  Widget _getElevatedBoxSingleChild(final Widget child1, final BuildContext context) {
    return Material(
        elevation: .5,
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).backgroundColor),
            child: child1));
  }
}
