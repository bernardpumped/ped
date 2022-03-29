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

import 'dart:math';

import 'package:pumped_end_device/models/pumped/fuel_quote.dart';

class DataUtils {
  static double toPrecision(final double val, final int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble()).toDouble();
    return ((val * mod).round().toDouble() / mod);
  }

  static bool isBlank(final String? string) {
    return string == null || string.isEmpty || string.trim().isEmpty;
  }

  static bool isNotBlank(final String? string) {
    return !isBlank(string);
  }

  static String getOrDefault(final String value, final String defaultValue) {
    return isNotBlank(value) ? value : defaultValue;
  }

  static bool stringEqual(final String? str1, final String? str2, bool nullBlankSame) {
    if (str1 == str2) {
      return true;
    } else {
      if (nullBlankSame) {
        return isBlank(str1) && isBlank(str2);
      }
    }
    return false;
  }

  static bool isValidNumber(final String? phoneNumber) {
    final RegExp regExp =
        RegExp(r"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$", caseSensitive: false, multiLine: false);
    return phoneNumber != null && regExp.hasMatch(phoneNumber);
  }

  // Assumption is that this method is called after every typed or deleted char
  static String? charDeleted(final String? oldValue, final String? newValue) {
    if (oldValue == null) {
      return null;
    }
    if (newValue == null) {
      return oldValue;
    }
    if (oldValue.length > newValue.length) {
      return oldValue.replaceAll(newValue, '');
    }
    return null;
  }

  static FuelQuote duplicateWithOverrideQuoteValue(final FuelQuote fuelQuote, final double quoteValue) {
    return FuelQuote(
        fuelQuoteId: fuelQuote.fuelQuoteId,
        fuelStationId: fuelQuote.fuelStationId,
        fuelType: fuelQuote.fuelType,
        fuelMeasure: fuelQuote.fuelMeasure,
        quoteValue: quoteValue,
        fuelBrandId: fuelQuote.fuelBrandId,
        fuelQuoteSourceName: fuelQuote.fuelQuoteSourceName,
        fuelQuoteSource: fuelQuote.fuelQuoteSource,
        publishDate: fuelQuote.publishDate);
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
