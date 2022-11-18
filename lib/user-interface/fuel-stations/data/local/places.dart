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
  static const darwinNt = AddressWithLatLng('Darwin', 'NT', 'AU', -12.46335787603527, 130.84445893329737);
  static const aliceNt = AddressWithLatLng('Alice', 'NT', 'AU', -23.697520759443588, 133.88077494292193);

  static const cairnsQld = AddressWithLatLng('Cairns', 'QLD', 'AU', -16.920402103185594, 145.77076826785253);
  static const fishBurnerBrisbane = AddressWithLatLng('Fish Burner, Brisbane', 'QLD', 'AU', -27.3818631, 152.7130121);

  static const fishBurnerSydney = AddressWithLatLng('Fish Burner, Sydney', 'NSW', 'AU', -33.865107, 151.205282);
  static const brokenHillNsw = AddressWithLatLng('Broken Hill', 'NSW', 'AU', -31.946815023852825, 141.46797474949523);

  // fuel stations with no prices
  static const melbourneVic = AddressWithLatLng('Melbourne', 'VIC', 'AU', -37.812436529595594, 144.9560425486392);

  static const adelaideSa = AddressWithLatLng('Adelaide', 'SA', 'AU', -34.924777309983035, 138.6003064030369);
  static const cooberPedySa = AddressWithLatLng('Coober Pedy', 'SA', 'AU', -29.01351446458888, 134.7544293679024);

  static const hobartTas = AddressWithLatLng('Hobart', 'TAS', 'AU', -42.88123764090286, 147.32583819502483);
  static const launcestonTas = AddressWithLatLng('Launceston', 'TAS', 'AU', -41.43906201750383, 147.13526185867693);

  static const marbleBarWa = AddressWithLatLng('Marble Bar', 'WA', 'AU', -21.18006949126998, 119.93596748922121);
  static const perthWa = AddressWithLatLng('Perth', 'WA', 'AU', -31.9505, 115.8605);

  static List<AddressWithLatLng> getPlaces() {
    return [
      darwinNt,
      aliceNt,
      cairnsQld,
      fishBurnerBrisbane,
      fishBurnerSydney,
      brokenHillNsw,
      melbourneVic,
      adelaideSa,
      cooberPedySa,
      hobartTas,
      launcestonTas,
      marbleBarWa,
      perthWa
    ];
  }
}

class AddressWithLatLng {
  final String addressLine;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  const AddressWithLatLng(this.addressLine, this.state, this.country, this.latitude, this.longitude);
}
