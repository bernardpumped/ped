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
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/email_widget.dart';
import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/fuel-station-details/widgets/notification_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';

class FuelPriceSourceCitation extends StatelessWidget {
  static const _padding = 15.0;
  static const _margin = 30.0;
  static const _pumpedMessage = 'If fuel price is incorrect please let us know';

  final FuelQuote fuelQuote;
  final FuelStation fuelStation;

  const FuelPriceSourceCitation(this.fuelQuote, this.fuelStation, {Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_padding)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: _dialogContent(context));
  }

  Widget _dialogContent(final BuildContext context) {
    final String? fuelQuoteSource = fuelQuote.fuelQuoteSource;
    Widget child;
    if (fuelQuoteSource == 'F') {
      child = _getFuelAuthorityMessage(context);
    } else if (fuelQuoteSource == 'C') {
      child = _getCrowdSourceMessage(context);
    } else {
      child = const SizedBox(height: 0);
    }
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(_padding),
            margin: const EdgeInsets.only(top: _margin),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(_padding),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
            child: child));
  }

  Column _getFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(padding: const EdgeInsets.only(bottom: 8), child: _getFuelAuthorityHeader()),
      const Divider(color: Colors.black54, height: 1),
      Padding(padding: const EdgeInsets.only(top: 8, bottom: 10), child: _getAdminContactMessage()),
      _getOkActionButton(context)
    ]);
  }

  Column _getCrowdSourceMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      const Padding(
          padding: EdgeInsets.only(top: 15, bottom: 10),
          child: Text('Fuel Price Crowd Sourced',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black87))),
      const Divider(color: Colors.black54, height: 1),
      Padding(padding: const EdgeInsets.only(bottom: 10, top: 10), child: _getAdminContactMessage()),
      const Divider(color: Colors.black54, height: 1),
      _getOkActionButton(context)
    ]);
  }

  Widget _getFuelAuthorityHeader() {
    return Container(
        decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(3)),
        width: double.infinity,
        padding: const EdgeInsets.only(top: 15, bottom: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Price Source ${_getFuelAuthorityQuotePublisher()}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 3),
          const Text('Price updated near realtime',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black54))
        ]));
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(children: [
      WidgetUtils.getRoundedElevatedButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          },
          borderRadius: 10.0,
          backgroundColor: Theme.of(context).primaryColor),
      const SizedBox(width: 10),
      _getNotificationWidget()
    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }

  Widget _getNotificationWidget() {
    var notificationType = notificationTypeMap[fuelQuote.fuelQuoteSourceName];
    if (notificationType == emailNotificationType) {
      // fuelQuote.fuelQuoteSourceName can never be null.
      return EmailNotificationWidget(emailBody: _getEmailBody(), emailSubject: _getEmailSubject(), source: fuelQuote.fuelQuoteSourceName!);
    } else if (notificationType == externalUrlNotificationType) {
      return NotificationWidget(fuelStation: fuelStation);
    }
    return const SizedBox(width: 0,);
  }

  Text _getAdminContactMessage() {
    return const Text(_pumpedMessage,
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
    String publishDateTxt = publishDate != null ? 'publish date : $publishDate' : '';
    final String deviceDate = dateFormat.format(DateTime.now().toUtc());
    String message = 'Hello fuel support it appears fuelStation Id: ${fuelStation.stationId} name : ${fuelStation.fuelStationName}'
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
    'nsw' : emailNotificationType,
    'qld' : externalUrlNotificationType,
    'sa' : emailNotificationType,
    'fwa' : emailNotificationType,
    'tas' : emailNotificationType,
    'nt' : emailNotificationType
  };
}
