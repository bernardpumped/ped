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
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/email_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/widget/notification_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';

class FuelPriceSourceCitationWidget extends StatelessWidget {
  final FuelQuote fuelQuote;
  final FuelStation fuelStation;
  final String fuelTypeName;

  const FuelPriceSourceCitationWidget(this.fuelQuote, this.fuelStation, this.fuelTypeName, {Key? key})
      : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final String? fuelQuoteSource = fuelQuote.fuelQuoteSource;
    Widget child;
    if (fuelQuoteSource == 'F') {
      child = _getFuelAuthorityMessage(context);
    } else if (fuelQuoteSource == 'C') {
      child = _getCrowdSourceMessage(context);
    } else {
      child = const SizedBox(height: 0);
    }
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
        child: child);
  }

  String _getPublishDateFormatted(final int publishDateSeconds) {

    final formatter = DateFormat('dd-MMM-yy HH:mm');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(publishDateSeconds * 1000));
  }

  Column _getFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(children: [
        Text(fuelTypeName, style: const TextStyle(fontSize: 22, color: Colors.indigo, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Text(fuelQuote.quoteValue.toString(),
            style: const TextStyle(fontSize: 22, color: Colors.indigo, fontWeight: FontWeight.bold))
      ]),
      const SizedBox(height: 12),
      const Divider(color: Colors.indigo, height: 1),
      const SizedBox(height: 8),
      Text('Price Source ${_getFuelAuthorityQuotePublisher()}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.indigo)),
      const SizedBox(height: 8),
      Text('Price updated near realtime ${_getPublishDateFormatted(fuelQuote.publishDate!)}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.indigo)),
      const SizedBox(height: 12),
      const Divider(color: Colors.indigo, height: 1),
      const SizedBox(height: 12),
      _getAdminContactMessage(),
      const SizedBox(height: 12),
      _getOkActionButton(context)
    ]);
  }

  Column _getCrowdSourceMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(children: [
        Text(fuelTypeName, style: const TextStyle(fontSize: 22, color: Colors.indigo, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Text(fuelQuote.quoteValue.toString(),
            style: const TextStyle(fontSize: 22, color: Colors.indigo, fontWeight: FontWeight.bold))
      ]),
      const SizedBox(height: 12),
      const Divider(color: Colors.indigo, height: 1),
      const SizedBox(height: 8),
      const Text('Fuel Price Crowd Sourced',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.indigo)),
      const SizedBox(height: 8),
      Text('Price updated ${_getPublishDateFormatted(fuelQuote.publishDate!)}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.indigo)),
      const SizedBox(height: 12),
      const Divider(color: Colors.indigo, height: 1),
      const SizedBox(height: 12),
      _getAdminContactMessage(),
      const SizedBox(height: 12),
      _getOkActionButton(context)
    ]);
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      WidgetUtils.getRoundedElevatedButton(
          child: Row(children: const [
            Icon(Icons.cancel_outlined, size: 24, color: Colors.white),
            SizedBox(width: 10),
            Text('Cancel', style: TextStyle(color: Colors.white))
          ]),
          onPressed: () {
            Navigator.pop(context);
          },
          borderRadius: 10.0,
          backgroundColor: Colors.indigo),
      const SizedBox(width: 10),
      _getNotificationWidget()
    ]);
  }

  Widget _getNotificationWidget() {
    var notificationType = notificationTypeMap[fuelQuote.fuelQuoteSourceName];
    if (notificationType == emailNotificationType || fuelQuote.crowdSourced()) {
      // fuelQuote.fuelQuoteSourceName can never be null.
      return EmailNotificationWidget(
          emailBody: _getEmailBody(),
          emailSubject: _getEmailSubject(),
          sourceName: fuelQuote.fuelQuoteSourceName!);
    } else if (notificationType == externalUrlNotificationType) {
      return NotificationWidget(fuelStation: fuelStation);
    }
    return const SizedBox(width: 0);
  }

  Text _getAdminContactMessage() {
    return const Text('If fuel price is incorrect please let us know',
        textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.red));
  }

  String? _getFuelAuthorityQuotePublisher() {
    final List<String?> publishers = fuelStation
        .fuelQuotes()
        .where((fq) => fq.fuelQuoteSource != null && fq.fuelQuoteSource != 'C')
        .map((fq) => fq.fuelQuoteSourceName)
        .toList();
    if (publishers.isNotEmpty) {
      return publishers[0];
    }
    return null;
  }

  String _getEmailSubject() {
    return 'Fuel Price Incorrect : ${fuelStation.fuelStationName} | ${fuelQuote.fuelType}';
  }

  String _getEmailBody() {
    final FuelStationAddress addr = fuelStation.fuelStationAddress;
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    String? publishDate;
    if (fuelQuote.publishDate != null) {
      publishDate = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(fuelQuote.publishDate! * 1000).toUtc());
    }
    String publishDateTxt = publishDate != null ? ' publish date : $publishDate' : '';
    final String deviceDate = dateFormat.format(DateTime.now().toUtc());
    String message =
        'Hello fuel support it appears fuelStation Id: ${fuelStation.stationId} name : ${fuelStation.fuelStationName}'
        ', ${addr.addressLine1}, ${addr.zip}, ${addr.state} may have an incorrect Price ${fuelQuote.quoteValue} for fuel type ${fuelQuote.fuelType}'
        '$publishDateTxt. Dear user within this email please include the actual fuel type price as of $deviceDate '
        'and we\'ll follow it up for you - best regards pumped fuel';
    if (fuelStation.fuelAuthorityStationCode != null) {
      message = '$message [stationCode=${fuelStation.fuelAuthorityStationCode}]';
    }
    return message;
  }

  static const emailNotificationType = 'email';
  static const externalUrlNotificationType = 'external-url';

  static const notificationTypeMap = {
    'nsw': emailNotificationType,
    'qld': externalUrlNotificationType,
    'sa': emailNotificationType,
    'fwa': emailNotificationType,
    'tas': emailNotificationType,
    'nt': emailNotificationType
  };
}
