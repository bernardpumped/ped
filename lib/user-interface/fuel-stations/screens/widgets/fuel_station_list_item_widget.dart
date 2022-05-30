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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/fuel_station_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_context_menu.dart';
import 'package:pumped_end_device/user-interface/fuel-stations/screens/widgets/fuel_station_logo_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/params/fuel_station_details_param.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/fuel_station_details_screen.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationListItemWidget extends StatelessWidget {
  static const _tag = 'FuelStationListItemWidget';
  final FuelStation fuelStation;
  final FuelType selectedFuelType;
  final Function parentRefresh;

  final FuelStationCardColorScheme colorScheme =
      getIt.get<FuelStationCardColorScheme>(instanceName: fsCardColorSchemeName);

  FuelStationListItemWidget(
      {Key? key, required this.fuelStation, required this.selectedFuelType, required this.parentRefresh})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final FuelQuote? selectedFuelQuote = fuelStation.fuelTypeFuelQuoteMap[selectedFuelType.fuelType];
    return GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, FuelStationDetailsScreen.routeName,
                  arguments: FuelStationDetailsParam(fuelStation))
              .then((val) {
            final bool? homeScreenRefreshNeeded = val as bool?;
            LogUtil.debug(_tag, 'homeScreenRefreshNeeded : $homeScreenRefreshNeeded');
            if (homeScreenRefreshNeeded != null && homeScreenRefreshNeeded) {
              parentRefresh();
              LogUtil.debug(_tag, 'Refreshed the parent');
            }
          });
        },
        child: Card(
            surfaceTintColor: Colors.white,
            margin: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 1.5,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    FuelStationLogoWidget(width: 95, height: 95, image: NetworkImage(fuelStation.merchantLogoUrl)),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          _getOpenCloseRatingDistanceWidget(context),
                          Padding(padding: const EdgeInsets.only(left: 13, top: 13), child: _getStationNameWidget()),
                          Padding(padding: const EdgeInsets.only(left: 13, top: 13), child: _getStationAddressWidget())
                        ]))
                  ]),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    IntrinsicHeight(child: _getOffersWidget()),
                    const SizedBox(width: 15),
                    IntrinsicHeight(child: _getPriceWithDetailsWidget(selectedFuelQuote))
                  ])
                ]))));
  }

  Widget _getOpenCloseRatingDistanceWidget(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      _getOpenCloseWidget(),
      const SizedBox(width: 5),
      _getRatingWidget(),
      const SizedBox(width: 5),
      _getDistanceWidget(),
      FuelStationContextMenu(fuelStation: fuelStation)
    ]);
  }

  Widget _getStationAddressWidget() {
    return Text(
        '${fuelStation.fuelStationAddress.addressLine1}, ${fuelStation.fuelStationAddress.locality}'.toTitleCase(),
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: colorScheme.primaryTextColor,
            overflow: TextOverflow.ellipsis),
        maxLines: 1);
  }

  Widget _getStationNameWidget() => Text(fuelStation.fuelStationName.toTitleCase(),
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.primaryTextColor,
          overflow: TextOverflow.ellipsis));

  Widget _getRatingWidget() {
    if (fuelStation.rating != null) {
      final Widget childWidget = Row(children: [
        Text(fuelStation.rating.toString(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colorScheme.primaryTextColor)),
        const SizedBox(width: 2),
        Icon(Icons.star, color: colorScheme.primaryTextColor, size: 15)
      ]);
      return _getElevatedBoxSingleChild(childWidget);
    }
    return const SizedBox(width: 0);
  }

  Widget _getDistanceWidget() {
    int precisionDigits =
        fuelStation.distance >= 10 ? 0 : (fuelStation.distance >= 1 && fuelStation.distance < 10 ? 1 : 2);
    double distanced = DataUtils.toPrecision(fuelStation.distance, precisionDigits);
    String distance;
    if (distanced.toInt() == distanced) {
      distance = '${distanced.toInt()} km';
    } else {
      distance = "$distanced km";
    }
    final child1 = Text(distance,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: colorScheme.primaryTextColor));
    return _getElevatedBoxSingleChild(child1);
  }

  Widget _getOpenCloseWidget() {
    if (fuelStation.status != null && fuelStation.status != Status.unknown) {
      final String status = fuelStation.status!.statusName!;
      final Color widgetChipColor = (fuelStation.status == Status.open || fuelStation.status == Status.open24Hrs)
          ? colorScheme.openCloseWidgetOpenColor
          : colorScheme.openCloseWidgetCloseColor;
      final childWidget =
          Text(status, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: widgetChipColor));
      return _getElevatedBoxSingleChild(childWidget);
    }
    return const SizedBox(width: 0);
  }

  Widget _getOffersWidget() {
    if (fuelStation.promos > 0 || fuelStation.services > 0) {
      final Widget child1 = Text('Offers', style: TextStyle(fontSize: 13, color: colorScheme.secondaryTextColor));
      Widget? child2;
      if (fuelStation.promos > 0) {
        child2 = Row(children: [
          Icon(Icons.shopping_cart, color: colorScheme.primaryTextColor, size: 20),
          const SizedBox(width: 5),
          Text(fuelStation.promos.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.primaryTextColor))
        ]);
      }
      Widget? child3;
      if (fuelStation.services > 0) {
        child3 = Row(children: [
          SvgPicture.asset('assets/images/ic_car_service.svg',
              width: 20, height: 20, fit: BoxFit.fill, color: colorScheme.primaryTextColor),
          const SizedBox(width: 5),
          Text(fuelStation.services.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.primaryTextColor))
        ]);
      }
      Widget rowOfChildren;
      if (child2 != null && child3 != null) {
        rowOfChildren = IntrinsicHeight(
            child: Row(children: [
          child2,
          const SizedBox(width: 7),
          VerticalDivider(width: 1, color: colorScheme.dividerColor),
          const SizedBox(width: 7),
          child3
        ]));
      } else if (child2 != null) {
        rowOfChildren = child2;
      } else {
        rowOfChildren = child3!;
      }

      return Material(
          elevation: .5,
          shadowColor: colorScheme.primaryTextColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [child1, const SizedBox(height: 7), rowOfChildren])));
    }
    return const SizedBox(width: 0);
  }

  Widget _getPriceWithDetailsWidget(final FuelQuote? selectedFuelQuote) {
    if (selectedFuelQuote != null && selectedFuelQuote.quoteValue != null) {
      final Widget child1 = Text('Price', style: TextStyle(fontSize: 13, color: colorScheme.secondaryTextColor));
      final Widget child2 = Row(children: <Widget>[
        Text("${selectedFuelQuote.quoteValue}",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.primaryTextColor)),
        Text("￠", style: TextStyle(fontSize: 10, color: colorScheme.primaryTextColor))
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

      Widget child3 = Text('Last Update', style: TextStyle(fontSize: 13, color: colorScheme.secondaryTextColor));
      Widget child4 = Text(publishDateString,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.primaryTextColor));
      final Column pubDateColumn = Column(children: [child3, const SizedBox(height: 8), child4]);
      return Material(
          elevation: .5,
          shadowColor: colorScheme.primaryTextColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                priceColumn,
                const SizedBox(width: 7),
                VerticalDivider(width: 1, color: colorScheme.dividerColor),
                const SizedBox(width: 7),
                pubDateColumn
              ])));
    }
    return const SizedBox(width: 0);
  }

  Widget _getElevatedBoxSingleChild(final Widget child1) {
    return Material(
        elevation: .5,
        shadowColor: colorScheme.primaryTextColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(padding: const EdgeInsets.all(5), child: child1));
  }
}
