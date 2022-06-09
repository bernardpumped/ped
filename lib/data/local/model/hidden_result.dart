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

class HiddenResult {
  final int hiddenStationId;
  final String hiddenStationSource;

  HiddenResult({required this.hiddenStationId, required this.hiddenStationSource});

  factory HiddenResult.fromJson(final Map<String, dynamic> data) {
    return HiddenResult(
        hiddenStationId: data['hidden_station_id'], hiddenStationSource: data['hidden_station_source']);
  }

  Map<String, dynamic> toMap() => {'hidden_station_id': hiddenStationId, 'hidden_station_source': hiddenStationSource};

  Map<String, dynamic> toJson() => {'hidden_station_id': hiddenStationId, 'hidden_station_source': hiddenStationSource};
}
