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
import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/mock_location.dart';
import 'package:pumped_end_device/util/log_util.dart';

class MockLocationDao {
  static const _tag = 'MockLocationDao';
  static const _collectionMockLocation = 'ped_mock_location_collection';
  static const _collectionPinnedMockLocation = 'ped_pinned_mock_loc_collection';
  static const _pinnedMockLocationDocId = 'ped_pinned_mock_loc_doc_id';

  static final MockLocationDao instance = MockLocationDao._();

  MockLocationDao._();

  Future<dynamic> insertMockLocation(final MockLocation mockLocation) async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'Inserting instance of mockLocation ${mockLocation.id}');
    db.collection(_collectionMockLocation).doc(mockLocation.id).set(mockLocation.toMap());
  }

  Future<dynamic> insertPinnedMockLocation(final MockLocation mockLocation) async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'Inserting instance of mockLocation ${mockLocation.id}');
    db.collection(_collectionPinnedMockLocation).doc(_pinnedMockLocationDocId).set(mockLocation.toMap());
  }

  Future<dynamic> deleteMockLocation(final MockLocation mockLocation) async {
    final db = Localstore.instance;
    final MockLocation? pinnedMockLocation = await getPinnedMockLocation();
    if (pinnedMockLocation == null || pinnedMockLocation.id != mockLocation.id) {
      LogUtil.debug(_tag, 'Deleting instance of mockLocation : ${mockLocation.id}');
      db.collection(_collectionMockLocation).doc(mockLocation.id).delete();
      return true;
    } else {
      return false;
    }
  }

  Future<MockLocation?> getPinnedMockLocation() async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'getting the pinned mock location');
    Map<String, dynamic>? record = await db.collection(_collectionPinnedMockLocation).doc(_pinnedMockLocationDocId).get();
    if (record != null) {
      LogUtil.debug(_tag, 'Retrieved pinned mock location');
      return MockLocation.fromJson(record);
    }
    return null;
  }

  Future<dynamic> deletePinnedMockLocation() async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'deleting pinned mock location');
    db.collection(_collectionPinnedMockLocation).doc(_pinnedMockLocationDocId).delete();
  }

  Future<List<MockLocation>> getAllMockLocations() async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'Reading all instances of mock location');
    final List<MockLocation> mockLocations = [];
    final Map<String, dynamic>? records = await db.collection(_collectionMockLocation).get();
    if (records != null && records.isNotEmpty) {
      LogUtil.debug(_tag, 'Number of Mock Location instances found : ${records.length}');
      for (var record in records.entries) {
        final Map<String, dynamic>? data = record.value;
        if (data != null) {
          mockLocations.add(MockLocation.fromJson(data));
        }
      }
    }
    return mockLocations;
  }
}
