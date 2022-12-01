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
 *     along with Pumped End Device If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';

class FavoriteFuelStationsDao {

  static const _collectionFavoriteFuelStationsG = 'ped_favorite_stations-G';
  static const _collectionFavoriteFuelStationsF = 'ped_favorite_stations-F';
  static const _ffsAttribFuelStationId = 'fuel_station_id';
  static const _ffsAttribFuelStationSource = 'fuel_station_source';

  static final FavoriteFuelStationsDao instance = FavoriteFuelStationsDao._();

  FavoriteFuelStationsDao._();

  Future<dynamic> insertFavoriteFuelStation(final FavoriteFuelStation favoriteFuelStation) async {
    final db = Localstore.instance;
    db.collection(_getCollectionName(favoriteFuelStation.fuelStationSource))
      .doc(favoriteFuelStation.favoriteFuelStationId.toString())
      .set({
        _ffsAttribFuelStationId : favoriteFuelStation.favoriteFuelStationId,
        _ffsAttribFuelStationSource : favoriteFuelStation.fuelStationSource
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
    var gItems = await db.collection(_collectionFavoriteFuelStationsG).get();
    if (gItems != null) {
      for (var gItem in gItems.entries) {
        favoriteFuelStations.add(FavoriteFuelStation(
            favoriteFuelStationId: gItem.value[_ffsAttribFuelStationId],
            fuelStationSource: gItem.value[_ffsAttribFuelStationSource]));
      }
    }
    var fItems = await db.collection(_collectionFavoriteFuelStationsF).get();
    if (fItems != null) {
      for (var fItem in fItems.entries) {
        favoriteFuelStations.add(FavoriteFuelStation(
            favoriteFuelStationId: fItem.value[_ffsAttribFuelStationId],
            fuelStationSource: fItem.value[_ffsAttribFuelStationSource]));
      }
    }
    return favoriteFuelStations;
  }

  Future<int> dropFavoriteFuelStations() async {
    final db = Localstore.instance;
    int deletedItems = 0;
    var gItems = await db.collection(_collectionFavoriteFuelStationsG).get();
    if (gItems != null) {
      for (var gItem in gItems.entries) {
        var deleteResult = await _deleteFavoriteFuelStation(gItem.value[_ffsAttribFuelStationId], gItem.value[_ffsAttribFuelStationSource]);
        deletedItems += (deleteResult != null ? 1 : 0);
      }
    }

    var fItems = await db.collection(_collectionFavoriteFuelStationsF).get();
    if (fItems != null) {
      for (var fItem in fItems.entries) {
        var deleteResult = await _deleteFavoriteFuelStation(fItem.value[_ffsAttribFuelStationId], fItem.value[_ffsAttribFuelStationSource]);
        deletedItems += (deleteResult != null ? 1 : 0);
      }
    }
    return deletedItems;
  }

  String _getCollectionName(final String fuelStationSource) {
    if (fuelStationSource == 'G') {
      return _collectionFavoriteFuelStationsG;
    } else if (fuelStationSource == 'F') {
      return _collectionFavoriteFuelStationsF;
    } else {
      throw Exception('Invalid fuelStationSource $fuelStationSource');
    }
  }
}