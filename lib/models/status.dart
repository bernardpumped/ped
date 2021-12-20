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

enum Status { open, closed, opening_soon, closing_soon, unknown, open24Hrs }

extension FuelStationStatus on Status {
  static const _statusName = {
    Status.open: 'Open',
    Status.closed: 'Closed',
    Status.opening_soon: 'Opening Soon',
    Status.closing_soon: 'Closing Soon',
    Status.open24Hrs: 'Open 24 Hrs',
    Status.unknown: 'unknown'
  };

  static const _statusStr = {
    Status.open: 'OPEN',
    Status.closed: 'CLOSED',
    Status.opening_soon: 'OPENING_SOON',
    Status.closing_soon: 'CLOSING_SOON',
    Status.open24Hrs: 'OPEN_24_HRS',
    Status.unknown: 'UNKNOWN'
  };

  String get statusName => _statusName[this];
  String get statusStr => _statusStr[this];

  static Status getStatus(final String statusStr) {
    switch(statusStr) {
      case 'OPEN': return Status.open;
      case 'CLOSED': return Status.closed;
      case 'OPENING_SOON': return Status.opening_soon;
      case 'CLOSING_SOON': return Status.closing_soon;
      case 'OPEN_24_HRS': return Status.open24Hrs;
      case 'UNKNOWN': return Status.unknown;
      default: return Status.unknown;
    }
  }
}
