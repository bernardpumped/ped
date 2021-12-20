/*
 *     Copyright (c) 2021.
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

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pumped_end_device/data/local/market_region_zone_config_utils.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/fuel_price_source_citation.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/update_button_widget.dart';
import 'package:pumped_end_device/user-interface/widgets/pumped_icons.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelPricesTabWidget extends StatefulWidget {
  final FuelStation fuelStation;
  final Function onUpdateResult;

  FuelPricesTabWidget(this.fuelStation, this.onUpdateResult);

  @override
  _FuelPricesTabWidgetState createState() => _FuelPricesTabWidgetState();
}

class _FuelPricesTabWidgetState extends State<FuelPricesTabWidget> {
  static const _TAG = 'FuelPricesTabWidget';

  final MarketRegionZoneConfigUtils _marketRegionZoneConfigUtils = new MarketRegionZoneConfigUtils();

  _FuelPricesTabWidgetState();
  Future<List<FuelType>> allowedFuelTypesFuture;

  @override
  void initState() {
    super.initState();
    allowedFuelTypesFuture = _marketRegionZoneConfigUtils.getFuelTypesForMarketRegion();
  }

  @override
  Widget build(final BuildContext context) {
    LogUtil.debug(_TAG, 'Invoking build method of FuelPricesTabWidget');
    return FutureBuilder(
      future: allowedFuelTypesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading fuelTypes'));
        } else if (snapshot.hasData) {
          List<FuelType> allowedFuelTypes = snapshot.data;
          return Container(
              decoration: BoxDecoration(color: FontsAndColors.pumpedBoxDecorationColor),
              child: Column(children: _getListItem(context, allowedFuelTypes)));
        } else {
          return Center(child: Text('Loading'));
        }
      },
    );
  }

  List<Widget> _getListItem(final BuildContext context, final List<FuelType> allowedFuelTypes) {
    final List<Widget> widgets = [];
    final List<FuelQuote> fuelQuotes = widget.fuelStation.fuelQuotes();
    _sortFuelQuotes(fuelQuotes);
    final Map<String, FuelType> allowedFuelTypesMap = {};
    allowedFuelTypes.forEach((fuelType) {
      allowedFuelTypesMap.putIfAbsent(fuelType.fuelType, () => fuelType);
    });

    for (int i = 0; i < fuelQuotes.length; i++) {
      widgets.add(_getFuelQuoteRowItem(fuelQuotes[i], allowedFuelTypesMap));
    }
    widgets.add(Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: UpdateButtonWidget(widget.fuelStation,
            fuelPricesExpanded: true, updateFuelStationDetailsScreenForChange: widget.onUpdateResult)));
    return widgets;
  }

  final formatter = new DateFormat('dd-MMM-yy HH:mm');

  Container _getFuelQuoteRowItem(final FuelQuote fuelQuote, final Map<String, FuelType> allowedFuelTypesMap) {
    final String fuelTypeName = allowedFuelTypesMap[fuelQuote.fuelType].fuelName;
    return Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          Expanded(
              flex: 9,
              child: Container(
                  padding: EdgeInsets.only(top: 10, right: 10, bottom: 2),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 25), child: Text(fuelTypeName, style: TextStyle(fontSize: 16))),
                    Container(
                        padding: EdgeInsets.only(right: 10, top: 2, bottom: 10),
                        child: Row(children: <Widget>[
                          Container(child: _getLastUpdateDateWidget(fuelQuote), margin: EdgeInsets.only(left: 25))
                        ]))
                  ]))),
          Expanded(
              flex: 4, child: Container(margin: EdgeInsets.only(left: 30), child: _getFuelQuoteValueWidget(fuelQuote))),
          Expanded(
              flex: 2, child: Container(child: _getFuelQuoteSourceIcon(fuelQuote), alignment: Alignment.centerLeft))
        ]));
  }

  Widget _getFuelQuoteValueWidget(final FuelQuote fuelQuote) {
    return fuelQuote.quoteValue != null
        ? Text('${fuelQuote.quoteValue}', style: TextStyle(fontSize: 18))
        : Text('---', style: TextStyle(fontSize: 18));
  }

  Widget _getFuelQuoteSourceIcon(final FuelQuote fuelQuote) {
    if (fuelQuote.quoteValue != null && fuelQuote.fuelQuoteSource != null) {
      if (fuelQuote.fuelAuthoritySource() || fuelQuote.crowdSourced()) return _getFuelPriceSourceCitation(fuelQuote);
    }
    return Text('');
  }

  Widget _getLastUpdateDateWidget(final FuelQuote fuelQuote) {
    return fuelQuote.publishDate != null
        ? Text('Last Update ${_getPublishDateFormatted(fuelQuote.publishDate)}',
            style: TextStyle(fontSize: 13, color: Colors.black54))
        : SizedBox(width: 0);
  }

  String _getPublishDateFormatted(final int publishDateSeconds) {
    LogUtil.debug(_TAG, 'publishDateSeconds $publishDateSeconds');
    int publishDateMilliseconds = publishDateSeconds * 1000;
    DateTime publishDateTime = DateTime.fromMillisecondsSinceEpoch(publishDateMilliseconds);
    return formatter.format(publishDateTime);
  }

  GestureDetector _getFuelPriceSourceCitation(final FuelQuote fuelQuote) {
    final icon = fuelQuote.fuelQuoteSource == 'F' ? PumpedIcons.faSourceIcon_black54Size30 : PumpedIcons.crowdSourceIcon_black54Size30;
    return GestureDetector(
        onTap: () {
          showCupertinoDialog(
              context: context, builder: (context) => FuelPriceSourceCitation(fuelQuote, widget.fuelStation));
        },
        child: icon);
  }

  void _sortFuelQuotes(final List<FuelQuote> fuelQuotes) {
    fuelQuotes.sort((a, b) {
      if (a.quoteValue != null && b.quoteValue != null || a.quoteValue == null && b.quoteValue == null) {
        return a.fuelType.compareTo(b.fuelType);
      } else if (a.quoteValue != null) {
        return -1;
      } else {
        return 1;
      }
    });
  }
}
