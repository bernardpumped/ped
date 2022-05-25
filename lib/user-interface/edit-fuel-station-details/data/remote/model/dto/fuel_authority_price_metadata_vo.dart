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

class FuelAuthorityPriceMetadataVo {
  final double minPrice;
  final double maxPrice;
  final double minTolerancePercent;
  final double maxTolerancePercent;
  final String fuelMeasure;
  final String fuelType;
  final String fuelAuthority;
  DecimalPositionVo? decimalPositionVo;

  FuelAuthorityPriceMetadataVo(this.minPrice, this.maxPrice, this.minTolerancePercent, this.maxTolerancePercent,
      this.fuelMeasure, this.fuelType, this.fuelAuthority);
}

class DecimalPositionVo {
  final int decPosForAllowedMaxForChar;
  final int allowedMaxFirstChar;
  final int alternatePos;

  DecimalPositionVo(this.decPosForAllowedMaxForChar, this.allowedMaxFirstChar, this.alternatePos);
}
