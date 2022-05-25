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
  static final List<FuelStationFeature> fuelStationFeatures = [
    FuelStationFeature(
        featureType: 'ev_station', featureName: 'EV Station', icon: Icons.ev_station_outlined, selected: true),
    FuelStationFeature(
        featureType: 'hotel', featureName: 'Guest Room', icon: Icons.local_hotel_outlined, selected: false),
    FuelStationFeature(featureType: 'local_atm', featureName: 'ATM', icon: Icons.atm_outlined, selected: true),
    FuelStationFeature(
        featureType: 'local_cafe', featureName: 'Cafe', icon: Icons.local_cafe_outlined, selected: false),
    FuelStationFeature(
        featureType: 'local_car_wash', featureName: 'Car Wash', icon: Icons.local_car_wash_outlined, selected: true),
    FuelStationFeature(
        featureType: 'local_convenience_store',
        featureName: 'Convenience Store',
        icon: Icons.local_convenience_store_outlined,
        selected: false),
    FuelStationFeature(
        featureType: 'local_dining', featureName: 'Dining', icon: Icons.local_dining_outlined, selected: true),
    FuelStationFeature(
        featureType: 'local_grocery_store',
        featureName: 'Grocery',
        icon: Icons.local_grocery_store_outlined,
        selected: false),
    FuelStationFeature(
        featureType: 'local_hotel', featureName: 'Dining', icon: Icons.local_hotel_outlined, selected: true),
    FuelStationFeature(
        featureType: 'local_laundry_service',
        featureName: 'Laundry Service',
        icon: Icons.local_laundry_service_outlined,
        selected: false),
    FuelStationFeature(featureType: 'local_mall', featureName: 'Mall', icon: Icons.local_mall_outlined, selected: true),
    FuelStationFeature(
        featureType: 'local_pharmacy', featureName: 'Pharmacy', icon: Icons.local_pharmacy_outlined, selected: false),
    FuelStationFeature(
        featureType: 'local_post_office',
        featureName: 'Post Office',
        icon: Icons.local_post_office_outlined,
        selected: true),
    FuelStationFeature(
        featureType: 'local_pizza', featureName: 'Pizza', icon: Icons.local_pizza_outlined, selected: false)
  ];
}
