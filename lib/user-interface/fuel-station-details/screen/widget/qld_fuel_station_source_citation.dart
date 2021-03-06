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
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/fuel_station_details_screen_color_scheme.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/screen/tabs/fuel-prices/widget/notification_widget.dart';
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

  QldFuelStationSourceCitation({Key? key, required this.fuelStation}) : super(key: key);

  final FuelStationDetailsScreenColorScheme colorScheme =
      getIt.get<FuelStationDetailsScreenColorScheme>(instanceName: fsDetailsScreenColorSchemeName);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
        child: _getQldFuelAuthorityMessage(context));
  }

  Widget _getQldFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(_subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.w600, color: colorScheme.fuelStationTitleTextColor))),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_qldLicensePara1,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14.0, fontWeight: FontWeight.w400, color: colorScheme.fuelStationTitleTextColor))),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_qldLicensePara2,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14.0, fontWeight: FontWeight.w400, color: colorScheme.fuelStationTitleTextColor))),
      Padding(padding: const EdgeInsets.only(bottom: 10), child: _getAdminContactMessage()),
      Divider(color: colorScheme.fuelStationTitleTextColor, height: 1),
      _getOkActionButton(context)
    ]);
  }

  Text _getAdminContactMessage() {
    return const Text(_pumpedMessage,
        textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.red));
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      WidgetUtils.getRoundedElevatedButton(
          child: Row(children: const [
            Icon(Icons.cancel_outlined, size: 24, color: Colors.white),
            SizedBox(width: 10),
            Text('Cancel', style: TextStyle(color: Colors.white))
          ]),
          foreGroundColor: colorScheme.actionBtnTextColor,
          backgroundColor: colorScheme.actionBtnBackgroundColor,
          borderRadius: 10.0,
          onPressed: () {
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
