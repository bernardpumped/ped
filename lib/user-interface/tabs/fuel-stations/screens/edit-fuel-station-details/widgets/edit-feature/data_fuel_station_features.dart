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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_feature.dart';

class DataFuelStationFeatures {
  static const _black54Size30_evIcon = Icon(IconData(0xe56d, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_hotelIcon = Icon(IconData(0xe53a, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localAtm = Icon(IconData(0xe53e, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localCafe = Icon(IconData(0xe541, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localCarWash = Icon(IconData(0xe542, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localConvStore = Icon(IconData(0xe543, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localDining = Icon(IconData(0xe556, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localGrocery = Icon(IconData(0xe547, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localHotel = Icon(IconData(0xe549, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localLaundryServ = Icon(IconData(0xe54a, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localMall = Icon(IconData(0xe54c, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localPharmacy = Icon(IconData(0xe550, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localPostOffice = Icon(IconData(0xe554, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30_localPizza = Icon(IconData(0xe552, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);

  static final List<FuelStationFeature> fuelStationFeatures = [
    FuelStationFeature(
        featureType: 'ev_station',
        featureName: 'EV Station',
        iconType: 'MaterialIcon',
        icon: _black54Size30_evIcon,
        selected: true),
    FuelStationFeature(
        featureType: 'hotel',
        featureName: 'Guest Room',
        iconType: 'MaterialIcon',
        icon: _black54Size30_hotelIcon,
        selected: false),
    FuelStationFeature(
        featureType: 'local_atm',
        featureName: 'ATM',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localAtm,
        selected: true),
    FuelStationFeature(
        featureType: 'local_cafe',
        featureName: 'Cafe',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localCafe,
        selected: false),
    FuelStationFeature(
        featureType: 'local_car_wash',
        featureName: 'Car Wash',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localCarWash,
        selected: true),
    FuelStationFeature(
        featureType: 'local_convenience_store',
        featureName: 'Convenience Store',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localConvStore,
        selected: false),
    FuelStationFeature(
        featureType: 'local_dining',
        featureName: 'Dining',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localDining,
        selected: true),
    FuelStationFeature(
        featureType: 'local_grocery_store',
        featureName: 'Grocery',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localGrocery,
        selected: false),
    FuelStationFeature(
        featureType: 'local_hotel',
        featureName: 'Dining',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localHotel,
        selected: true),
    FuelStationFeature(
        featureType: 'local_laundry_service',
        featureName: 'Laundry Service',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localLaundryServ,
        selected: false),
    FuelStationFeature(
        featureType: 'local_mall',
        featureName: 'Mall',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localMall,
        selected: true),
    FuelStationFeature(
        featureType: 'local_pharmacy',
        featureName: 'Pharmacy',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localPharmacy,
        selected: false),
    FuelStationFeature(
        featureType: 'local_post_office',
        featureName: 'Post Office',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localPostOffice,
        selected: true),
    FuelStationFeature(
        featureType: 'local_pizza',
        featureName: 'Pizza',
        iconType: 'MaterialIcon',
        icon: _black54Size30_localPizza,
        selected: false),
  ];
}
