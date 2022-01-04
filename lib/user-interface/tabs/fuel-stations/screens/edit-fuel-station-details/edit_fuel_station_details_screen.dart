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
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/common/image_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-feature/edit_fuel_station_feature_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-fuel-price-widgets/edit_fuel_price_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-fuel-station-address/edit_fuel_station_address_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-operating-times-widgets/edit_operating_time_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/edit-phone-number/edit_phone_number_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/widgets/suggest-edit/suggest_edit_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/widgets/sliver_app_bar_title.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_text_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';

class EditFuelStationDetails extends StatefulWidget {
  static const routeName = '/editFuelStationDetails';

  @override
  _EditFuelStationDetailsState createState() {
    return _EditFuelStationDetailsState();
  }
}

class _EditFuelStationDetailsState extends State<EditFuelStationDetails> {
  bool fuelPricesExpanded = false;
  bool suggestEditExpanded = false;
  bool phoneNumberExpanded = false;
  bool addressDetailsExpanded = false;
  bool operatingHoursExpanded = false;
  bool fuelStationFeaturesExpanded = false;
  bool lazyLoadOperatingHrs = false;

  @override
  Widget build(final BuildContext context) {
    final EditFuelStationDetailsParams params = ModalRoute.of(context).settings.arguments;
    final FuelStation fuelStation = params.fuelStation;
    fuelPricesExpanded = params.expandFuelPrices;
    suggestEditExpanded = params.expandSuggestEdit;
    phoneNumberExpanded = params.expandPhoneNumber;
    addressDetailsExpanded = params.expandAddressDetails;
    operatingHoursExpanded = params.expandOperatingHours;
    fuelStationFeaturesExpanded = params.expandFuelStationFeatures;
    lazyLoadOperatingHrs = params.lazyLoadOperatingHrs;

    return Scaffold(
        appBar: CupertinoNavigationBar(middle: ApplicationTitleTextWidget(), automaticallyImplyLeading: true),
        body: GestureDetector(
            onTap: () {
              final FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        pinned: true,
                        expandedHeight: 70,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        centerTitle: false,
                        title: SliverAppBarTitle(child: _getPageTitle(fuelStation)),
                        flexibleSpace: FlexibleSpaceBar(background: _getPageTitleExpanded(fuelStation)))
                  ];
                },
                body: CustomScrollView(slivers: <Widget>[SliverToBoxAdapter(child: _getBodyContent(fuelStation))]))));
  }

  Column _getBodyContent(final FuelStation fuelStation) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _header('Fuel Prices cents per litre'),
          Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          _buildFuelPricesTile(fuelStation),
          _header('Station Details'),
          Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          _buildFuelStationFeatureTile(fuelStation),
          Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          _buildOperatingHourTile(fuelStation),
          Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          _buildPhoneNumberTile(fuelStation),
          Divider(color: Colors.black45, indent: 15, endIndent: 15, height: 0),
          _buildAddressDetailsTile(fuelStation),
          SizedBox(height: 10),
          _header('Suggest an Edit'),
          _buildSuggestEditTile(fuelStation)
        ]);
  }

  Container _header(final title) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: FontsAndColors.pumpedBoxDecorationColor),
        padding: EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
        child: Container(
            child: Text(title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87))));
  }

  static const featuresIcon = Icon(IconData(IconCodes.features_icon_code, fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: FontsAndColors.pumpedNonActionableIconColor, size: 30);

  Widget _buildFuelStationFeatureTile(final FuelStation fuelStation) {
    var setStateFunction = (expanded) {
      fuelStationFeaturesExpanded = expanded;
    };
    return new EditFuelStationFeatureWidget('Fuel Station Features', 'fuel-station-features', fuelStation,
        fuelStation.getFuelStationSource(), () => fuelStationFeaturesExpanded, setStateFunction, featuresIcon);
  }

  static const editFuelPriceIcon = const Icon(IconData(IconCodes.fuel_price_icon_code, fontFamily: 'MaterialIcons'),
      color: FontsAndColors.pumpedNonActionableIconColor, size: 30);

  Widget _buildFuelPricesTile(final FuelStation fuelStation) {
    var setStateFunction = (expanded) {
      fuelPricesExpanded = expanded;
    };
    return EditFuelPriceWidget(
        fuelStation, 'Fuel Prices', setStateFunction, () => fuelPricesExpanded, "fuel-prices", editFuelPriceIcon);
  }

  Widget _buildAddressDetailsTile(final FuelStation fuelStation) {
    var setStateFunction = (expanded) {
      addressDetailsExpanded = expanded;
    };
    return EditFuelStationAddressWidget(setStateFunction, () => addressDetailsExpanded, fuelStation.fuelStationAddress,
        fuelStation.stationId, fuelStation.fuelStationName, fuelStation.getFuelStationSource());
  }

  _buildSuggestEditTile(final FuelStation fuelStation) {
    var setStateFunction = (expanded) {
      suggestEditExpanded = expanded;
    };
    return SuggestEditWidget(setStateFunction, () => suggestEditExpanded, fuelStation.stationId,
        fuelStation.fuelStationName, fuelStation.getFuelStationSource());
  }

  Widget _buildPhoneNumberTile(final FuelStation fuelStation) {
    var setStateFunction = (expanded) {
      phoneNumberExpanded = expanded;
    };
    final FuelStationAddress fuelStationAddress = fuelStation.fuelStationAddress;
    return EditPhoneNumberWidget(
        setStateFunction,
        () => phoneNumberExpanded,
        fuelStationAddress.phone1,
        fuelStationAddress.phone2,
        fuelStation.getFuelStationSource(),
        fuelStation.stationId,
        fuelStation.fuelStationName);
  }

  static const _operatingTimeIcon = Icon(IconData(IconCodes.operating_time_icon_code, fontFamily: 'MaterialIcons'),
      color: FontsAndColors.pumpedNonActionableIconColor, size: 30);

  Widget _buildOperatingHourTile(final FuelStation fuelStation) {
    var setStateFunction = (expanded) {
      operatingHoursExpanded = expanded;
    };
    return new EditOperatingTimeWidget(fuelStation, 'Operating Hours', setStateFunction, () => operatingHoursExpanded,
        "open-close", _operatingTimeIcon, true, lazyLoadOperatingHrs);
  }

  Widget _getPageTitle(final FuelStation fuelStation) {
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(children: <Widget>[
          ImageWidget(
              imageUrl: fuelStation.merchantLogoUrl,
              width: 70,
              height: 60,
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10)),
          Expanded(
              child: Text('${fuelStation.fuelStationName} ${fuelStation.fuelStationAddress.locality}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87, fontFamily: 'SF-Pro-Display'),
                  textAlign: TextAlign.start))
        ]));
  }

  Widget _getPageTitleExpanded(final FuelStation fuelStation) {
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(children: <Widget>[
          ImageWidget(
              imageUrl: fuelStation.merchantLogoUrl,
              width: 70,
              height: 60,
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10)),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text('${fuelStation.fuelStationName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87, fontFamily: 'SF-Pro-Display'),
                    textAlign: TextAlign.start),
                Text('${fuelStation.fuelStationAddress.addressLine1}  ${fuelStation.fuelStationAddress.locality}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey, fontFamily: 'SF-Pro-Display'),
                    textAlign: TextAlign.start)
              ]))
        ]));
  }
}
