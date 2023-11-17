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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/widget/email_widget.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/widget/notification_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FuelPriceSourceCitationWidget extends StatelessWidget {
  static const _tag = 'FuelPriceSourceCitationWidget';
  final FuelQuote fuelQuote;
  final FuelStation fuelStation;
  final String fuelTypeName;

  const FuelPriceSourceCitationWidget(this.fuelQuote, this.fuelStation, this.fuelTypeName, {super.key});

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
    return Container(padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40), child: child);
  }

  String _getPublishDateFormatted(final int publishDateSeconds) {
    final formatter = DateFormat('dd-MMM-yy HH:mm');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(publishDateSeconds * 1000));
  }

  Column _getFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(children: [
        Text(fuelTypeName, style: Theme.of(context).textTheme.headlineMedium,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
        const SizedBox(width: 10),
        Text(fuelQuote.quoteValue.toString(), style: Theme.of(context).textTheme.headlineMedium,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
      ]),
      const SizedBox(height: 12),
      const Divider(height: 1),
      const SizedBox(height: 6),
      Text('Price Source ${_getFuelAuthorityQuotePublisher()}', style: Theme.of(context).textTheme.titleLarge,
          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
      const SizedBox(height: 6),
      Text('Price updated near realtime ${_getPublishDateFormatted(fuelQuote.publishDate!)}',
          style: Theme.of(context).textTheme.bodyMedium,
          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
      const SizedBox(height: 6),
      const Divider(height: 1),
      const SizedBox(height: 6),
      _getAdminContactMessage(context),
      const SizedBox(height: 8),
      _getOkActionButton(context)
    ]);
  }

  Column _getCrowdSourceMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(children: [
        Text(fuelTypeName, style: Theme.of(context).textTheme.headlineMedium,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
        const SizedBox(width: 10),
        Text(fuelQuote.quoteValue.toString(), style: Theme.of(context).textTheme.headlineMedium,
            textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)
      ]),
      const SizedBox(height: 12),
      const Divider(height: 1),
      const SizedBox(height: 6),
      Text('Fuel Price Crowd Sourced', style: Theme.of(context).textTheme.titleLarge,
          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
      const SizedBox(height: 6),
      Text('Price updated ${_getPublishDateFormatted(fuelQuote.publishDate!)}',
          style: Theme.of(context).textTheme.bodyMedium,
          textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor),
      const SizedBox(height: 6),
      const Divider(height: 1),
      const SizedBox(height: 6),
      _getAdminContactMessage(context),
      const SizedBox(height: 8),
      _getOkActionButton(context)
    ]);
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child:
                  Row(children: [const Icon(Icons.cancel_outlined, size: 24), const SizedBox(width: 10),
                    Text('Cancel', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)]))),
      const SizedBox(width: 10),
      _getNotificationWidget()
    ]);
  }

  Widget _getNotificationWidget() {
    var notificationType = notificationTypeMap[fuelQuote.fuelQuoteSourceName];
    if (notificationType == emailNotificationType || fuelQuote.crowdSourced()) {
      return EmailNotificationWidget(
          emailBody: _getEmailBody(), emailSubject: _getEmailSubject(), sourceName: fuelQuote.fuelQuoteSourceName!);
    } else if (notificationType == externalUrlNotificationType) {
      return NotificationWidget(fuelStation: fuelStation);
    }
    return const SizedBox(width: 0);
  }

  Widget _getAdminContactMessage(final BuildContext context) {
    final List<String?> publishers = fuelStation.getPublishers();
    if (publishers.isNotEmpty && publishers[0] == 'sa') {
      return _getTextForSa(context);
    } else {
      return _getTextForOtherFa(context);
    }
  }

  Text _getTextForOtherFa(final BuildContext context) {
    return Text('If fuel price is incorrect please let us know',
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
  }

  Text _getTextForSa(final BuildContext context) {
    return Text.rich(TextSpan(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
        children: [
          const TextSpan(text: "If fuel price is incorrect please let us know by either raising a ticket with "),
          TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.error, decoration: TextDecoration.underline),
              text: "SA Fuel Pricing - Complaint Site",
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  const url =
                      "https://sagov.iapply.com.au/#/form/6029c6a9ad9c5a1dd463e6db/app/605a2b11ad9c5b4258bbf31b";
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    LogUtil.debug(_tag, "Cannot launch Url $url");
                  }
                }),
          TextSpan(
              text: " or email us and we'll follow it up",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error)),
        ]));
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
