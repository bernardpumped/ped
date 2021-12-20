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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pumped_end_device/data/local/location/location_data_source.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/model/update-results/update_fuel_station_details_result.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/params/fuel_station_details_param.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/edit_fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-stations-screen/widgets/circular_image_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/utils/fuel_station_update_merge_util.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/widgets/directions_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/widgets/phone_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_type.dart';
import 'package:pumped_end_device/models/status.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationListItemExpandedWidget extends StatefulWidget {
  final FuelStation _fuelStation;
  final FuelType _selectedFuelType;
  final Function _triggerHomeScreenRebuild;
  FuelStationListItemExpandedWidget(this._fuelStation, this._selectedFuelType, this._triggerHomeScreenRebuild);

  @override
  _FuelStationListItemExpandedWidgetState createState() => _FuelStationListItemExpandedWidgetState();
}

class _FuelStationListItemExpandedWidgetState extends State<FuelStationListItemExpandedWidget> {
  static const _TAG = 'FuelStationListItemExpandedWidgetIos';
  static const Color _expandedViewBackGroundColor = Colors.white;
  static const Color _expandedViewPrimaryTextColor = Colors.black87;
  static const Color _expandedViewPrimaryIconColor = Colors.black54;
  static const Color _expandedViewButtonIconColor = Colors.white;
  static const Color _expandedViewSecondaryIconColor = FontsAndColors.pumpedSecondaryIconColor;
  static const Color _expandedViewSecondaryTextColor = Colors.black54;

  final FuelStationUpdateMergeUtil _fuelStationUpdateMergeUtil = new FuelStationUpdateMergeUtil();

