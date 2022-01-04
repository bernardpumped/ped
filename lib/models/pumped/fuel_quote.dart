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

import 'package:flutter/cupertino.dart';

class FuelQuote {
  final int fuelQuoteId;
  final int fuelStationId;
  final String fuelType;
  final String fuelMeasure;
  double quoteValue;
  final int fuelBrandId;
  final String fuelQuoteSourceName;
  String fuelQuoteSource;
  int publishDate; //In seconds

  FuelQuote(
      {this.fuelQuoteId,
      @required this.fuelStationId,
      @required this.fuelType,
      this.fuelMeasure,
      @required this.quoteValue,
      this.fuelBrandId,
      this.fuelQuoteSourceName,
      this.fuelQuoteSource,
      @required this.publishDate});

  bool crowdSourced() => fuelQuoteSource == 'C';

  bool fuelAuthoritySource() => fuelQuoteSource == 'F';

  bool merchantSource() => fuelQuoteSource == 'M';
}
