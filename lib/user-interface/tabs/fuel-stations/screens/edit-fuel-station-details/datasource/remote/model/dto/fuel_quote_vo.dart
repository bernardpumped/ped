/*
 *     Copyright (c) 2021.
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

import 'package:pumped_end_device/models/pumped/fuel_quote.dart';

class FuelQuoteVo {
  final int id;
  final int fuelStationId;
  final String fuelType;
  final String fuelMeasure;
  final double quoteValue;
  final int fuelBrandId;
  final String fuelQuoteSource;
  final int publishDate;

  FuelQuoteVo(
      {this.id,
      this.fuelStationId,
      this.fuelType,
      this.fuelMeasure,
      this.quoteValue,
      this.fuelBrandId,
      this.fuelQuoteSource,
      this.publishDate});

  Map<String, dynamic> toJson() => {
        'id': id,
        'fuelStationId': fuelStationId,
        'fuelType': fuelType,
        'fuelMeasure': fuelMeasure,
        'quoteValue': quoteValue,
        'fuelBrandId': fuelBrandId,
        'fuelQuoteSource': fuelQuoteSource,
        'publishDate': publishDate
      };

  static FuelQuoteVo getFuelQuoteVo(final FuelQuote fuelQuote) {
    return FuelQuoteVo(
        id: fuelQuote.fuelQuoteId,
        fuelStationId: fuelQuote.fuelStationId,
        fuelQuoteSource: fuelQuote.fuelQuoteSourceName,
        fuelBrandId: fuelQuote.fuelBrandId,
        quoteValue: fuelQuote.quoteValue,
        fuelType: fuelQuote.fuelType,
        fuelMeasure: fuelQuote.fuelMeasure,
        publishDate: fuelQuote.publishDate);
  }
}
