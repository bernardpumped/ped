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

class FuelStationAddress {
  String contactName;
  String addressLine1;
  String phone1;
  String phone2;
  final String fax;
  final String email;
  final double latitude;
  final double longitude;
  String region;
  String locality;
  String state;
  String zip;
  final String countryName;
  final String id;

  FuelStationAddress({
    this.id,
    this.contactName,
    @required this.addressLine1,
    this.phone1,
    this.phone2,
    this.fax,
    this.email,
    @required this.latitude,
    @required this.longitude,
    this.region,
    this.locality,
    this.state,
    this.zip,
    this.countryName,
  });
}
