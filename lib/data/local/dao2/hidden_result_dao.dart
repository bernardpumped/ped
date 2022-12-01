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
 *     along with Pumped End Device. If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:pumped_end_device/data/local/dao2/secure_storage.dart';
import 'package:pumped_end_device/data/local/model/hidden_result.dart';
import 'dart:convert' as convert;

import 'package:pumped_end_device/util/log_util.dart';

class HiddenResultDao {
  static const _tag = 'HiddenResultDao';
  static const _hiddenResultsCollectionG = 'ped_hidden_results-G';
  static const _hiddenResultsCollectionF = 'ped_hidden_results-F';

  static final HiddenResultDao instance = HiddenResultDao._();

  HiddenResultDao._();

  Future<dynamic> insertHiddenResult(final HiddenResult hiddenResult) async {
    final SecureStorage instance = SecureStorage.instance;
    instance.writeData(StorageItem(_getCollectionName(hiddenResult.hiddenStationSource),
        hiddenResult.hiddenStationId.toString(), convert.jsonEncode(hiddenResult)));
  }

  Future<List<HiddenResult>> getAllHiddenResults() async {
    final SecureStorage instance = SecureStorage.instance;
    final List<HiddenResult> results = [];
    final List<StorageItem> resultsG = await instance.readAllData(_hiddenResultsCollectionG);
    for (final StorageItem resultG in resultsG) {
      results.add(HiddenResult.fromJson(convert.jsonDecode(resultG.getValue())));
    }
    final List<StorageItem> resultsF = await instance.readAllData(_hiddenResultsCollectionF);
    for (final StorageItem resultF in resultsF) {
      results.add(HiddenResult.fromJson(convert.jsonDecode(resultF.getValue())));
    }
    LogUtil.debug(_tag, 'getAllHiddenResults::Num Hidden Results : ${results.length}');
    return results;
  }

  Future<void> deleteHiddenResults(final HiddenResult hiddenResult) async {
    final SecureStorage instance = SecureStorage.instance;
    instance.deleteData(_getCollectionName(hiddenResult.hiddenStationSource), hiddenResult.hiddenStationId.toString());
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
    final SecureStorage instance = SecureStorage.instance;
    return await instance.contains(_getCollectionName(hiddenStationSource), hiddenStationId.toString());
  }

  _getCollectionName(final String hiddenStationSource) {
    if (hiddenStationSource == 'G') {
      return _hiddenResultsCollectionG;
    } else if (hiddenStationSource == 'F') {
      return _hiddenResultsCollectionF;
    } else {
      throw Exception('Invalid fuelStationSource $hiddenStationSource');
    }
  }
}
