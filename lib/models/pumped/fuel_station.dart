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
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';

class FuelStation {
  final int stationId;
  String fuelStationName;
  final FuelStationAddress fuelStationAddress;

  final bool? managed;
  final double? rating;
  // final bool hasPromos;
  int promos = 0;
  // final bool hasServices;
  int services = 0;
  final String? stationType;
  final List<String>? imgUrls;

  Status? status; //open / close
  OperatingHours? operatingHours;

  final bool isFaStation;
  final String? fuelAuthMatchStatus;
  final String? fuelAuthorityStationCode;

  Map<String, FuelQuote> fuelTypeFuelQuoteMap;

  final String? merchant;
  final String merchantLogoUrl;

  final double distance;
  final String distanceUnit;

  // This field gets populated, when the application lands on the overview tab
  // in fuel station details screen page.
  FuelStationOperatingHrs? fuelStationOperatingHrs;

  FuelStation(
      {required this.stationId,
      required this.fuelStationName,
      required this.fuelStationAddress,
      this.status,
      required this.distance,
      this.rating,
      required this.merchantLogoUrl,
      this.managed,
      required this.fuelTypeFuelQuoteMap,
      this.fuelAuthMatchStatus,
      this.fuelAuthorityStationCode,
      required this.isFaStation,
      this.imgUrls,
      this.stationType,
      this.operatingHours,
      required this.merchant,
      required this.distanceUnit});

  Set<String?> fuelQuoteSources() {
    if (fuelTypeFuelQuoteMap.isNotEmpty) {
      return fuelTypeFuelQuoteMap.values.map((fq) => fq.fuelQuoteSourceName).where((source) => source != 'C').toSet();
    }
    return {};
  }

  List<FuelQuote> fuelQuotes() {
    return fuelTypeFuelQuoteMap.values.toList();
  }

  String getFuelStationSource() {
    return isFaStation ? "F" : "G";
  }

  bool hasFuelPrices() {
    if (fuelTypeFuelQuoteMap.isEmpty) {
      return false;
    }
    bool pricePresent = false;
    for (var fq in fuelTypeFuelQuoteMap.values) {
      pricePresent = pricePresent || fq.quoteValue != null && fq.quoteValue! > 0;
      if (pricePresent) {
        break;
      }
    }
    return pricePresent;
  }

  set setPromos(int promos){
    this.promos = promos;
  }

  set setServices(int services){
    this.services = services;
  }

  List<String?> getPublishers() {
    return fuelQuotes()
        .where((fq) => fq.fuelQuoteSource != null && fq.fuelQuoteSource != 'C')
        .map((fq) => fq.fuelQuoteSourceName)
        .toList();
  }
}
