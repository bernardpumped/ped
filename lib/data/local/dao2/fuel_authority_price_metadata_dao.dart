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

import 'dart:convert' as convert;
import 'package:pumped_end_device/data/local/dao2/secure_storage.dart';
import 'package:pumped_end_device/data/local/model/fuel_authority_price_metadata.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class FuelAuthorityPriceMetadataDao {
  static const _tag = 'FuelAuthorityPriceMetadataDao';

  static const _collectionFuelAuthorityFuelType = 'ped_fuel_authority_fuel_type';
  static const _collectionFuelAuthorityPriceMetadata = 'ped_fuel_authority_metadata';

  static final FuelAuthorityPriceMetadataDao instance = FuelAuthorityPriceMetadataDao._();

  FuelAuthorityPriceMetadataDao._();

  Future<dynamic> insertFuelAuthorityPriceMetadata(final FuelAuthorityPriceMetadata metaData) async {
    final SecureStorage db = SecureStorage.instance;
    final fapmId = const Uuid().v1();
    LogUtil.debug(_tag, 'Inserting metadata for fa - ${metaData.fuelAuthority} fuel-type ${metaData.fuelType} against id $fapmId');
    await db.writeData(StorageItem(_collectionFuelAuthorityPriceMetadata, fapmId, convert.jsonEncode(metaData)));
    final String? data = await db.readData(_collectionFuelAuthorityFuelType, metaData.fuelAuthority);
    final Map<String, dynamic> fuelTypeIds = data != null ? convert.jsonDecode(data) : {};
    LogUtil.debug(_tag, 'Found ${fuelTypeIds.length} existing Fuel-Type:Id mappings for ${metaData.fuelAuthority}');

    dynamic oldFapmId;
    if (fuelTypeIds.isEmpty) {
      LogUtil.debug(_tag,
          'Inserting only mapping {Fuel-Type:Id} mapping between ${metaData.fuelType} : $fapmId for ${metaData.fuelAuthority}');
      db.writeData(StorageItem(
          _collectionFuelAuthorityFuelType, metaData.fuelAuthority, convert.jsonEncode(fuelTypeIds)));
    } else {
      if (fuelTypeIds.containsKey(metaData.fuelType)) {
        oldFapmId = fuelTypeIds.remove(metaData.fuelType);
        LogUtil.debug(_tag, 'Removed old {${metaData.fuelType} : $oldFapmId} mapping');
      }
      fuelTypeIds.putIfAbsent(metaData.fuelType, () => fapmId);
      LogUtil.debug(_tag, 'Persisted new Id {${metaData.fuelType} : $fapmId} mapping');
      db.writeData(StorageItem(
          _collectionFuelAuthorityFuelType, metaData.fuelAuthority, convert.jsonEncode(fuelTypeIds)));
    }
    if (oldFapmId != null && oldFapmId != fapmId) {
      db.deleteData(_collectionFuelAuthorityPriceMetadata, oldFapmId);
      LogUtil.debug(_tag, 'Deleted old Id $oldFapmId data');
    }
  }

  Future<List<FuelAuthorityPriceMetadata>> getFuelAuthorityPriceMetadata(final String authorityId) async {
    final SecureStorage db = SecureStorage.instance;
    final String? data = await db.readData(_collectionFuelAuthorityFuelType, authorityId);
    final Map<String, dynamic>? fuelTypeIds = data != null ? convert.jsonDecode(data) : null;
    LogUtil.debug(
        _tag,
        'Found ${fuelTypeIds == null ? 0 : fuelTypeIds.length} '
        '{Fuel-Type : Id} mapping for $authorityId in $_collectionFuelAuthorityFuelType');
    if (fuelTypeIds == null || fuelTypeIds.isEmpty) {
      return [];
    } else {
      final List<FuelAuthorityPriceMetadata> metadata = [];
      for (var fuelTypeIdsEntry in fuelTypeIds.entries) {
        final String? data = await db.readData(_collectionFuelAuthorityPriceMetadata, fuelTypeIdsEntry.value);
        if (data != null) {
          final Map<String, dynamic>? metadataMap = convert.jsonDecode(data);
          if (metadataMap != null && metadataMap.isNotEmpty) {
            metadata.add(FuelAuthorityPriceMetadata.fromMap(metadataMap));
          }
        }
      }
      LogUtil.debug(_tag, 'Returning ${metadata.length} metadata for fuelAuthority : $authorityId');
      return metadata;
    }
  }

  Future<dynamic> deleteFuelAuthorityPriceMetadata(final FuelAuthorityPriceMetadata metadata) async {
    final SecureStorage db = SecureStorage.instance;
    final String? data = await db.readData(_collectionFuelAuthorityFuelType, metadata.fuelAuthority);
    final Map<String, dynamic>? fuelTypeIds = data != null ? convert.jsonDecode(data) : null;
    if (fuelTypeIds == null || fuelTypeIds.isEmpty) {
      LogUtil.debug(_tag, 'No FuelTypeIds for fuel-authority : ${metadata.fuelAuthority}');
    } else {
      final String? fapmId = fuelTypeIds[metadata.fuelType];
      if (fapmId == null) {
        LogUtil.debug(
            _tag, 'Meta-data for fuel-type ${metadata.fuelType} and authority ${metadata.fuelAuthority} is not stored');
      } else {
        fuelTypeIds.remove(metadata.fuelType);
        LogUtil.debug(
            _tag, 'Deleted Id : $fapmId] fuel-type : ${metadata.fuelType} mapping for ${metadata.fuelAuthority}');
        if (fuelTypeIds.isEmpty) {
          LogUtil.debug(_tag,
              'No more {FuelType : Id} mapping for ${metadata.fuelAuthority}. Deleting record from $_collectionFuelAuthorityFuelType');
          await db.deleteData(_collectionFuelAuthorityFuelType, metadata.fuelAuthority);
        } else {
          LogUtil.debug(_tag,
              'Persisting updated {FuelType : Id} mapping for ${metadata.fuelAuthority} in $_collectionFuelAuthorityFuelType');
          db.deleteData(_collectionFuelAuthorityFuelType, metadata.fuelAuthority);
        }
        LogUtil.debug(_tag, 'Deleting {Fuel-Type : Id} mapping for $fapmId');
        db.deleteData(_collectionFuelAuthorityPriceMetadata, fapmId);
      }
    }
  }
}
