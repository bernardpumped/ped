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

class Places {
  static const darwinNt = Coordinate(-12.46335787603527, 130.84445893329737);
  static const aliceNt = Coordinate(-23.697520759443588, 133.88077494292193);

  static const cairnsQld = Coordinate(-16.920402103185594, 145.77076826785253);
  static const fishBurnerBrisbane = Coordinate(-27.3818631, 152.7130121);

  static const fishBurnerSydney = Coordinate(-33.865107, 151.205282);
  static const brooklynHillNsw = Coordinate(-31.946815023852825, 141.46797474949523);

  // fuel stations with no prices
  static const melbourneVic = Coordinate(-37.812436529595594, 144.9560425486392);

  static const adelaideSa = Coordinate(-34.924777309983035, 138.6003064030369);
  static const cooberPedySa = Coordinate(-29.01351446458888, 134.7544293679024);

  static const hobartTas = Coordinate(-42.88123764090286, 147.32583819502483);
  static const launcestonTas = Coordinate(-41.43906201750383, 147.13526185867693);

  static const marbleBarWa = Coordinate(-21.18006949126998, 119.93596748922121);
  static const perthWa = Coordinate(-31.9505, 115.8605);
}

class Coordinate {
  final double latitude;
  final double longitude;
  const Coordinate(this.latitude, this.longitude);
}