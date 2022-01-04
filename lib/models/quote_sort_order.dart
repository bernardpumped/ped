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

enum SortOrder { CHEAPEST_CLOSEST, CLOSEST_CHEAPEST }

extension QuoteSortOrder on SortOrder {
  static const _sortOrderName = {SortOrder.CHEAPEST_CLOSEST: 'Cheapest Closest', SortOrder.CLOSEST_CHEAPEST: 'Closest Cheapest'};
  static const _sortOrderStr = {SortOrder.CHEAPEST_CLOSEST: 'CHEAPEST_CLOSEST', SortOrder.CLOSEST_CHEAPEST: 'CLOSEST_CHEAPEST'};

  String get sortOrderName => _sortOrderName[this];
  String get sortOrderStr => _sortOrderStr[this];

  static SortOrder getSortOrder(String sortOrderStr) {
    switch (sortOrderStr) {
      case 'CHEAPEST_CLOSEST': {
        return SortOrder.CHEAPEST_CLOSEST;
      }
      case 'CLOSEST_CHEAPEST': {
        return SortOrder.CLOSEST_CHEAPEST;
      }
      default: {
        return null;
      }
    }
  }
}
