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

import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';

class FuelStationsSorter {
  void sortFuelStations(final List<FuelStation> fuelStations, final String? fuelType, final int sortOrder) {
    if (fuelStations.isEmpty) {
      return;
    }
    fuelStations.sort((fs1, fs2) {
      switch (sortOrder) {
        case 0:
          return _comparisonResultForNameSortOrder(fs1, fs2, fuelType);
        case 1:
          return _comparisonResultForPriceSortOrder(fs1, fs2, fuelType);
        case 2:
          return _comparisonResultForDistanceSortOrder(fs1, fs2, fuelType);
        case 3:
          return _comparisonResultForPromoSortOrder(fs1, fs2, fuelType);
        default:
          return _comparisonResultForPriceSortOrder(fs1, fs2, fuelType);
      }
    });
  }

  int _comparisonResultForPromoSortOrder(final FuelStation fs1, final FuelStation fs2, final String? fuelType) {
    int comparisonResult = _compareOffers(fs1, fs2);
    if (comparisonResult == 0) {
      comparisonResult = _compareFuelQuotes(fs1, fs2, fuelType);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareDistance(fs1, fs2);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareNames(fs1, fs2);
    }
    return comparisonResult;
  }

  int _comparisonResultForPriceSortOrder(final FuelStation fs1, final FuelStation fs2, final String? fuelType) {
    int comparisonResult = _compareFuelQuotes(fs1, fs2, fuelType);
    if (comparisonResult == 0) {
      comparisonResult = _compareDistance(fs1, fs2);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareNames(fs1, fs2);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareOffers(fs1, fs2);
    }
    return comparisonResult;
  }

  int _comparisonResultForDistanceSortOrder(final FuelStation fs1, final FuelStation fs2, final String? fuelType) {
    int comparisonResult = _compareDistance(fs1, fs2);
    if (comparisonResult == 0) {
      comparisonResult = _compareFuelQuotes(fs1, fs2, fuelType);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareNames(fs1, fs2);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareOffers(fs2, fs1);
    }
    return comparisonResult;
  }

  int _comparisonResultForNameSortOrder(final FuelStation fs1, final FuelStation fs2, final String? fuelType) {
    int comparisonResult = _compareNames(fs1, fs2);
    if (comparisonResult == 0) {
      comparisonResult = _compareFuelQuotes(fs1, fs2, fuelType);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareDistance(fs1, fs2);
    }
    if (comparisonResult == 0) {
      comparisonResult = _compareOffers(fs1, fs2);
    }
    return comparisonResult;
  }

  int _compareOffers(final FuelStation fs1, final FuelStation fs2) =>
      (fs2.promos + fs2.services - fs1.promos - fs1.services).toInt();

  int _compareDistance(final FuelStation fs1, final FuelStation fs2) => fs1.distance.compareTo(fs2.distance);

  int _compareFuelQuotes(final FuelStation fs1, final FuelStation fs2, final String? fuelType) {
    if (fuelType == null) {
      return 0;
    }
    final FuelQuote? fq1 = fs1.fuelTypeFuelQuoteMap[fuelType];
    final FuelQuote? fq2 = fs2.fuelTypeFuelQuoteMap[fuelType];
    final double? quoteVal1 = fq1 != null && fq1.quoteValue != null ? fq1.quoteValue : double.maxFinite;
    final double? quoteVal2 = fq2 != null && fq2.quoteValue != null ? fq2.quoteValue : double.maxFinite;
    return quoteVal1 == null ? -1 : (quoteVal2 == null ? 1 : quoteVal1.compareTo(quoteVal2));
  }

  static int _compareNames(fs1, fs2) => fs1.fuelStationName.toLowerCase().compareTo(fs2.fuelStationName.toLowerCase());
}
