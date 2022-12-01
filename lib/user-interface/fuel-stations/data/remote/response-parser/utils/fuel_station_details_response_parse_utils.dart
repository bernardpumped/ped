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

import 'package:flutter/foundation.dart';
import 'package:pumped_end_device/main.dart';
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/user-interface/fuel-station-details/data/remote/response-parser/operating_hours_response_parse_utils.dart';
import 'package:pumped_end_device/util/log_util.dart';

class FuelStationDetailsResponseParseUtils {
  static const _tag = 'FuelStationDetailsResponseParseUtils';
  static Map<String, FuelStation> getStationIdStationMap(final Map<String, dynamic> responseJson,
      final Map<String, List<FuelQuote>> stationIdFuelQuotes, final bool enrichOffers) {
    final Map<String, dynamic> stationIdStationJsonMap = responseJson['fuelStations'];
    final Map<String, FuelStation> stationIdStationMap = {};
    for (final MapEntry<String, dynamic> me in stationIdStationJsonMap.entries) {
      final String stationIdStr = me.key;
      final Map<String, dynamic> fuelStationJsonVal = me.value;
      final List<FuelQuote>? fuelQuotes = stationIdFuelQuotes[stationIdStr];
      final bool holidayToday = fuelStationJsonVal['holidayToday'];
      final OperatingHours? operatingHours =
          OperatingHoursResponseParseUtils.getOperatingHours(fuelStationJsonVal['fuelFillOperatingTime'], holidayToday);
      final Map<String, FuelQuote> fuelTypeQuoteMap = {};
      if (fuelQuotes != null) {
        for (var fuelQuote in fuelQuotes) {
          fuelTypeQuoteMap.putIfAbsent(fuelQuote.fuelType, () => fuelQuote);
        }
      }
      final FuelStation fuelStation = FuelStation(
        stationId: fuelStationJsonVal['fuelStationId'],
        fuelStationAddress: _getFuelStationAddress(fuelStationJsonVal, fuelStationJsonVal['stationName']),
        fuelStationName: fuelStationJsonVal['stationName'],
        distance: fuelStationJsonVal['distance'],
        distanceUnit: fuelStationJsonVal['distanceUnit'],
        managed: fuelStationJsonVal['managed'],
        fuelAuthMatchStatus: fuelStationJsonVal['matchStatus'],
        fuelAuthorityStationCode: fuelStationJsonVal['fuelAuthorityStationCode'],
        merchant: fuelStationJsonVal['merchant'],
        merchantLogoUrl: fuelStationJsonVal['merchantLogoUrl'],
        rating: fuelStationJsonVal['rating'],
        stationType: fuelStationJsonVal['stationType'],
        fuelTypeFuelQuoteMap: fuelTypeQuoteMap,
        imgUrls: null, //TODO
        isFaStation: fuelStationJsonVal['faStation'],
        status: OperatingHoursResponseParseUtils.getStatus(operatingHours, holidayToday: holidayToday),
        operatingHours: operatingHours,
      );
      stationIdStationMap.putIfAbsent(stationIdStr, () => fuelStation);
    }
    if (enrichOffers) {
      LogUtil.debug(
          _tag,
          'Would attempt to enrich offers, as [kReleaseMode=$kReleaseMode] '
          'and [enrichOffers=$enrichOffers]');
      _enrichOffers(stationIdStationMap);
    }
    return stationIdStationMap;
  }

  static _enrichOffers(final Map<String, FuelStation> stationIdStationMap) {
    //Check if none of the fuel-stations contain offers
    for (var station in stationIdStationMap.values) {
      if (station.offers > 0 || station.services > 0) {
        LogUtil.debug(_tag, 'Fuel station already has offers, not enriching');
        return;
      }
    }
    LogUtil.debug(_tag, 'None of the existing fuel-stations has offers / services. So enriching');
    LogUtil.debug(
        _tag, 'Enrichment will happen only for stations which have no offers and no services but have fuel-quotes');
    int max = 10;
    var random = Random();
    for (var station in stationIdStationMap.values) {
      if (station.offers == 0 && station.services == 0 && station.hasFuelPrices()) {
        station.setOffers = random.nextInt(max) - 1;
        station.setServices = random.nextInt(max) - 1;
      }
    }
  }

  static Map<String, List<FuelQuote>> getStationIdFuelQuotesMap(
      final Map<String, dynamic> responseJson, final String? fuelAuthorityId) {
    final Map<String, dynamic> stationIdQuoteJsonMap = responseJson['stationFuelQuoteMap'];
    final Map<String, List<FuelQuote>> stationIdFuelQuotes = {};

    for (final MapEntry<String, dynamic> me in stationIdQuoteJsonMap.entries) {
      final String stationId = me.key;
      final List<dynamic> fuelQuotesJsonVal = me.value;
      final List<FuelQuote> fuelQuotes = [];
      for (var jsonVal in fuelQuotesJsonVal) {
        final String? fuelQuoteSource = jsonVal['fuelQuoteSource'];
        String? fuelQuoteSourceName = (fuelQuoteSource == 'C') ? "Crowd" : fuelAuthorityId;
        int? publishDate = jsonVal['publishDate'];
        if (publishDate != null && publishDate > 1700000000) {
          //Ths is interim, till the Pumped fix is not pushed back.
          publishDate = jsonVal['publishDate'] ~/ 1000;
        }
        final FuelQuote fuelQuote = FuelQuote(
            fuelType: jsonVal['fuelType'],
            fuelMeasure: jsonVal['fuelMeasure'],
            fuelStationId: jsonVal['fuelStationId'],
            publishDate: publishDate,
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

  static FuelStationAddress _getFuelStationAddress(final Map<String, dynamic> fuelStationJsonVal, String? stationName) {
    return FuelStationAddress(
        addressLine1: fuelStationJsonVal['addressLine'],
        latitude: fuelStationJsonVal['latitude'],
        longitude: fuelStationJsonVal['longitude'],
        contactName: stationName ?? fuelStationJsonVal['contactName'],
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
