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

enum SortOrder { cheapestClosest, closestCheapest }

extension QuoteSortOrder on SortOrder {
  static const _sortOrderName = {SortOrder.cheapestClosest: 'Cheapest Closest', SortOrder.closestCheapest: 'Closest Cheapest'};
  static const _sortOrderStr = {SortOrder.cheapestClosest: 'CHEAPEST_CLOSEST', SortOrder.closestCheapest: 'CLOSEST_CHEAPEST'};
  static const _sortOrderDesc = {SortOrder.cheapestClosest: 'Price Over Distance', SortOrder.closestCheapest: 'Distance Over Price'};

  String? get sortOrderName => _sortOrderName[this];
  String? get sortOrderStr => _sortOrderStr[this];
  String? get sortOrderDesc => _sortOrderDesc[this];

  static SortOrder? getSortOrder(String sortOrderStr) {
    switch (sortOrderStr) {
      case 'Cheapest Closest': { // This is temporary arrangement
        return SortOrder.cheapestClosest;
      }
      case 'CHEAPEST_CLOSEST': {
        return SortOrder.cheapestClosest;
      }
      case 'Closest Cheapest': {
        return SortOrder.closestCheapest;
      }
      case 'CLOSEST_CHEAPEST': {
        return SortOrder.closestCheapest;
      }
      default: {
        return null;
      }
    }
  }
}
