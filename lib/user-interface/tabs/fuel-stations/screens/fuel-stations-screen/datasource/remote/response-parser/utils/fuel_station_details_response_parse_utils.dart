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

import 'package:pumped_end_device/user-interface/tabs/fuel-stations/screens/datasource/remote/response-parser/operating_hours_response_parse_utils.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';

class FuelStationDetailsResponseParseUtils {
  static Map<String, FuelStation> getStationIdStationMap(
      final Map<String, dynamic> responseJson, final Map<String, List<FuelQuote>> stationIdFuelQuotes) {
    final Map<String, dynamic> stationIdStationJsonMap = responseJson['fuelStations'];
    final Map<String, FuelStation> stationIdStationMap = {};
    for (final MapEntry<String, dynamic> me in stationIdStationJsonMap.entries) {
      final String stationIdStr = me.key;
      final Map<String, dynamic> fuelStationJsonVal = me.value;
      final bool activeItemPromotions =
          fuelStationJsonVal['activeItemPromotions'] ?? false;
      final bool activeAutoServicePromotions = fuelStationJsonVal['activeAutoServicePromotions'] ?? false;
      final List<FuelQuote> fuelQuotes = stationIdFuelQuotes[stationIdStr];
      final bool holidayToday = fuelStationJsonVal['holidayToday'];
      final OperatingHours operatingHours =
          OperatingHoursResponseParseUtils.getOperatingHours(fuelStationJsonVal['fuelFillOperatingTime'], holidayToday);
      final Map<String, FuelQuote> fuelTypeQuoteMap = {for (var fuelQuote in fuelQuotes) fuelQuote.fuelType: fuelQuote};
      final FuelStation fuelStation = FuelStation(
        stationId: fuelStationJsonVal['fuelStationId'],
        fuelStationAddress: _getFuelStationAddress(fuelStationJsonVal),
        fuelStationName: fuelStationJsonVal['stationName'],
        distance: fuelStationJsonVal['distance'],
        distanceUnit: fuelStationJsonVal['distanceUnit'],
        managed: fuelStationJsonVal['managed'],
        fuelAuthMatchStatus: fuelStationJsonVal['matchStatus'],
        merchant: fuelStationJsonVal['merchant'],
        merchantLogoUrl: fuelStationJsonVal['merchantLogoUrl'],
        rating: fuelStationJsonVal['rating'],
        stationType: fuelStationJsonVal['stationType'],
        hasPromos: activeItemPromotions || activeAutoServicePromotions,
        fuelTypeFuelQuoteMap: fuelTypeQuoteMap,
        imgUrls: null, //TODO
        isFaStation: fuelStationJsonVal['faStation'],
        status: OperatingHoursResponseParseUtils.getStatus(operatingHours, holidayToday: holidayToday),
        operatingHours: operatingHours,
      );
      stationIdStationMap.putIfAbsent(stationIdStr, () => fuelStation);
    }
    return stationIdStationMap;
  }

  static Map<String, List<FuelQuote>> getStationIdFuelQuotesMap(
      final Map<String, dynamic> responseJson, final String fuelAuthorityId) {
    final Map<String, dynamic> stationIdQuoteJsonMap = responseJson['stationFuelQuoteMap'];
    final Map<String, List<FuelQuote>> stationIdFuelQuotes = {};

    for (final MapEntry<String, dynamic> me in stationIdQuoteJsonMap.entries) {
      final String stationId = me.key;
      final List<dynamic> fuelQuotesJsonVal = me.value;
      final List<FuelQuote> fuelQuotes = [];
      for (var jsonVal in fuelQuotesJsonVal) {
        final String fuelQuoteSource = jsonVal['fuelQuoteSource'];
        String fuelQuoteSourceName = (fuelQuoteSource == 'C') ? "Crowd" : fuelAuthorityId;
        final FuelQuote fuelQuote = FuelQuote(
            fuelType: jsonVal['fuelType'],
            fuelMeasure: jsonVal['fuelMeasure'],
            fuelStationId: jsonVal['fuelStationId'],
            publishDate: jsonVal['publishDate'],
            quoteValue: jsonVal['quoteValue'],
            fuelBrandId: jsonVal['fuelBrandId'],
            fuelQuoteId: jsonVal['id'],
            fuelQuoteSourceName: fuelQuoteSourceName,
            fuelQuoteSource: jsonVal['fuelQuoteSource']);
        fuelQuotes.add(fuelQuote);
      }
      stationIdFuelQuotes.putIfAbsent(stationId, () => fuelQuotes);
    }
    return stationIdFuelQuotes;
  }

  static FuelStationAddress _getFuelStationAddress(final Map<String, dynamic> fuelStationJsonVal) {
    return FuelStationAddress(
        addressLine1: fuelStationJsonVal['addressLine'],
        latitude: fuelStationJsonVal['latitude'],
        longitude: fuelStationJsonVal['longitude'],
        contactName: fuelStationJsonVal['contactName'],
        countryName: fuelStationJsonVal['country'],
        email: fuelStationJsonVal['email'],
        fax: fuelStationJsonVal['fax'],
        locality: fuelStationJsonVal['locality'],
        phone1: fuelStationJsonVal['phone1'],
        phone2: fuelStationJsonVal['phone2'],
        region: fuelStationJsonVal['region'],
        state: fuelStationJsonVal['state'],
        zip: fuelStationJsonVal['zip']);
  }
}
