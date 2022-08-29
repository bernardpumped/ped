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
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/email_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/util/log_util.dart';

class OperatingHoursSourceCitation extends StatelessWidget {
  static const _pumpedMessage = 'If Operating hours are incorrect please let us know';
  final OperatingHours _operatingHours;
  final FuelStation _fuelStation;
  final String weekDay;
  final String operatingTimeRange;

  const OperatingHoursSourceCitation(this._operatingHours, this._fuelStation, this.weekDay, this.operatingTimeRange,
      {Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final String? operatingTimeSource = _operatingHours.operatingTimeSource;
    LogUtil.debug(
        'OperatingHoursSourceCitation', 'operatingTimeSourceName : ${_operatingHours.operatingTimeSourceName}');
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
        child: _getOperatingHrsSourceMessage(context, operatingTimeSource, _operatingHours.operatingTimeSourceName));
  }

  Column _getOperatingHrsSourceMessage(
      final BuildContext context, final String? operatingTimeSource, final String? operatingTimeSourceName) {
    String sourceMessage;
    if (operatingTimeSource == 'C') {
      sourceMessage = 'Operating time Crowd Sourced';
    } else if (operatingTimeSource == 'G') {
      sourceMessage = 'Operating time Google Source';
    } else {
      sourceMessage = 'Operating time $operatingTimeSourceName Source';
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Text(weekDay, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
        const SizedBox(width: 10),
        Text(operatingTimeRange, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500))
      ]),
      const SizedBox(height: 14),
      const Divider(height: 1),
      const SizedBox(height: 10),
      Text(sourceMessage, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
      const SizedBox(height: 12),
      Text('Last Update Time ${_getPublishDateFormatted(_operatingHours.publishDate!)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
      const SizedBox(height: 14),
      const Divider(height: 1),
      const SizedBox(height: 14),
      _getAdminContactMessage(),
      const SizedBox(height: 15),
      _getOkActionButton(context)
    ]);
  }

  String _getPublishDateFormatted(final DateTime publishDate) {
    final formatter = DateFormat('dd-MM-yy HH:mm');
    return formatter.format(publishDate);
  }

  Text _getAdminContactMessage() {
    return const Text(_pumpedMessage,
        textAlign: TextAlign.start, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.red));
  }

  Widget _getOkActionButton(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      WidgetUtils.getRoundedButton(
          context: context,
          buttonText: 'Cancel',
          iconData: Icons.cancel_outlined,
          onTapFunction: () {
            Navigator.pop(context);
          }),
      const SizedBox(width: 10),
      _getNotificationWidget()
    ]);
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
    LogUtil.debug(
        'OperatingHoursSourceCitation', 'source : $source, sourceName : ${_operatingHours.operatingTimeSourceName}');
    if (source == 'G' || source == 'C') {
      return EmailNotificationWidget(emailBody: _getEmailBody(), emailSubject: _getEmailSubject(), sourceName: source!);
    } else if (source == 'F') {
      return EmailNotificationWidget(
          emailBody: _getEmailBody(),
          emailSubject: _getEmailSubject(),
          sourceName: _operatingHours.operatingTimeSourceName!);
    } else {
      return const SizedBox(width: 0);
    }
  }
}
