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

import 'dart:convert';

class UpdateHistory {
  // Generally it is request-uuid
  final String updateHistoryId;
  // Which station the update was meant for
  final int fuelStationId;
  // Name of station for readability
  final String fuelStation;
  // Google Station or Fuel Authority Station
  final String fuelStationSource;
  // Time when data was updated on server.
  final int updateEpoch;
  // values in UpdateType enum, like PRICE / OPERATING-TIME etc.
  final String updateType;
  // like SUCCESS / FAILURE
  final String responseCode;
  // Values before the update
  final Map<String, dynamic> originalValues;
  // Values provided for update
  final Map<String, dynamic> updateValues;
  // Did it actually result into update
  final Map<String, dynamic> recordLevelExceptionCodes;
  // Any exception code at complete request level
  final List<dynamic> uberLevelExceptionCodes;
  // If any parameters were bad
  final Map<String, dynamic> invalidArguments;
  // Any generalized message sent back by server.
  final String responseDetails;

  Map<String, dynamic> toJson() => {
        'update_history_id': updateHistoryId,
        'fuel_station_id': fuelStationId,
        'fuel_station': fuelStation,
        'fuel_station_source': fuelStationSource,
        'update_epoch': updateEpoch,
        'update_type': updateType,
        'response_code': responseCode,
        'original_values': jsonEncode(originalValues),
        'update_values': jsonEncode(updateValues),
        'record_level_exception_codes': jsonEncode(recordLevelExceptionCodes),
        'uber_level_exception_codes': jsonEncode(uberLevelExceptionCodes),
        'invalid_arguments': jsonEncode(invalidArguments),
        'response_details': responseDetails
      };

  Map<String, dynamic> toMap() => toJson();

  factory UpdateHistory.fromMap(final Map<String, dynamic> data) => UpdateHistory.fromJson(data);

  factory UpdateHistory.fromJson(final Map<String, dynamic> data) {
    return UpdateHistory(
        updateHistoryId: data['update_history_id'],
        fuelStationId: data['fuel_station_id'],
        fuelStation: data['fuel_station'],
        fuelStationSource: data['fuel_station_source'],
        updateEpoch: data['update_epoch'],
        updateType: data['update_type'],
        responseCode: data['response_code'],
        originalValues: jsonDecode(data['original_values']),
        updateValues: jsonDecode(data['update_values']),
        recordLevelExceptionCodes: jsonDecode(data['record_level_exception_codes']),
        uberLevelExceptionCodes: jsonDecode(data['uber_level_exception_codes']),
        invalidArguments: jsonDecode(data['invalid_arguments']),
        responseDetails: data['response_details']);
  }

  UpdateHistory(
      {this.updateHistoryId,
      this.fuelStationId,
      this.fuelStation,
      this.fuelStationSource,
      this.updateEpoch,
      this.updateType,
      this.responseCode,
      this.originalValues,
      this.updateValues,
      this.recordLevelExceptionCodes,
      this.uberLevelExceptionCodes,
      this.invalidArguments,
      this.responseDetails});
}
