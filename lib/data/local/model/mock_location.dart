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

class MockLocation {
  final String id;
  final String addressLine;
  final String city;
  final String state;
  final String country;
  final double latitude;
  final double longitude;

  MockLocation(
      {required this.id,
      required this.addressLine,
      required this.city,
      required this.state,
      required this.country,
      required this.latitude,
      required this.longitude});

  factory MockLocation.fromJson(final Map<String, dynamic> data) {
    return MockLocation(
        id: data['id'],
        addressLine: data['address_line'],
        city: data['city'],
        state: data['state'],
        country: data['country'],
        latitude: data['latitude'],
        longitude: data['longitude']);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'address_line': addressLine,
        'city': city,
        'state': state,
        'country': country,
        'latitude': latitude,
        'longitude': longitude
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'address_line': addressLine,
        'city': city,
        'state': state,
        'country': country,
        'latitude': latitude,
        'longitude': longitude
      };

  @override
  String toString() {
    return 'id: $id, addressLine: $addressLine, city: $city, '
        'state: $state, country: $country, latitude: $latitude, longitude: $longitude';
  }

  @override
  bool operator ==(Object other) =>
      other is MockLocation &&
      addressLine == other.addressLine &&
      city == other.city &&
      state == other.state &&
      country == other.country &&
      latitude == other.latitude &&
      longitude == other.longitude;

  int get hashCode => Object.hash(addressLine, city, state, country, latitude, longitude);

}
