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

class FuelStationSourceCitation extends StatelessWidget {
  static const _padding = 15.0;
  static const _margin = 30.0;
  static const _subTitle = 'Fuel Price Data License Obligation';

  static const _qld_license_para_1 =
      '© State of Queensland (Department of Natural Resources Mines and Energy) 2018. In consideration of the State permitting use of this data you acknowledge and agree that the State gives no warranty in relation to the data (including accuracy, reliability, completeness, currency or suitability) and accepts no liability (including without limitation, liability in negligence) for any loss, damage or costs (including consequential damage) relating to any use of the data. Data must not be used for direct marketing or be used in breach of the privacy laws.';
  static const _qld_license_para_2 =
      'Based on or contains data provided by the State of Queensland (Department of Natural Resources Mines and Energy) 2018. In consideration of the State permitting use of this data you acknowledge and agree that the State gives no warranty in relation to the data (including accuracy, reliability, completeness, currency or suitability) and accepts no liability (including without limitation, liability in negligence) for any loss, damage or costs (including consequential damage) relating to any use of the data. Data must not be used for direct marketing or be used in breach of the privacy laws.';
  static const _pumped_message = 'If fuel price is incorrect please let us know';

  final FuelStation fuelStation;

  const FuelStationSourceCitation({Key key, this.fuelStation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_padding)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: _dialogContent(context));
  }

  Widget _dialogContent(final BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(_padding),
            margin: EdgeInsets.only(top: _margin),
            decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(_padding),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: const Offset(0.0, 10.0))]),
            child: _getQldFuelAuthorityMessage(context)));
  }

  Widget _getQldFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(_subTitle,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black87))),
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(_qld_license_para_1,
              textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black54))),
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(_qld_license_para_2,
              textAlign: TextAlign.start, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black54))),
      Padding(padding: EdgeInsets.only(bottom: 10), child: _getAdminContactMessage()),
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
    return 'Fuel Price Incorrect';
  }

  String _getEmailBody() {
    return 'For the fuelStation ${fuelStation.fuelStationName} [${fuelStation.stationId} | ${fuelStation.getFuelStationSource()}],' +
        'we have found incorrect Price ';
  }
}
