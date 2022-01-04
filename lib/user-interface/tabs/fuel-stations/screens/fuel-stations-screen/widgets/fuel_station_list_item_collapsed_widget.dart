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
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/util/data_utils.dart';

class FuelStationListItemCollapsedWidget extends StatelessWidget {

  static final Color _expandedViewPrimaryTextColor = Colors.black87;
  static final Color _expandedViewPrimaryIconColor = Colors.black54;
  static final Color _expandedViewSecondaryTextColor = Colors.black54;

  final FuelStation _fuelStation;
  final FuelType _selectedFuelType;
  FuelStationListItemCollapsedWidget(this._fuelStation, this._selectedFuelType);

  @override
  Widget build(final BuildContext context) {
    final FuelQuote selectedFuelQuote = _fuelStation.fuelTypeFuelQuoteMap[_selectedFuelType.fuelType];
    return Container(
        margin: EdgeInsets.only(bottom: 5, top: 2),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Column(children: <Widget>[
                Container(
                    width: 80,
                    height: 70,
                    padding: EdgeInsets.only(top: 8, left: 5),
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                fit: BoxFit.scaleDown, image: NetworkImage(_fuelStation.merchantLogoUrl))))),
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                        (_fuelStation.status != null && _fuelStation.status != Status.unknown)
                            ? _fuelStation.status.statusName
                            : "",
                        style: TextStyle(
                            fontSize: 14,
                            color: (_fuelStation.status == Status.open || _fuelStation.status == Status.open24Hrs)
                                ? Colors.green
                                : Colors.red)))
              ])),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    child: Text(_fuelStation.fuelStationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                Container(
                    margin: EdgeInsets.only(top: 8, left: 10),
                    child: Text(
                        '${_fuelStation.fuelStationAddress.addressLine1}, ${_fuelStation.fuelStationAddress.locality} '
                        '${_fuelStation.fuelStationAddress.state} ${_fuelStation.fuelStationAddress.zip}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13))),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 8, left: 10),
                      child: Text("${DataUtils.toPrecision(_fuelStation.distance, 2)} km",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                  Container(
                      margin: EdgeInsets.only(top: 8, left: 10),
                      child: selectedFuelQuote != null && selectedFuelQuote.quoteValue != null
                          ? Row(children: <Widget>[
                              Text("${selectedFuelQuote.quoteValue}",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              Text("￠", style: TextStyle(fontSize: 9))
                            ])
                          : Text('Please update price', style: TextStyle(fontSize: 13)))
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 5, top: 5), child: WidgetUtils.getRating(_fuelStation.rating, 16)),
                  SizedBox(width: 15),
                  _getServices(_fuelStation)
                ]),
//                _getPromoIcons(_fuelStation),
                _getPromotions(_fuelStation)
              ]))
            ]));
  }

  static const _service1Icon_black54Size20 = Icon(IconData(0xe542, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 20);
  static const _service12con_black54Size20 = Icon(IconData(0xe53e, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 20);
  static const _service3Icon_black54Size20 = Icon(IconData(0xe541, fontFamily: 'MaterialIcons'), color: Colors.black54, size: 20);

  Widget _getServices(FuelStation fuelStation) {
    if (fuelStation.hasServices) {
      return Container(
          margin: EdgeInsets.only(top: 5, left: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Text('Services - ', style: TextStyle(color: Colors.black87)),
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: _service1Icon_black54Size20),
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: _service12con_black54Size20),
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: _service3Icon_black54Size20)
          ]));
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget _getPromotions(final FuelStation fuelStation) {
    if (fuelStation.hasPromos) {
      return OffersAvailableWidget();
    } else {
      return SizedBox(width: 0);
    }
  }

  Widget getRowIconItem2(final int iconCode, final String description) {
    return Column(children: <Widget>[
      Icon(IconData(iconCode, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor),
      SizedBox(height: 5),
      Text(description,
          style: TextStyle(color: _expandedViewSecondaryTextColor, fontSize: 13), textAlign: TextAlign.center)
    ]);
  }

  Widget getRowTextItem(final String text, final String description, {Color color}) {
    return Column(children: <Widget>[
      Text(text,
          style: TextStyle(
              color: color == null ? _expandedViewPrimaryTextColor : color, fontSize: 14, fontWeight: FontWeight.w500)),
      SizedBox(height: 5),
      Text(description, style: TextStyle(color: _expandedViewSecondaryTextColor, fontSize: 13))
    ]);
  }
}

class OffersAvailableWidget extends StatefulWidget {
  const OffersAvailableWidget({
    Key key,
  }) : super(key: key);

  @override
  _OffersAvailableWidgetState createState() => _OffersAvailableWidgetState();
}

class _OffersAvailableWidgetState extends State<OffersAvailableWidget> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> _fadeInFadeOutAnimation;
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _fadeInFadeOutAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

    animationController.addStatusListener((status) {
      if (disposed) {
        return;
      }
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    TickerFuture tickerFuture = animationController.repeat();
    tickerFuture.timeout(Duration(seconds: 5), onTimeout: () {
      if (disposed) {
        return;
      }
      animationController.stop(canceled: true);
    });
    animationController.forward();
  }

  @override
  void dispose() {
    disposed = true;
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5, left: 5),
        child: FadeTransition(
            opacity: _fadeInFadeOutAnimation,
            child: Text('Offers available. Explore...',
                style: TextStyle(fontSize: 14, color: FontsAndColors.vividBlueTextColor))));
  }
}
