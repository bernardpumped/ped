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

import 'package:pumped_end_device/data/local/dao2/secure_storage.dart';
import 'package:pumped_end_device/data/local/model/favorite_fuel_station.dart';
import 'dart:convert' as convert;

import 'package:pumped_end_device/util/log_util.dart';

class FavoriteFuelStationsDao {
  static const _tag = 'FavoriteFuelStationsDao';
  static const _collectionFavoriteFuelStationsG = 'ped_favorite_stations-G';
  static const _collectionFavoriteFuelStationsF = 'ped_favorite_stations-F';

  static final FavoriteFuelStationsDao instance = FavoriteFuelStationsDao._();

  FavoriteFuelStationsDao._();

  Future<dynamic> insertFavoriteFuelStation(final FavoriteFuelStation favoriteFuelStation) async {
    final SecureStorage instance = SecureStorage.instance;
    instance.writeData(StorageItem(_getCollectionName(favoriteFuelStation.fuelStationSource),
        favoriteFuelStation.favoriteFuelStationId.toString(), convert.jsonEncode(favoriteFuelStation)));
  }

  Future<dynamic> deleteFavoriteFuelStation(final FavoriteFuelStation favoriteFuelStation) async {
    return _deleteFavoriteFuelStation(favoriteFuelStation.favoriteFuelStationId, favoriteFuelStation.fuelStationSource);
  }

  Future<int> dropFavoriteFuelStations() async {
    int deletedCount = 0;
    final SecureStorage instance = SecureStorage.instance;
    final List<FavoriteFuelStation> favoriteFuelStations = await getAllFavoriteFuelStations();
    for (FavoriteFuelStation ffs in favoriteFuelStations) {
      instance.deleteData(_getCollectionName(_getCollectionName(ffs.fuelStationSource)), ffs.favoriteFuelStationId.toString());
      deletedCount++;
    }
    return deletedCount;
  }

  Future<dynamic> _deleteFavoriteFuelStation(final int fuelStationId, final String fuelStationSource) async {
    final SecureStorage instance = SecureStorage.instance;
    instance.deleteData(_getCollectionName(fuelStationSource), fuelStationId.toString());
  }

  Future<bool> containsFavoriteFuelStation(final int fuelStationId, final String fuelStationSource) async {
    final SecureStorage instance = SecureStorage.instance;
    return instance.contains(_getCollectionName(fuelStationSource), fuelStationId.toString());
  }

  Future<List<FavoriteFuelStation>> getAllFavoriteFuelStations() async {
    final List<FavoriteFuelStation> favoriteFuelStations = [];
    final SecureStorage instance = SecureStorage.instance;
    final List<StorageItem> storageItemsG = await instance.readAllData(_collectionFavoriteFuelStationsG);
    for (final StorageItem item in storageItemsG) {
      LogUtil.debug(_tag, 'Fetched item.value : ${item.getValue()}');
      favoriteFuelStations.add(FavoriteFuelStation.fromJson(convert.jsonDecode(item.getValue())));
    }
    final List<StorageItem> storageItemsF = await instance.readAllData(_collectionFavoriteFuelStationsF);
    for (final StorageItem item in storageItemsF) {
      favoriteFuelStations.add(FavoriteFuelStation.fromJson(convert.jsonDecode(item.getValue())));
    }
    return favoriteFuelStations;
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
