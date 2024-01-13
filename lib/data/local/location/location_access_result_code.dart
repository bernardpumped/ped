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

enum LocationInitResultCode {
  locationServiceDisabled(value : 'Location Service Disabled'),
  permissionDenied(value: 'Location Permission Denied'),
  permissionDeniedForEver(value: 'Location Permission Denied Forever'),
  success(value: 'Location Found'),
  notFound(value: 'Location Not Found'),
  failure(value: 'Failure Detecting Location');

  const LocationInitResultCode({required this.value});

  final String value;
}
