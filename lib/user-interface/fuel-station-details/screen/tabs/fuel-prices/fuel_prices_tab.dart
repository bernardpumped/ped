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
import 'package:intl/intl.dart';
import 'package:pumped_end_device/data/local/market_region_zone_config_utils.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/widget/fuel_price_source_citation_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/widget/no_fuel_prices_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';

class FuelPricesTabWidget extends StatefulWidget {
  final FuelStation _fuelStation;

  const FuelPricesTabWidget(this._fuelStation, {Key? key}) : super(key: key);

  @override
  State<FuelPricesTabWidget> createState() => _FuelPricesTabWidgetState();
}

class _FuelPricesTabWidgetState extends State<FuelPricesTabWidget> {
  final MarketRegionZoneConfigUtils _marketRegionZoneConfigUtils = MarketRegionZoneConfigUtils();

  _FuelPricesTabWidgetState();
  Future<List<FuelType>>? _allowedFuelTypesFuture;

  @override
  void initState() {
    super.initState();
    _allowedFuelTypesFuture = _marketRegionZoneConfigUtils.getFuelTypesForMarketRegion();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder(
        future: _allowedFuelTypesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading fuelTypes'));
          } else if (snapshot.hasData) {
            final List<FuelType> allowedFuelTypes = snapshot.data as List<FuelType>;
            if (widget._fuelStation.hasFuelPrices()) {
              return Column(children: _getListItem(context, allowedFuelTypes));
            } else {
              return const NoFuelPricesWidget();
            }
          } else {
            return const Center(child: Text('Loading'));
          }
        });
  }

  List<Widget> _getListItem(final BuildContext context, final List<FuelType> allowedFuelTypes) {
    final List<Widget> widgets = [];
    final List<FuelQuote> fuelQuotes = widget._fuelStation.fuelQuotes();
    _sortFuelQuotes(fuelQuotes);
    final Map<String, FuelType> allowedFuelTypesMap = {};
    for (var fuelType in allowedFuelTypes) {
      allowedFuelTypesMap.putIfAbsent(fuelType.fuelType, () => fuelType);
    }
    int rowItemsGenerated = 0;
    for (int i = 0; i < fuelQuotes.length; i++) {
      if (fuelQuotes[i].quoteValue != null) {
        rowItemsGenerated++;
        widgets.add(_getFuelQuoteRowItem(fuelQuotes[i], allowedFuelTypesMap));
      }
    }
    if (rowItemsGenerated != fuelQuotes.length) {
      widgets.add(_getDeclarationRowItem());
    }
    return widgets;
  }

  final formatter = DateFormat('dd-MMM-yy HH:mm');

  Widget _getDeclarationRowItem() {
    return Card(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 15),
        child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Text('Fuel Station does not advertise prices for other fuel types',
                style: Theme.of(context).textTheme.headline6)));
  }

  Widget _getFuelQuoteRowItem(final FuelQuote fuelQuote, final Map<String, FuelType> allowedFuelTypesMap) {
    final String? fuelTypeName = allowedFuelTypesMap[fuelQuote.fuelType]?.fuelName;
    return Card(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          Expanded(
              flex: 11,
              child: Container(
                  padding: const EdgeInsets.only(top: 10, right: 10, bottom: 2),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Text(fuelTypeName!, style: Theme.of(context).textTheme.headline3)),
                    Container(
                        padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        child: Row(children: <Widget>[
                          Container(margin: const EdgeInsets.only(left: 25), child: _getLastUpdateDateWidget(fuelQuote))
                        ]))
                  ]))),
          Expanded(
              flex: 4,
              child: Container(margin: const EdgeInsets.only(left: 30), child: _getFuelQuoteValueWidget(fuelQuote))),
          Expanded(
              flex: 2,
              child:
                  Container(alignment: Alignment.centerLeft, child: _getFuelQuoteSourceIcon(fuelQuote, fuelTypeName)))
        ]));
  }

  Widget _getFuelQuoteValueWidget(final FuelQuote fuelQuote) {
    return fuelQuote.quoteValue != null
        ? Text('${fuelQuote.quoteValue}', style: Theme.of(context).textTheme.headline3)
        : Text('---', style: Theme.of(context).textTheme.headline2);
  }

  Widget _getFuelQuoteSourceIcon(final FuelQuote fuelQuote, final String fuelTypeName) {
    if (fuelQuote.quoteValue != null && fuelQuote.fuelQuoteSource != null) {
      if (fuelQuote.fuelAuthoritySource() || fuelQuote.crowdSourced()) {
        return _getFuelPriceSourceCitation(fuelQuote, fuelTypeName);
      }
    }
    return const Text('');
  }

  Widget _getLastUpdateDateWidget(final FuelQuote fuelQuote) {
    return fuelQuote.publishDate != null
        ? Text('Last Update ${_getPublishDateFormatted(fuelQuote.publishDate!)}',
            style: Theme.of(context).textTheme.caption)
        : const SizedBox(width: 0);
  }

  String _getPublishDateFormatted(final int publishDateSeconds) {
    final int publishDateMilliseconds = publishDateSeconds * 1000;
    final DateTime publishDateTime = DateTime.fromMillisecondsSinceEpoch(publishDateMilliseconds);
    return formatter.format(publishDateTime);
  }

  GestureDetector _getFuelPriceSourceCitation(final FuelQuote fuelQuote, final String fuelTypeName) {
    final icon = fuelQuote.fuelQuoteSource == 'F'
        ? const Icon(Icons.info_outline, size: 32)
        : const Icon(Icons.people_outline, size: 32);
    return GestureDetector(
        onTap: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), side: const BorderSide(width: 0.2)),
                    content: FuelPriceSourceCitationWidget(fuelQuote, widget._fuelStation, fuelTypeName));
              });
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
