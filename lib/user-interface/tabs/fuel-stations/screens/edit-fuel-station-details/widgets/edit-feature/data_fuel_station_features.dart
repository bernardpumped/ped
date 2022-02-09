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

import 'package:flutter/material.dart';
import 'package:pumped_end_device/models/pumped/fuel_station_feature.dart';

class DataFuelStationFeatures {
  static const _black54Size30EvIcon = Icon(IconData(0xe56d, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30HotelIcon = Icon(IconData(0xe53a, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalAtm = Icon(IconData(0xe53e, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalCafe = Icon(IconData(0xe541, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalCarWash = Icon(IconData(0xe542, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalConvStore = Icon(IconData(0xe543, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalDining = Icon(IconData(0xe556, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalGrocery = Icon(IconData(0xe547, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalHotel = Icon(IconData(0xe549, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalLaundryServ = Icon(IconData(0xe54a, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalMall = Icon(IconData(0xe54c, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalPharmacy = Icon(IconData(0xe550, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalPostOffice = Icon(IconData(0xe554, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);
  static const _black54Size30LocalPizza = Icon(IconData(0xe552, fontFamily: 'MaterialIcons', matchTextDirection: true), color: Colors.black54, size: 30);

  static final List<FuelStationFeature> fuelStationFeatures = [
    FuelStationFeature(
        featureType: 'ev_station',
        featureName: 'EV Station',
        iconType: 'MaterialIcon',
        icon: _black54Size30EvIcon,
        selected: true),
    FuelStationFeature(
        featureType: 'hotel',
        featureName: 'Guest Room',
        iconType: 'MaterialIcon',
        icon: _black54Size30HotelIcon,
        selected: false),
    FuelStationFeature(
        featureType: 'local_atm',
        featureName: 'ATM',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalAtm,
        selected: true),
    FuelStationFeature(
        featureType: 'local_cafe',
        featureName: 'Cafe',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalCafe,
        selected: false),
    FuelStationFeature(
        featureType: 'local_car_wash',
        featureName: 'Car Wash',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalCarWash,
        selected: true),
    FuelStationFeature(
        featureType: 'local_convenience_store',
        featureName: 'Convenience Store',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalConvStore,
        selected: false),
    FuelStationFeature(
        featureType: 'local_dining',
        featureName: 'Dining',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalDining,
        selected: true),
    FuelStationFeature(
        featureType: 'local_grocery_store',
        featureName: 'Grocery',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalGrocery,
        selected: false),
    FuelStationFeature(
        featureType: 'local_hotel',
        featureName: 'Dining',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalHotel,
        selected: true),
    FuelStationFeature(
        featureType: 'local_laundry_service',
        featureName: 'Laundry Service',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalLaundryServ,
        selected: false),
    FuelStationFeature(
        featureType: 'local_mall',
        featureName: 'Mall',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalMall,
        selected: true),
    FuelStationFeature(
        featureType: 'local_pharmacy',
        featureName: 'Pharmacy',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalPharmacy,
        selected: false),
    FuelStationFeature(
        featureType: 'local_post_office',
        featureName: 'Post Office',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalPostOffice,
        selected: true),
    FuelStationFeature(
        featureType: 'local_pizza',
        featureName: 'Pizza',
        iconType: 'MaterialIcon',
        icon: _black54Size30LocalPizza,
        selected: false),
  ];
}
