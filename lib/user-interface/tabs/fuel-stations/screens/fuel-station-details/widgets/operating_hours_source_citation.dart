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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/email_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';

class OperatingHoursSourceCitation extends StatelessWidget {
  static const _padding = 15.0;
  static const _margin = 30.0;
  static const _pumped_message = 'If Operating hours are incorrect please let us know';
  final OperatingHours _operatingHours;
  final FuelStation _fuelStation;

  const OperatingHoursSourceCitation(this._operatingHours, this._fuelStation);

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_padding)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(final BuildContext context) {
    final String operatingTimeSource = _operatingHours.operatingTimeSource;
    Widget child;
    if (operatingTimeSource == 'G' || operatingTimeSource == 'C') {
      child = _getOperatingHrsSourceMessage(context, operatingTimeSource);
    } else {
      child = SizedBox(height: 0);
    }
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(_padding),
            margin: EdgeInsets.only(top: _margin),
            decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(_padding),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0))]),
            child: child));
  }

  Column _getOperatingHrsSourceMessage(final BuildContext context, final String operatingTimeSource) {
    String sourceMessage;
    if (operatingTimeSource == 'C') {
      sourceMessage = 'Operating time Crowd Sourced';
    } else {
      sourceMessage = 'Operating time Google Source';
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Text(sourceMessage, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black87))),
      Divider(color: Colors.black54, height: 1),
      Padding(padding: EdgeInsets.only(bottom: 10, top: 10), child: _getAdminContactMessage()),
      Divider(color: Colors.black54, height: 1),
      _getOkActionButton(context)
    ]);
  }

  Text _getAdminContactMessage() {
    return Text(_pumped_message,
        textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.red));
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(children: [
      WidgetUtils.getRoundedElevatedButton(
          child: Text('Cancel'),
          foreGroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          borderRadius: 10.0,
          onPressed: () {
            Navigator.pop(context);
          }),
      SizedBox(width: 10),
      EmailWidget(emailBody: _getEmailBody(), emailSubject: _getEmailSubject(), emailAddress: 'bernard@pumpedfuel.com')
    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }

  String _getEmailSubject() {
    return 'Operating Time Incorrect : ${_fuelStation.fuelStationName} | ${_operatingHours.dayOfWeek}';
  }

  String _getEmailBody() {
    return 'For the fuelStation ${_fuelStation.fuelStationName} [${_fuelStation.stationId} | ${_fuelStation.getFuelStationSource()}],' +
        'we have found incorrect Operating Hours ${_operatingHours.operatingTimeRange} for fuel ${_operatingHours.dayOfWeek}';
  }
}
