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
 *     along with Pumped End Device If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';

class FavoriteFuelStationsDao {

  static const _COLLECTION_FAVORITE_FUEL_STATIONS_G = 'pumped_favorite_stations-G';
  static const _COLLECTION_FAVORITE_FUEL_STATIONS_F = 'pumped_favorite_stations-F';
  static const _FFS_ATTRIB_FUEL_STATION_ID = 'fuel_station_id';
  static const _FFS_ATTRIB_FUEL_STATION_SOURCE = 'fuel_station_source';

  static final FavoriteFuelStationsDao instance = FavoriteFuelStationsDao._();

  FavoriteFuelStationsDao._();

  Future<dynamic> insertFavoriteFuelStation(final FavoriteFuelStation favoriteFuelStation) async {
    final db = Localstore.instance;
    db.collection(_getCollectionName(favoriteFuelStation.fuelStationSource))
      .doc(favoriteFuelStation.favoriteFuelStationId.toString())
      .set({
        _FFS_ATTRIB_FUEL_STATION_ID : favoriteFuelStation.favoriteFuelStationId,
        _FFS_ATTRIB_FUEL_STATION_SOURCE : favoriteFuelStation.fuelStationSource
      });
  }

  Future<dynamic> deleteFavoriteFuelStation(final FavoriteFuelStation favoriteFuelStation) async {
    return _deleteFavoriteFuelStation(favoriteFuelStation.favoriteFuelStationId, favoriteFuelStation.fuelStationSource);
  }

  Future<dynamic> _deleteFavoriteFuelStation(final int fuelStationId, final String fuelStationSource) async {
    final db = Localstore.instance;
    return db.collection(_getCollectionName(fuelStationSource)).doc(fuelStationId.toString()).delete();
  }

  Future<bool> containsFavoriteFuelStation(final int fuelStationId, final String fuelStationSource) async {
   final db = Localstore.instance;
   var doc = await db.collection(_getCollectionName(fuelStationSource)).doc(fuelStationId.toString()).get();
   return doc != null;
  }

  Future<List<FavoriteFuelStation>> getAllFavoriteFuelStations() async {
    final db = Localstore.instance;
    final List<FavoriteFuelStation> favoriteFuelStations = [];
    var gItems = await db.collection(_COLLECTION_FAVORITE_FUEL_STATIONS_G).get();
    if (gItems != null) {
      for (var gItem in gItems.entries) {
        favoriteFuelStations.add(new FavoriteFuelStation(
            favoriteFuelStationId: gItem.value[_FFS_ATTRIB_FUEL_STATION_ID],
            fuelStationSource: gItem.value[_FFS_ATTRIB_FUEL_STATION_SOURCE]));
      }
    }
    var fItems = await db.collection(_COLLECTION_FAVORITE_FUEL_STATIONS_F).get();
    if (fItems != null) {
      for (var fItem in fItems.entries) {
        favoriteFuelStations.add(new FavoriteFuelStation(
            favoriteFuelStationId: fItem.value[_FFS_ATTRIB_FUEL_STATION_ID],
            fuelStationSource: fItem.value[_FFS_ATTRIB_FUEL_STATION_SOURCE]));
      }
    }
    return favoriteFuelStations;
  }

  Future<int> dropFavoriteFuelStations() async {
    final db = Localstore.instance;
    int deletedItems = 0;
    var gItems = await db.collection(_COLLECTION_FAVORITE_FUEL_STATIONS_G).get();
    if (gItems != null) {
      for (var gItem in gItems.entries) {
        var deleteResult = await _deleteFavoriteFuelStation(gItem.value[_FFS_ATTRIB_FUEL_STATION_ID], gItem.value[_FFS_ATTRIB_FUEL_STATION_SOURCE]);
        deletedItems += (deleteResult != null ? 1 : 0);
      }
    }

    var fItems = await db.collection(_COLLECTION_FAVORITE_FUEL_STATIONS_F).get();
    if (fItems != null) {
      for (var fItem in fItems.entries) {
        var deleteResult = await _deleteFavoriteFuelStation(fItem.value[_FFS_ATTRIB_FUEL_STATION_ID], fItem.value[_FFS_ATTRIB_FUEL_STATION_SOURCE]);
        deletedItems += (deleteResult != null ? 1 : 0);
      }
    }
    return deletedItems;
  }

  String _getCollectionName(final String fuelStationSource) {
    if (fuelStationSource == 'G') {
      return _COLLECTION_FAVORITE_FUEL_STATIONS_G;
    } else if (fuelStationSource == 'F') {
      return _COLLECTION_FAVORITE_FUEL_STATIONS_F;
    } else {
      throw Exception('Invalid fuelStationSource $fuelStationSource');
    }
  }
}