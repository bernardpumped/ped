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
import 'package:pumped_end_device/models/pumped/fuel_quote.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_address.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_operating_hrs.dart';
import 'package:pumped_end_device/models/pumped/operating_hours.dart';
import 'package:pumped_end_device/models/status.dart';

class FuelStation {
  final int stationId;
  String fuelStationName;
  final FuelStationAddress fuelStationAddress;

  final bool managed;
  final double rating;
  final bool hasPromos;
  final bool hasServices;
  final String stationType;
  final List<String> imgUrls;

  Status status; //open / close
  OperatingHours operatingHours;

  final bool isFaStation;
  final String fuelAuthMatchStatus;

  Map<String, FuelQuote> fuelTypeFuelQuoteMap;

  final String merchant;
  final String merchantLogoUrl;

  final double distance;
  final String distanceUnit;

  // This field gets populated, when the application lands on the overview tab
  // in fuel station details screen page.
  FuelStationOperatingHrs fuelStationOperatingHrs;

  FuelStation(
      {@required this.stationId,
      @required this.fuelStationName,
      @required this.fuelStationAddress,
      this.status,
      this.distance,
      this.rating,
      this.merchantLogoUrl,
      this.managed,
      this.fuelTypeFuelQuoteMap,
      this.fuelAuthMatchStatus,
      this.isFaStation,
      this.hasPromos = false,
      this.hasServices = false,
      this.imgUrls,
      this.stationType,
      this.operatingHours,
      this.merchant,
      this.distanceUnit});

  Set<String> fuelQuoteSources() {
    if (fuelTypeFuelQuoteMap != null && fuelTypeFuelQuoteMap.length > 0) {
      return fuelTypeFuelQuoteMap.values.map((fq) => fq.fuelQuoteSourceName).where((source) => source != 'C').toSet();
    }
    return {};
  }

  List<FuelQuote> fuelQuotes() {
    if (fuelTypeFuelQuoteMap != null) {
      return fuelTypeFuelQuoteMap.values.toList();
    }
    return [];
  }

  String getFuelStationSource() {
    return isFaStation ? "F" : "G";
  }
}
