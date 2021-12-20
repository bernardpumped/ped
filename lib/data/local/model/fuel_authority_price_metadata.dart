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

import 'package:flutter/cupertino.dart';

class FuelAuthorityPriceMetadata {
  @required
  final double minPrice;
  @required
  final double maxPrice;
  @required
  final double minTolerancePercent;
  @required
  final double maxTolerancePercent;
  @required
  final String fuelMeasure;
  @required
  final String fuelType;
  @required
  final String fuelAuthority;
  final String marketRegionZoneConfigVersion;
  // Temporarily adding decimalPositionVo
  // will move the logic from backend to device.
  final int decPosForAllowedMaxForChar;
  final int allowedMaxFirstChar;
  final int alternatePos;

  FuelAuthorityPriceMetadata(
      {this.minPrice,
      this.maxPrice,
      this.minTolerancePercent,
      this.maxTolerancePercent,
      this.fuelMeasure,
      this.fuelType,
      this.fuelAuthority,
      this.marketRegionZoneConfigVersion,
      this.decPosForAllowedMaxForChar,
      this.allowedMaxFirstChar,
      this.alternatePos});

  Map<String, dynamic> toMap() => {
        'min_price': minPrice,
        'max_price': maxPrice,
        'min_tolerance_percent': minTolerancePercent,
        'max_tolerance_percent': maxTolerancePercent,
        'fuel_measure': fuelMeasure,
        'fuel_type': fuelType,
        'fuel_authority': fuelAuthority,
        'market_region_zone_config_version': marketRegionZoneConfigVersion,
        'dec_pos_for_allowed_max_for_char': decPosForAllowedMaxForChar,
        'allowed_max_first_char': allowedMaxFirstChar,
        'alternate_pos': alternatePos
      };

  factory FuelAuthorityPriceMetadata.fromMap(final Map<String, dynamic> data) => new FuelAuthorityPriceMetadata(
      fuelAuthority: data['fuel_authority'],
      fuelType: data['fuel_type'],
      fuelMeasure: data['fuel_measure'],
      minPrice: data['min_price'],
      maxPrice: data['max_price'],
      minTolerancePercent: data['min_tolerance_percent'],
      maxTolerancePercent: data['max_tolerance_percent'],
      marketRegionZoneConfigVersion: data['market_region_zone_config_version'],
      decPosForAllowedMaxForChar: data['dec_pos_for_allowed_max_for_char'],
      allowedMaxFirstChar: data['allowed_max_first_char'],
      alternatePos: data['alternate_pos']);

  Map<String, dynamic> toJson() => {
        'min_price': minPrice,
        'max_price': maxPrice,
        'min_tolerance_percent': minTolerancePercent,
        'max_tolerance_percent': maxTolerancePercent,
        'fuel_measure': fuelMeasure,
        'fuel_type': fuelType,
        'fuel_authority': fuelAuthority,
        'market_region_zone_config_version': marketRegionZoneConfigVersion,
        'dec_pos_for_allowed_max_for_char': decPosForAllowedMaxForChar,
        'allowed_max_first_char': allowedMaxFirstChar,
        'alternate_pos': alternatePos
      };
}
