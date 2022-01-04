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
 *     along with Pumped End Device  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/fuel_authority_price_metadata.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:uuid/uuid.dart';

class FuelAuthorityPriceMetadataDao {
  static const _TAG = 'FuelAuthorityPriceMetadataDao';
  static const _uuid = Uuid();

  static const _COLLECTION_FUEL_AUTHORITY_FUEL_TYPE = 'pumped_fuel_authority_fuel_type';
  static const _COLLECTION_FUEL_AUTHORITY_PRICE_METADATA = 'pumped_fuel_authority_metadata';

  static final FuelAuthorityPriceMetadataDao instance = FuelAuthorityPriceMetadataDao._();

  FuelAuthorityPriceMetadataDao._();

  Future<dynamic> insertFuelAuthorityPriceMetadata(final FuelAuthorityPriceMetadata metaData) async {
    final db = Localstore.instance;
    final fapmId = _uuid.v1();

    LogUtil.debug(_TAG, 'Inserting metadata for fa - ${metaData.fuelAuthority} fuel-type ${metaData.fuelType} against id $fapmId');
    db.collection(_COLLECTION_FUEL_AUTHORITY_PRICE_METADATA).doc(fapmId).set(metaData.toMap());

    final Map<String, dynamic> fuelTypeIds = await db.collection(_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE).doc(metaData.fuelAuthority).get();
    LogUtil.debug(_TAG, 'Found ${fuelTypeIds == null ? 0 : fuelTypeIds.length} existing Fuel-Type:Id mappings for ${metaData.fuelAuthority}');

    var oldFapmId = null;

    if (fuelTypeIds == null || fuelTypeIds.length == 0) {
      LogUtil.debug(_TAG, 'Inserted only mapping {Fuel-Type:Id} mapping between ${metaData.fuelType} : $fapmId for ${metaData.fuelAuthority}');
      db.collection(_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE).doc(metaData.fuelAuthority).set({metaData.fuelType : fapmId});
    } else {
      if (fuelTypeIds.containsKey(metaData.fuelType)) {
        oldFapmId = fuelTypeIds.remove(metaData.fuelType);
        LogUtil.debug(_TAG, 'Removed old {${metaData.fuelType} : $oldFapmId} mapping');
      }
      fuelTypeIds.putIfAbsent(metaData.fuelType, () => fapmId);
      LogUtil.debug(_TAG, 'Persisted new Id {${metaData.fuelType} : $fapmId} mapping');
    }
    if (oldFapmId != fapmId) {
      db.collection(_COLLECTION_FUEL_AUTHORITY_PRICE_METADATA).doc(oldFapmId).delete();
      LogUtil.debug(_TAG, 'Deleted old Id $oldFapmId data');
    }
  }

  Future<List<FuelAuthorityPriceMetadata>> getFuelAuthorityPriceMetadata(final String authorityId) async {
    final db = Localstore.instance;
    final Map<String, dynamic> fuelTypeIds = await db.collection(_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE).doc(authorityId).get();
    LogUtil.debug(_TAG, 'Found ${fuelTypeIds == null ? 0 : fuelTypeIds.length} '
        '{Fuel-Type : Id} mapping for $authorityId in $_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE');
    if (fuelTypeIds == null || fuelTypeIds.length == 0) {
      return [];
    } else {
      final List<FuelAuthorityPriceMetadata> metadata = [];
      for (var fuelTypeIdsEntry in fuelTypeIds.entries) {
        final Map<String, dynamic> metadataMap = await db.collection(_COLLECTION_FUEL_AUTHORITY_PRICE_METADATA)
            .doc(fuelTypeIdsEntry.value).get();
        if (metadataMap != null && metadataMap.length > 0) {
          metadata.add(FuelAuthorityPriceMetadata.fromMap(metadataMap));
        }
      }
      LogUtil.debug(_TAG, 'Returning ${metadata.length} metadata for fuelAuthority : $authorityId');
      return metadata;
    }
  }

  Future<dynamic> deleteFuelAuthorityPriceMetadata(final FuelAuthorityPriceMetadata metadata) async {
    final db = Localstore.instance;
    final Map<String, dynamic> fuelTypeIds = await db.collection(_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE).doc(metadata.fuelAuthority).get();
    if (fuelTypeIds == null || fuelTypeIds.length == 0) {
      LogUtil.debug(_TAG, 'No FuelTypeIds for fuel-authority : ' + metadata.fuelAuthority);
    } else {
      final String fapmId = fuelTypeIds[metadata.fuelType];
      if (fapmId == null) {
        LogUtil.debug(_TAG, 'Meta-data for fuel-type ${metadata.fuelType} and authority ${metadata.fuelAuthority} is not stored');
      } else {
        fuelTypeIds.remove(metadata.fuelType);
        LogUtil.debug(_TAG, 'Deleted Id : $fapmId] fuel-type : ${metadata.fuelType} mapping for ${metadata.fuelAuthority}');
        if (fuelTypeIds.length == 0) {
          LogUtil.debug(_TAG, 'No more {FuelType : Id} mapping for ${metadata.fuelAuthority}. Deleting record from $_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE');
          db.collection(_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE).doc(metadata.fuelAuthority).delete();
        } else {
          LogUtil.debug(_TAG, 'Persisting updated {FuelType : Id} mapping for ${metadata.fuelAuthority} in $_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE');
          db.collection(_COLLECTION_FUEL_AUTHORITY_FUEL_TYPE).doc(metadata.fuelAuthority).set(fuelTypeIds);
        }
        LogUtil.debug(_TAG, 'Deleting {Fuel-Type : Id} mapping for $fapmId');
        db.collection(_COLLECTION_FUEL_AUTHORITY_PRICE_METADATA).doc(fapmId).delete();
      }
    }
  }
}