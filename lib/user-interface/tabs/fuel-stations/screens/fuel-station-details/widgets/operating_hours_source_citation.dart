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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/email_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/util/log_util.dart';

class OperatingHoursSourceCitation extends StatelessWidget {
  static const _padding = 15.0;
  static const _margin = 30.0;
  static const _pumpedMessage = 'If Operating hours are incorrect please let us know';
  final OperatingHours _operatingHours;
  final FuelStation _fuelStation;

   const OperatingHoursSourceCitation(this._operatingHours, this._fuelStation, {Key? key}) : super(key: key);

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
    final String? operatingTimeSource = _operatingHours.operatingTimeSource;
    LogUtil.debug('OperatingHoursSourceCitation', 'operatingTimeSourceName : ${_operatingHours.operatingTimeSourceName}');
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(_padding),
            margin: const EdgeInsets.only(top: _margin),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(_padding),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
            child: _getOperatingHrsSourceMessage(context, operatingTimeSource, _operatingHours.operatingTimeSourceName)));
  }

  Column _getOperatingHrsSourceMessage(final BuildContext context, final String? operatingTimeSource, final String? operatingTimeSourceName) {
    String sourceMessage;
    if (operatingTimeSource == 'C') {
      sourceMessage = 'Operating time Crowd Sourced';
    } else if (operatingTimeSource == 'G') {
      sourceMessage = 'Operating time Google Source';
    } else {
      sourceMessage = 'Operating time $operatingTimeSourceName Source';
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Text(sourceMessage, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black87))),
      const Divider(color: Colors.black54, height: 1),
      Padding(padding: const EdgeInsets.only(bottom: 10, top: 10), child: _getAdminContactMessage()),
      const Divider(color: Colors.black54, height: 1),
      _getOkActionButton(context)
    ]);
  }

  Text _getAdminContactMessage() {
    return const Text(_pumpedMessage,
        textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.red));
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(children: [
      WidgetUtils.getRoundedElevatedButton(
          child: const Text('Cancel'),
          foreGroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          borderRadius: 10.0,
          onPressed: () {
            Navigator.pop(context);
          }),
      const SizedBox(width: 10),
      _getNotificationWidget(),
    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }

  String _getEmailSubject() {
    return 'Operating Time Incorrect : ${_fuelStation.fuelStationName} | ${_operatingHours.dayOfWeek}';
  }

  String _getEmailBody() {
    return 'For the fuelStation ${_fuelStation.fuelStationName} [${_fuelStation.stationId} | ${_fuelStation.getFuelStationSource()}],'
        'we have found incorrect Operating Hours ${_operatingHours.operatingTimeRange} for fuel ${_operatingHours.dayOfWeek}';
  }

  Widget _getNotificationWidget() {
    final source = _operatingHours.operatingTimeSource;
    LogUtil.debug('OperatingHoursSourceCitation', 'source : $source, sourceName : ${_operatingHours.operatingTimeSourceName}');
    if (source == 'G' || source == 'C') {
      return EmailNotificationWidget(emailBody: _getEmailBody(), emailSubject: _getEmailSubject(), source: source!);
    } else if (source == 'F') {
      return EmailNotificationWidget(emailBody: _getEmailBody(), emailSubject: _getEmailSubject(), source: _operatingHours.operatingTimeSourceName!);
    }  else {
      return const SizedBox(width: 0);
    }
  }
}
