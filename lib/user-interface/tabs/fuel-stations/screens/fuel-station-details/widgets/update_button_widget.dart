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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/user-interface/icon_codes.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/data/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/edit-fuel-station-details/edit_fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/widgets/sign_in_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UpdateButtonWidget extends StatelessWidget {
  static const _TAG = 'UpdateButtonWidget';

  static const _editIcon = Icon(IconData(IconCodes.edit_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: FontsAndColors.pumpedNonActionableIconColor, size: 25);

  static const _moreIcon = Icon(IconData(IconCodes.navigate_next_icon_code,
      fontFamily: 'MaterialIcons', matchTextDirection: true),
      color: FontsAndColors.pumpedSecondaryIconColor, size: 25);


  final FuelStation fuelStation;
  final bool addressDetailsExpanded;
  final bool fuelPricesExpanded;
  final bool expandSuggestEdit;
  final Function updateFuelStationDetailsScreenForChange;

  const UpdateButtonWidget(this.fuelStation,
      {this.addressDetailsExpanded: false,
      this.fuelPricesExpanded: false,
      this.expandSuggestEdit: false,
      this.updateFuelStationDetailsScreenForChange});

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(color: Colors.white),
        child: ListTile(
            onTap: () {
              final Future<bool> signInDialogOutput =
                  showDialog<bool>(context: context, builder: (context) => SignInWidget());
              signInDialogOutput.then(
                  (output) => _handleLogin(
                      context, output, fuelStation, addressDetailsExpanded, fuelPricesExpanded, expandSuggestEdit),
                  onError: (errorOutput) => print('error output'));
            },
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            dense: true,
            isThreeLine: false,
            leading: _editIcon,
            title: _getUpdateDetailsTitle(),
            subtitle: _getUpdateDetailsSubtitle(),
            trailing: _moreIcon));
  }

  _handleLogin(final BuildContext context, final bool output, final FuelStation fuelStation,
      final bool addressDetailsExpanded, final bool fuelPricesExpanded, final bool expandSuggestEdit) async {
    if (output) {
      var result = await Navigator.pushNamed(context, EditFuelStationDetails.routeName,
          arguments: EditFuelStationDetailsParams(
              lazyLoadOperatingHrs: true,
              fuelStation: fuelStation,
              expandFuelPrices: fuelPricesExpanded,
              expandSuggestEdit: expandSuggestEdit,
              expandAddressDetails: addressDetailsExpanded));
      if (updateFuelStationDetailsScreenForChange != null) {
        LogUtil.debug(_TAG, 'updateFuelStationDetailsScreenForChange is not null, calling...');
        updateFuelStationDetailsScreenForChange(fuelStation, result);
      } else {
        LogUtil.debug(_TAG, 'updateFuelStationDetailsScreenForChange is null');
      }
    } else {
      // show signIn failure dialog.
    }
  }

  Widget _getUpdateDetailsSubtitle() {
    return Text('In case information is missing or incorrect', maxLines: 2, overflow: TextOverflow.ellipsis);
  }

  Widget _getUpdateDetailsTitle() {
    return Text('Update Station Details',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87));
  }
}
