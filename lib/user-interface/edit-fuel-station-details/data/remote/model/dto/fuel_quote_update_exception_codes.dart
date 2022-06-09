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

class FuelQuoteUpdateExceptionCodes {
  static const updateFreqExceeded = 'UPDATE_FREQ_EXCEEDED';
  static const priceNotInRange = 'PRICE_NOT_IN_RANGE';
  static const versionMismatch = 'VERSION_MIS_MATCH';
  static const priceNotChanged = 'PRICE_NOT_CHANGED';
  static const fuelMeasureNotConfiguredForMarketRegion = 'FUEL_MEASURE_NOT_CONFIGURED_FOR_MARKET_REGION';
  static const fuelPriceNotConfiguredForMarketRegion = 'FUEL_PRICE_NOT_CONFIGURED_FOR_MARKET_REGION';
  static const fuelTypeNotConfiguredForMarketRegion = 'FUEL_TYPE_NOT_CONFIGURED_FOR_MARKET_REGION';
  static const invalidParamForFuelQuote = 'INVALID_PARAM_FOR_FUEL_QUOTE';
  static const updatingFuelQuoteOfMultipleStations = 'UPDATING_FUEL_QUOTES_OF_MULTIPLE_STATIONS';
  static const noFuelQuotesProvided = 'NO_FUEL_QUOTES_PROVIDED';
  static const fuelQuoteFuelAuthoritySource = 'FUEL_QUOTE_FUEL_AUTHORITY_SOURCE';
  static const fuelQuoteMerchantSource = 'FUEL_QUOTE_MERCHANT_SOURCE';
}
