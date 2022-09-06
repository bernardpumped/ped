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
import 'package:pumped_end_device/data/local/model/hidden_result.dart';
import 'package:pumped_end_device/util/log_util.dart';

class HiddenResultDao {
  static const _tag = 'HiddenResultDao';
  static const _hiddenResultsCollectionG = 'hidden_results-G';
  static const _hiddenResultsCollectionF = 'hidden_results-F';

  static final HiddenResultDao instance = HiddenResultDao._();

  HiddenResultDao._();

  Future<dynamic> insertHiddenResult(final HiddenResult hiddenResult) async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'insertHiddenResult::${hiddenResult.toJson()}');
    db.collection(_getCollection(hiddenResult)).doc(hiddenResult.hiddenStationId.toString()).set(hiddenResult.toJson());
  }

  Future<List<HiddenResult>> getAllHiddenResults() async {
    final List<HiddenResult> hiddenResults = [];
    final db = Localstore.instance;

    var hrItemsG = await db.collection(_hiddenResultsCollectionG).get();
    if (hrItemsG != null) {
      for (var hrItemG in hrItemsG.entries) {
        hiddenResults.add(HiddenResult.fromJson(hrItemG.value));
      }
    }
    var hrItemsF = await db.collection(_hiddenResultsCollectionF).get();
    if (hrItemsF != null) {
      for (var hrItemF in hrItemsF.entries) {
        hiddenResults.add(HiddenResult.fromJson(hrItemF.value));
      }
    }
    LogUtil.debug(_tag, 'getAllHiddenResults::Num Hidden Results : ${hiddenResults.length}');
    return hiddenResults;
  }

  Future<dynamic> deleteHiddenResults(final HiddenResult hiddenResult) async {
    final db = Localstore.instance;
    return db.collection(_getCollection(hiddenResult)).doc(hiddenResult.hiddenStationId.toString()).delete();
  }

  Future<int> deleteAllHiddenResults() async {
    final List<HiddenResult> allHiddenResults = await getAllHiddenResults();
    int deleteCount = 0;
    for (var hiddenResult in allHiddenResults) {
      deleteHiddenResults(hiddenResult);
      deleteCount += 1;
    }
    return deleteCount;
  }

  Future<bool> containsHiddenFuelStation(final int hiddenStationId, final String hiddenStationSource) async {
    final db = Localstore.instance;
    if (hiddenStationSource == 'G') {
      return await db.collection(_hiddenResultsCollectionG).doc(hiddenStationId.toString()).get() != null;
    } else if (hiddenStationSource == 'F') {
      return await db.collection(_hiddenResultsCollectionF).doc(hiddenStationId.toString()).get() != null;
    }
    return false;
  }

  _getCollection(final HiddenResult hiddenResult) {
    if (hiddenResult.hiddenStationSource == 'G') {
      return _hiddenResultsCollectionG;
    } else if (hiddenResult.hiddenStationSource == 'F') {
      return _hiddenResultsCollectionF;
    } else {
      throw Exception('Invalid fuelStationSource $hiddenResult.hiddenStationSource');
    }
  }
}
