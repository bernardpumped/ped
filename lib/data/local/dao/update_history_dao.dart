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
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UpdateHistoryDao {
  static const _tag = 'UpdateHistoryDao';
  static const _collectionUpdateHistory = 'ped_update_history';

  static final UpdateHistoryDao instance = UpdateHistoryDao._();
  UpdateHistoryDao._();

  Future<int> deleteUpdateHistory() async {
    final db = Localstore.instance;
    final Map<String, dynamic>? records = await db.collection(_collectionUpdateHistory).get();
    if (records != null && records.isNotEmpty) {
      LogUtil.debug(_tag, 'Number of UpdateHistory records found : ${records.length}');
      for (var record in records.entries) {
        var updateHistoryRecordId = record.value['update_history_id'];
        LogUtil.debug(_tag, 'Deleting UpdateHistory record with id $updateHistoryRecordId');
        db.collection(_collectionUpdateHistory).doc(updateHistoryRecordId).delete();
      }
      return records.length;
    }
    return 0;
  }

  Future<dynamic> insertUpdateHistory(final UpdateHistory updateHistory) async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'Inserting update-history with id ${updateHistory.updateHistoryId}');
    db.collection(_collectionUpdateHistory).doc(updateHistory.updateHistoryId).set(updateHistory.toMap());
  }

  Future<List<UpdateHistory>> getAllUpdateHistory() async {
    final db = Localstore.instance;
    List<UpdateHistory> allUpdateHistory = [];
    final Map<String, dynamic>? records = await db.collection(_collectionUpdateHistory).get();
    if (records != null && records.isNotEmpty) {
      LogUtil.debug(_tag, 'Number of UpdateHistory records found : ${records.length}');
      for (var record in records.entries) {
        final Map<String, dynamic>? data = await db.collection(_collectionUpdateHistory).doc(record.value['update_history_id']).get();
        if (data != null) {
          allUpdateHistory.add(UpdateHistory.fromMap(data));
        }
      }
    }
    return allUpdateHistory;
  }
}