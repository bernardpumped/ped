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
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/widget/notification_widget.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';

class QldFuelStationSourceCitation extends StatelessWidget {
  static const _subTitle = 'QLD - Fuel Price Data License Obligation';

  static const _qldLicensePara1 =
      '© State of Queensland (Department of Natural Resources Mines and Energy) 2018. In consideration of the State '
      'permitting use of this data you acknowledge and agree that the State gives no warranty in relation to the data '
      '(including accuracy, reliability, completeness, currency or suitability) and accepts no liability '
      '(including without limitation, liability in negligence) for any loss, damage or costs '
      '(including consequential damage) relating to any use of the data. Data must not be used for direct '
      'marketing or be used in breach of the privacy laws.';

  static const _qldLicensePara2 =
      'Based on or contains data provided by the State of Queensland (Department of Natural Resources Mines and Energy) '
      '2018. In consideration of the State permitting use of this data you acknowledge and agree that the State '
      'gives no warranty in relation to the data (including accuracy, reliability, completeness, currency or '
      'suitability) and accepts no liability (including without limitation, liability in negligence) for any loss, '
      'damage or costs (including consequential damage) relating to any use of the data. Data must not be used for '
      'direct marketing or be used in breach of the privacy laws.';

  static const _pumpedMessage = 'If fuel price is incorrect please let us know';

  final FuelStation fuelStation;

  const QldFuelStationSourceCitation({Key? key, required this.fuelStation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(15), child: _getQldFuelAuthorityMessage(context));
  }

  Widget _getQldFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(_subTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_qldLicensePara1, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_qldLicensePara2, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(padding: const EdgeInsets.only(bottom: 6), child: _getAdminContactMessage(context)),
      const Divider(height: 1),
      const SizedBox(height: 6),
      _getOkActionButton(context)
    ]);
  }

  Text _getAdminContactMessage(final BuildContext context) {
    return Text(_pumpedMessage,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
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
      _getNotificationWidget(),
    ]);
  }

  Widget _getNotificationWidget() {
    final Set<String?> fuelQuoteSources = fuelStation.fuelQuoteSources();
    return fuelQuoteSources.isNotEmpty ? NotificationWidget(fuelStation: fuelStation) : const SizedBox(width: 0);
  }
}