  @override
  Widget build(final BuildContext context) {
    final FuelQuote selectedFuelQuote = widget._fuelStation.fuelTypeFuelQuoteMap[widget._selectedFuelType.fuelType];
    var formatter = new DateFormat('dd-MMM hh:mm');
    final Set<String> fuelQuoteSources = widget._fuelStation.fuelQuoteSources();
    final String fuelQuoteSourcesStr = fuelQuoteSources.join(" ");
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 5),
        color: _expandedViewBackGroundColor,
        child: Container(
            decoration: BoxDecoration(color: Colors.lightBlue[50], borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.all(15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getFuelStationImgNameAddressWidget(),
                  SizedBox(height: 8),
                  _getDistanceStatusRatingRow(context),
                  SizedBox(height: 15),
                  _getFuelQuoteDetailsRow(selectedFuelQuote, formatter, fuelQuoteSourcesStr, context),
                  SizedBox(height: 15),
                  _getMoreDetailsDirectionsCallRow(context),
                  SizedBox(height: 15),
                  _getPromosColumn(),
                  _getServicesDetailsColumn()
                ])));
  }

  Row _getDistanceStatusRatingRow(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      widget._fuelStation.distance != null
          ? Expanded(
              flex: 1,
              child: getRowTextItem('${DataUtils.toPrecision(widget._fuelStation.distance, 2)} km', 'Distance'))
          : SizedBox(width: 0),
      Expanded(flex: 1, child: _getFuelStationStatusWidget(context)),
      widget._fuelStation.rating != null
          ? Expanded(flex: 1, child: getRowTextItem('${widget._fuelStation.rating}', 'Rating'))
          : SizedBox(width: 0)
    ]);
  }

  Row _getFuelStationImgNameAddressWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularImageWidget(
              width: 70, height: 70, isNetworkImage: true, imagePath: widget._fuelStation.merchantLogoUrl, margin: 3),
          SizedBox(width: 10),
          Flexible(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(widget._fuelStation.fuelStationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: _expandedViewPrimaryTextColor, fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Text(
                    '${widget._fuelStation.fuelStationAddress.addressLine1}, ${widget._fuelStation.fuelStationAddress.locality} '
                    '${widget._fuelStation.fuelStationAddress.state} ${widget._fuelStation.fuelStationAddress.zip}',
                    style: TextStyle(color: _expandedViewPrimaryTextColor, fontSize: 13))
              ]))
        ]);
  }

  static const moreDetailsIcon = const Icon(IconData(58370, fontFamily: 'MaterialIcons'), color: _expandedViewButtonIconColor);

  Row _getMoreDetailsDirectionsCallRow(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WidgetUtils.getActionIconCircular(moreDetailsIcon, 'Details', _expandedViewSecondaryIconColor,
            _expandedViewSecondaryIconColor, onTap: () async {
            var homeScreenRefreshNeeded = await Navigator.pushNamed(context, FuelStationDetailsScreen.routeName,
                arguments: FuelStationDetailsParam(widget._fuelStation));
            LogUtil.debug(_TAG, 'Rebuild screen $homeScreenRefreshNeeded');
            if (homeScreenRefreshNeeded) {
              widget._triggerHomeScreenRebuild();
            }
          }), // more_horiz icon
          DirectionsWidget(
              widget._fuelStation.fuelStationAddress.latitude, widget._fuelStation.fuelStationAddress.longitude, getIt.get<LocationDataSource>()),
          (DataUtils.isNotBlank(widget._fuelStation.fuelStationAddress.phone1) ||
                  DataUtils.isNotBlank(widget._fuelStation.fuelStationAddress.phone2))
              ? PhoneWidget(DataUtils.isNotBlank(widget._fuelStation.fuelStationAddress.phone1)
                  ? widget._fuelStation.fuelStationAddress.phone1
                  : widget._fuelStation.fuelStationAddress.phone2)
              : SizedBox(width: 0)
        ]);
  }

  Row _getFuelQuoteDetailsRow(final FuelQuote selectedFuelQuote, final DateFormat formatter,
      final String fuelQuoteSourcesStr, final BuildContext context) {
    return selectedFuelQuote != null && selectedFuelQuote.quoteValue != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Expanded(flex: 1, child: getRowTextItem('${selectedFuelQuote.quoteValue}', 'Price')),
                Expanded(flex: 1, child: getRowTextItem('${selectedFuelQuote.fuelQuoteSourceName}', 'Price Source')),
                Expanded(
                    flex: 1,
                    child: getRowTextItem(
                        '${_getPublishDateFormatted(formatter, selectedFuelQuote.publishDate)}', 'Last Update'))
              ])
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                fuelQuoteSourcesStr != null
                    ? Expanded(
                        flex: 1,
                        child: getRowTextItem(
                            fuelQuoteSourcesStr == null ? 'Pumped' : fuelQuoteSourcesStr, 'Station Source'))
                    : SizedBox(width: 0),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        child: getRowTextItem('Price?', 'Tap to update', color: Colors.red),
                        onTap: () async {
                          var updateResult = await Navigator.pushNamed(context, EditFuelStationDetails.routeName,
                              arguments: EditFuelStationDetailsParams(
                                  fuelStation: widget._fuelStation,
                                  expandFuelPrices: true,
                                  lazyLoadOperatingHrs: true));
                          if (updateResult != null) {
                            _handleUpdateResult(updateResult);
                          } else {
                            LogUtil.debug(_TAG, 'UpdateResult is null');
                          }
                        }))
              ]);
  }

  static const _service1Icon = Icon(IconData(0xe542, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor);
  static const _service2Icon = Icon(IconData(0xe54a, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor);
  static const _service3Icon = Icon(IconData(0xe541, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor);
  static const _service4Icon = Icon(IconData(0xe53e, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor);
  static const _service5Icon = Icon(IconData(0xe547, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor);
  static const _service6Icon = Icon(IconData(0xe544, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor);
  static const _service7Icon = Icon(IconData(0xe543, fontFamily: 'MaterialIcons'), color: _expandedViewPrimaryIconColor);

  RenderObjectWidget _getServicesDetailsColumn() {
    return widget._fuelStation.hasServices
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text('Services', style: TextStyle(color: _expandedViewPrimaryTextColor, fontSize: 16)),
                ),
                SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 1, child: getRowIconItem2(_service1Icon, 'Car\nWash')),
                      Expanded(flex: 1, child: getRowIconItem2(_service2Icon, 'Laundry\nService')),
                      Expanded(flex: 1, child: getRowIconItem2(_service3Icon, 'Coffee\nShop')),
                      Expanded(flex: 1, child: getRowIconItem2(_service4Icon, 'ATM')),
                    ])
              ])
        : SizedBox(width: 0);
  }

  RenderObjectWidget _getPromosColumn() {
    return widget._fuelStation.hasPromos
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text('Offers', style: TextStyle(color: _expandedViewPrimaryTextColor, fontSize: 16)),
                ),
                SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 1, child: getRowIconItem2(_service5Icon, 'Grocery')),
                      Expanded(flex: 1, child: getRowIconItem2(_service6Icon, 'Drink')),
                      Expanded(flex: 1, child: getRowIconItem2(_service7Icon, 'Convenience\nStore'))
                    ])
              ])
        : SizedBox(width: 0);
  }

  String _getPublishDateFormatted(final DateFormat formatter, final int epochSeconds) {
    if (epochSeconds == null) {
      return '';
    }
    int publishDateMilliseconds = epochSeconds * 1000;
    DateTime publishDateTime = DateTime.fromMillisecondsSinceEpoch(publishDateMilliseconds);
    return formatter.format(publishDateTime);
  }

  Widget _getFuelStationStatusWidget(final BuildContext context) {
    if (widget._fuelStation.status == Status.unknown || widget._fuelStation.status == null) {
      return GestureDetector(
          child: getRowTextItem('Open hours?', 'Tap to update', color: Colors.red),
          onTap: () async {
            var updateResult = await Navigator.pushNamed(context, EditFuelStationDetails.routeName,
                arguments: EditFuelStationDetailsParams(
                    fuelStation: widget._fuelStation, expandOperatingHours: true, lazyLoadOperatingHrs: true));
            if (updateResult != null) {
              _handleUpdateResult(updateResult);
            } else {
              LogUtil.debug(_TAG, 'UpdateResult is null');
            }
          });
    }
    return getRowTextItem(widget._fuelStation.status.statusName, 'Status');
  }

  Widget getRowIconItem2(final Icon icon, final String description) {
    return Column(children: <Widget>[
      icon,
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

  void _handleUpdateResult(final UpdateFuelStationDetailsResult updateResult) {
    LogUtil.debug(_TAG, 'Update Result found : ${updateResult.isUpdateSuccessful}');
    setState(() {
      _fuelStationUpdateMergeUtil.mergeFuelStationUpdateResult(widget._fuelStation, updateResult);
    });
  }
}
