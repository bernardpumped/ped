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

class Places {
  static const DARWIN_NT = Coordinate(-12.46335787603527, 130.84445893329737);
  static const ALICE_NT = Coordinate(-23.697520759443588, 133.88077494292193);

  static const CAIRNS_QLD = Coordinate(-16.920402103185594, 145.77076826785253);
  static const FISHBURNER_BRISBANE = Coordinate(-27.3818631, 152.7130121);

  static const FISHBURNER_SYDNEY = Coordinate(-33.865107, 151.205282);
  static const BROKEN_HILL_NSW = Coordinate(-31.946815023852825, 141.46797474949523);

  // fuel stations with no prices
  static const MELBOURNE_VIC = Coordinate(-37.812436529595594, 144.9560425486392);

  static const ADELAIDE_SA = Coordinate(-34.924777309983035, 138.6003064030369);
  static const COOBER_PEDY_SA = Coordinate(-29.01351446458888, 134.7544293679024);

  static const HOBART_TAS = Coordinate(-42.88123764090286, 147.32583819502483);
  static const LAUNCESTON_TAS = Coordinate(-41.43906201750383, 147.13526185867693);

  static const MARBLE_BAR_WA = Coordinate(-21.18006949126998, 119.93596748922121);
  static const PERTH_WA = Coordinate(-31.9505, 115.8605);
}

class Coordinate {
  final double latitude;
  final double longitude;
  const Coordinate(this.latitude, this.longitude);
}