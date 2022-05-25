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

class TextLocaleMenuItemWidget extends StatefulWidget {
  const TextLocaleMenuItemWidget({Key? key}) : super(key: key);

  @override
  State<TextLocaleMenuItemWidget> createState() => _TextLocaleMenuItemWidgetState();
}

class _TextLocaleMenuItemWidgetState extends State<TextLocaleMenuItemWidget> {
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
    return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: ExpansionTile(
          title: Text("Locale - ${_locales[selectedLocale]}",
              style: const TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.w500)),
          leading: const Icon(Icons.language, color: Colors.indigo, size: 30),
          children: [
            _getMenuItem(_systemLocale),
            _getMenuItem(_deutschLocale),
            _getMenuItem(_englishLocale),
            _getMenuItem(_englishAusLocale),
            _getMenuItem(_englishUkLocale),
            _getMenuItem(_spanishLocale),
            _getMenuItem(_frenchLocale),
            _getMenuItem(_hindiLocale)
          ],
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
        title: Text(_locales[value]!, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.indigo)));
  }
}
