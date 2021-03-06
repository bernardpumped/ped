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

import 'package:flutter_test/flutter_test.dart';
import 'package:pumped_end_device/data/local/location/geo_location_wrapper.dart';

void main() {
  // Other methods in geo_location_wrapper and just wrapper on
  test('Get the distance between latitude/longitude pair', (){
    // ignore: unnecessary_new
    final GeoLocationWrapper wrapper = new GeoLocationWrapper();
    expect(wrapper.distanceBetween(-33.86, 151.20, -31.94, 141.46), 934703.8606759851);
  });
}