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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';

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

  const QldFuelStationSourceCitation({super.key, required this.fuelStation});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
        child: SingleChildScrollView(child: _getQldFuelAuthorityMessage(context)));
  }

  Widget _getQldFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(_subTitle,
              maxLines: 2,
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_qldLicensePara1,
              maxLines: 8,
              textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleSmall,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_qldLicensePara2,
              maxLines: 8,
              textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleSmall,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(padding: const EdgeInsets.only(bottom: 10), child: _getAdminContactMessage(context)),
      const Divider(height: 1),
      const SizedBox(height: 10),
      _getOkActionButton(context)
    ]);
  }

  Text _getAdminContactMessage(final BuildContext context) {
    return Text(_pumpedMessage,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.error),
        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      WidgetUtils.getRoundedButton(
          context: context,
          buttonText: 'Cancel',
          iconData: Icons.cancel_outlined,
          onTapFunction: () {
            Navigator.pop(context);
          }),
      const SizedBox(width: 10),
      _getNotificationWidget(),
    ]);
  }

  Widget _getNotificationWidget() {
    final Set<String?> fuelQuoteSources = fuelStation.fuelQuoteSources();
    if (fuelQuoteSources.isNotEmpty) {
      return NotificationWidget(fuelStation: fuelStation);
    }
    return const SizedBox(
      width: 0,
    );
  }
}
