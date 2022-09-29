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
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';

class SaFuelStationSourceCitation extends StatelessWidget {
  static const _subTitle = 'SA - Fuel Price Data License Obligation';

  static const _saLicensePara1 = '© State of South Australia (Office of Consumer and Business Services 2021-2023. '
      'Copyright of the State of South Australia';

  static const _saLicensePara2 = 'Based on or contains data provided by the State of South Australia '
      '(Office of Consumer and Business Services 2021-2023). In consideration of the State permitting use of this '
      'data you acknowledge and agree that the State gives no warranty in relation to the data (including accuracy, '
      'reliability, completeness, currency or suitability) and accepts no liability (including without limitation, '
      'liability in negligence) for any loss, damage or costs (including consequential damage) relating to any use '
      'of the data. Data must not be used for direct marketing or be used in breach of the privacy laws.';

  static const _pumpedMessage = 'If fuel price is incorrect please let us know';

  const SaFuelStationSourceCitation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))]),
        child: _getQldFuelAuthorityMessage(context));
  }

  Widget _getQldFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(_subTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_saLicensePara1, textAlign: TextAlign.start, style: Theme.of(context).textTheme.subtitle2)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_saLicensePara2, textAlign: TextAlign.start, style: Theme.of(context).textTheme.subtitle2)),
      Padding(padding: const EdgeInsets.only(bottom: 10), child: _getAdminContactMessage(context)),
      const Divider(height: 1),
      const SizedBox(height: 10),
      _getOkActionButton(context)
    ]);
  }

  Text _getAdminContactMessage(final BuildContext context) {
    return Text(_pumpedMessage,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Theme.of(context).errorColor));
  }

  Widget _getOkActionButton(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      WidgetUtils.getRoundedButton(
          context: context,
          buttonText: 'Cancel',
          iconData: Icons.cancel_outlined,
          onTapFunction: () {
            Navigator.pop(context);
          })
    ]);
  }
}
