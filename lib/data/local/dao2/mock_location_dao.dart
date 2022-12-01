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

import 'dart:convert' as convert;
import 'package:pumped_end_device/data/local/dao2/secure_storage.dart';
import 'package:pumped_end_device/data/local/model/mock_location.dart';
import 'package:pumped_end_device/util/log_util.dart';

class MockLocationDao {
  static const _tag = 'MockLocationDao';
  static const _collectionMockLocation = 'ped_mock_location_collection';
  static const _collectionPinnedMockLocation = 'ped_pinned_mock_loc_collection';
  static const _pinnedMockLocationDocId = 'ped_pinned_mock_loc_doc_id';
  static final MockLocationDao instance = MockLocationDao._();

  MockLocationDao._();

  Future<void> insertMockLocation(final MockLocation mockLocation) async {
    final SecureStorage instance = SecureStorage.instance;
    instance.writeData(StorageItem(_collectionMockLocation, mockLocation.id, convert.jsonEncode(mockLocation)));
  }

  Future<void> insertPinnedMockLocation(final MockLocation mockLocation) async {
    final SecureStorage instance = SecureStorage.instance;
    instance.writeData(
        StorageItem(_collectionPinnedMockLocation, _pinnedMockLocationDocId, convert.jsonEncode(mockLocation)));
  }

  Future<dynamic> deleteMockLocation(final MockLocation mockLocation) async {
    final SecureStorage instance = SecureStorage.instance;
    final MockLocation? pinnedMockLocation = await getPinnedMockLocation();
    if (pinnedMockLocation == null || pinnedMockLocation.id != mockLocation.id) {
      LogUtil.debug(_tag, 'Deleting instance of mockLocation : ${mockLocation.id}');
      instance.deleteData(_collectionMockLocation, mockLocation.id);
      return true;
    } else {
      return false;
    }
  }

  Future<MockLocation?> getPinnedMockLocation() async {
    final SecureStorage instance = SecureStorage.instance;
    LogUtil.debug(_tag, 'getting the pinned mock location');
    final String? data = await instance.readData(_collectionPinnedMockLocation, _pinnedMockLocationDocId);
    if (data != null) {
      return MockLocation.fromJson(convert.jsonDecode(data));
    }
    return null;
  }

  Future<dynamic> deletePinnedMockLocation() async {
    final SecureStorage instance = SecureStorage.instance;
    LogUtil.debug(_tag, 'getting the pinned mock location');
    instance.deleteData(_collectionPinnedMockLocation, _pinnedMockLocationDocId);
  }

  Future<List<MockLocation>> getAllMockLocations() async {
    final List<MockLocation> mockLocations = [];
    final SecureStorage instance = SecureStorage.instance;
    final List<StorageItem> storageItems = await instance.readAllData(_collectionMockLocation);
    for (final StorageItem item in storageItems) {
      mockLocations.add(MockLocation.fromJson(convert.jsonDecode(item.getValue())));
    }
    return mockLocations;
  }
}
