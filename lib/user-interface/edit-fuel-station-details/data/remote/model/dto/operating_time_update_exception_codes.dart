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

class OperatingTimeUpdateExceptionCodes {
  static const timeNotInRange = 'TIME_NOT_IN_RANGE';
  static const versionMismatch = 'VERSION_MIS_MATCH';
  static const timeNotChanged = 'TIME_NOT_CHANGED';
  static const invalidParamForOperatingTime = 'INVALID_PARAM_FOR_OPERATING_TIME';
  static const updatingOperatingTimeForMultipleFuelStations =
      'UPDATING_OPERATING_TIME_FOR_MULTIPLE_FUEL_STATIONS';
  static const noOperatingTimesProvided = 'NO_OPERATING_TIMES_PROVIDED';
  static const operatingTimeNotCrowdSourced = 'OPERATING_TIME_NOT_CROWD_SOURCED';
  static const operatingTimeFuelAuthoritySource = 'OPERATING_TIME_FUEL_AUTHORITY_SOURCE';
  static const operatingTimeGoogleSource = 'OPERATING_TIME_GOOGLE_SOURCE';
  static const operatingTimeMerchantSource = 'OPERATING_TIME_MERCHANT_SOURCE';
}
