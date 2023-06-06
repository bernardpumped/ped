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
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';

class LocaleScreen extends StatefulWidget {
  const LocaleScreen({Key? key}) : super(key: key);

  @override
  State<LocaleScreen> createState() => _LocaleScreenState();
}

class _LocaleScreenState extends State<LocaleScreen> {
  static const _systemLocale = 'SYS_LOCALE';
  static const _deutschLocale = 'DEUTSCH_LOCALE';
  static const _englishLocale = 'ENG_LOCALE';
  static const _englishAusLocale = 'ENG_AUS_LOCALE';
  static const _englishUkLocale = 'ENG_UK_LOCALE';
  static const _spanishLocale = 'SPANISH_LOCALE';
  static const _frenchLocale = 'FRENCH_LOCALE';
  static const _hindiLocale = 'HINDI_LOCALE';

  static const _locales = {
    _systemLocale: 'System',
    _deutschLocale: 'Deutsch / German',
    _englishLocale: 'English',
    _englishAusLocale: 'English (Australia)',
    _englishUkLocale: 'English (United Kingdom)',
    _spanishLocale: 'Spanish',
    _frenchLocale: 'French',
    _hindiLocale: 'Hindi'
  };

  String selectedLocale = _systemLocale;

  @override
  Widget build(final BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 10, bottom: 15, left: 10),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Row(children: [
                  const Icon(Icons.language, size: 35),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Locale ', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.left,
                        textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor),
                  )
                ])),
            Card(
                child: Column(children: [
              _getMenuItem(_systemLocale),
              _getMenuItem(_deutschLocale),
              _getMenuItem(_englishLocale),
              _getMenuItem(_englishAusLocale),
              _getMenuItem(_englishUkLocale),
              _getMenuItem(_spanishLocale),
              _getMenuItem(_frenchLocale),
              _getMenuItem(_hindiLocale)
            ])),
            Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  WidgetUtils.getRoundedButton(context: context, buttonText: 'Set App Locale', iconData: Icons.language, onTapFunction: () {})
                ]))
          ]),
        ));
  }

  RadioListTile<String> _getMenuItem(final String value) {
    return RadioListTile<String>(
        value: value,
        groupValue: selectedLocale,
        onChanged: (newVal) {
          setState(() {
            selectedLocale = newVal!;
          });
        },
        title: Text(_locales[value]!, style: Theme.of(context).textTheme.titleLarge,
            textScaleFactor: TextScaler.of<TextScalingFactor>(context)?.scaleFactor));
  }
}
