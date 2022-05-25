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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/params/edit_fuel_station_details_params.dart';
import 'package:pumped_end_device/user-interface/edit-fuel-station-details/screen/edit_fuel_station_details_screen.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/pumped_sign_in_widget.dart';
import 'package:pumped_end_device/user-interface/splash/screen/splash_screen.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/util/data_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class ContextAwareFab extends StatefulWidget {
  final Function _updateFuelStationDetailsScreenForChange;
  final FuelStation _fuelStation;
  final int _selectedTab; // 0 -> Fuel Prices tab, 1 -> Offers tab, 2 - Contacts tab

  const ContextAwareFab(this._fuelStation, this._selectedTab, this._updateFuelStationDetailsScreenForChange, {Key? key})
      : super(key: key);

  @override
  State<ContextAwareFab> createState() => _ContextAwareFabState();
}

class _ContextAwareFabState extends State<ContextAwareFab> with SingleTickerProviderStateMixin {
  static const _tag = 'ContextAwareFab';
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return _getFab();
  }

  FloatingActionBubble _getFab() {
    return FloatingActionBubble(
        items: _getContextAwareBubbles(),
        animation: _animation,
        onPress: () =>
            _animationController.isCompleted ? _animationController.reverse() : _animationController.forward(),
        iconColor: Colors.white,
        iconData: Icons.edit,
        backGroundColor: Colors.indigo);
  }

  _getContextAwareBubbles() {
    if (widget._selectedTab == 0) {
      return [
        Bubble(
            title: "Fuel Prices",
            iconColor: Colors.white,
            bubbleColor: Colors.indigo,
            icon: Icons.monetization_on_outlined,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              if (_shouldEdit(widget._fuelStation, editFuelPrices: true)) {
                _attemptLogin(context, widget._fuelStation, editFuelPrices: true);
              }
            })
      ];
    } else if (widget._selectedTab == 2) {
      return [
        Bubble(
            title: "Operating Time",
            iconColor: Colors.white,
            bubbleColor: Colors.indigo,
            icon: Icons.access_alarm,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              if (_shouldEdit(widget._fuelStation, editOperatingTime: true)) {
                final Future<bool?> signInDialogOutput = showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    builder: (context) => const PumpedSignInWidget());
                signInDialogOutput.then(
                    (output) => _handleLogin(context, output, widget._fuelStation, editOperatingTime: true),
                    onError: (errorOutput) => LogUtil.debug(_tag, 'error output'));
              }
            }),
        Bubble(
            title: "Contact Details",
            iconColor: Colors.white,
            bubbleColor: Colors.indigo,
            icon: Icons.location_on_outlined,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              if (_shouldEdit(widget._fuelStation, editDetails: true)) {
                final Future<bool?> signInDialogOutput = showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    builder: (context) => const PumpedSignInWidget());
                signInDialogOutput.then(
                    (output) => _handleLogin(context, output, widget._fuelStation, editDetails: true),
                    onError: (errorOutput) => LogUtil.debug(_tag, 'error output'));
              }
            }),
        Bubble(
            title: "Features",
            iconColor: Colors.white,
            bubbleColor: Colors.indigo,
            icon: Icons.flag_outlined,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              if (_shouldEdit(widget._fuelStation, editFeatures: true)) {
                final Future<bool?> signInDialogOutput = showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    builder: (context) => const PumpedSignInWidget());
                signInDialogOutput.then(
                    (output) => _handleLogin(context, output, widget._fuelStation, editFeatures: true),
                    onError: (errorOutput) => LogUtil.debug(_tag, 'error output'));
              }
            }),
        Bubble(
            title: "Suggest Edit",
            iconColor: Colors.white,
            bubbleColor: Colors.indigo,
            icon: Icons.comment_outlined,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              if (_shouldEdit(widget._fuelStation, suggestEdit: true)) {
                final Future<bool?> signInDialogOutput = showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                    builder: (context) => const PumpedSignInWidget());
                signInDialogOutput.then(
                    (output) => _handleLogin(context, output, widget._fuelStation, suggestEdit: true),
                    onError: (errorOutput) => LogUtil.debug(_tag, 'error output'));
              }
            })
      ];
    } else {
      return [
        Bubble(
            title: "Bad data",
            iconColor: Colors.white,
            bubbleColor: Colors.indigo,
            icon: Icons.fmd_bad,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SplashScreen()));
            })
      ];
    }
  }

  bool _isOperatingTimeEditable(final FuelStation fuelStation) {
    if (!fuelStation.isFaStation) {
      final FuelStationOperatingHrs? fuelStationOperatingHrs = fuelStation.fuelStationOperatingHrs;
      if (fuelStationOperatingHrs != null) {
        List<String> days = [];
        bool editable = false;
        for (var operatingHrs in fuelStationOperatingHrs.weeklyOperatingHrs) {
          days.add(operatingHrs.dayOfWeek);
          // Operating hours can be edited, only if its source is neither Google nor Fuel Authority
          editable = editable || operatingHrs.operatingTimeSource != 'G' && operatingHrs.operatingTimeSource != 'F';
        }
        if (days.length == 7) {
          // fuelStationOperatingHrs.weeklyOperatingHrs cover all 7 days, hence editable value is the right value to consider
          return editable;
        } else {
          // some days are missing, and hence we need to allow updates to cover these.
          return true;
        }
      } else {
        // No operating hours are present, so allow edits
        return true;
      }
    } else {
      // Fuel Authority Stations cannot be edited
      return false;
    }
  }

  bool _isAddressEditable(final FuelStation fuelStation) {
    final FuelStationAddress fuelStationAddress = fuelStation.fuelStationAddress;
    return DataUtils.isBlank(fuelStationAddress.contactName) ||
        DataUtils.isBlank(fuelStationAddress.addressLine1) ||
        DataUtils.isBlank(fuelStationAddress.locality) ||
        DataUtils.isBlank(fuelStationAddress.region) ||
        DataUtils.isBlank(fuelStationAddress.state) ||
        DataUtils.isBlank(fuelStationAddress.zip) ||
        DataUtils.isBlank(fuelStationAddress.phone1) ||
        DataUtils.isBlank(fuelStationAddress.phone2);
  }

  _attemptLogin(final BuildContext context, final FuelStation fuelStation,
      {final bool editDetails = false,
      final bool editOperatingTime = false,
      final bool editFuelPrices = false,
      final bool editFeatures = false,
      final bool suggestEdit = false}) {
    //https://petercoding.com/firebase/2021/05/24/using-google-sign-in-with-firebase-in-flutter/
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      final Future<bool?> signInDialogOutput = showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          builder: (context) => const PumpedSignInWidget());
      signInDialogOutput.then(
          (signInResult) => _handleLogin(context, signInResult, widget._fuelStation,
              editDetails: editDetails,
              editOperatingTime: editOperatingTime,
              editFuelPrices: editFuelPrices,
              editFeatures: editFeatures,
              suggestEdit: suggestEdit),
          onError: (errorOutput) => LogUtil.debug(_tag, 'error output'));
    } else {
      _handleLogin(context, true, widget._fuelStation,
          editDetails: editDetails,
          editOperatingTime: editOperatingTime,
          editFuelPrices: editFuelPrices,
          editFeatures: editFeatures,
          suggestEdit: suggestEdit);
    }
  }

  _handleLogin(final BuildContext context, final bool? signInResult, final FuelStation fuelStation,
      {final bool editDetails = false,
      final bool editOperatingTime = false,
      final bool editFuelPrices = false,
      final bool editFeatures = false,
      final bool suggestEdit = false}) async {
    if (signInResult != null && signInResult) {
      var result = await Navigator.pushNamed(context, EditFuelStationDetailsScreen.routeName,
          arguments: EditFuelStationDetailsParams(
              fuelStation: fuelStation,
              editDetails: editDetails,
              editOperatingTime: editOperatingTime,
              editFuelPrices: editFuelPrices,
              editFeatures: editFeatures,
              suggestEdit: suggestEdit));
      if (result != null) {
        widget._updateFuelStationDetailsScreenForChange(fuelStation, result);
      } else {
        LogUtil.debug(_tag, 'returned results was null, nothing to merge. Seems user pressed back button');
      }
    } else {
      // show signIn failure dialog.
    }
  }

  bool _isFuelPriceEditable(final FuelStation fuelStation) {
    return !fuelStation.isFaStation;
  }

  bool _isFeaturesEditable(final FuelStation fuelStation) {
    return !fuelStation.isFaStation;
  }

  bool _shouldEdit(final FuelStation fuelStation,
      {final bool editDetails = false,
      final bool editOperatingTime = false,
      final bool editFuelPrices = false,
      final bool editFeatures = false,
      final bool suggestEdit = false}) {
    if (editDetails) {
      if (!_isAddressEditable(fuelStation)) {
        WidgetUtils.showToastMessage(context, 'Address is not editable', Colors.indigo);
        return false;
      }
    }
    if (editOperatingTime) {
      if (!_isOperatingTimeEditable(fuelStation)) {
        WidgetUtils.showToastMessage(context, 'Operating hours not editable', Colors.indigo);
        return false;
      }
    }
    if (editFuelPrices) {
      if (!_isFuelPriceEditable(fuelStation)) {
        WidgetUtils.showToastMessage(context, 'Fuel prices not editable', Colors.indigo);
        return false;
      }
    }
    if (editFeatures) {
      if (!_isFeaturesEditable(fuelStation)) {
        WidgetUtils.showToastMessage(context, 'Features not editable', Colors.indigo);
        return false;
      }
    }
    return true;
  }
}
