import 'package:pumped_end_device/data/local/dao2/secure_storage.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'dart:convert' as convert;

class UpdateHistoryDao {
  static const _tag = 'UpdateHistoryDao';
  static const _collectionUpdateHistory = 'ped_update_history';

  static final UpdateHistoryDao instance = UpdateHistoryDao._();
  UpdateHistoryDao._();

  Future<void> deleteUpdateHistory() async {
    final SecureStorage instance = SecureStorage.instance;
    final List<UpdateHistory> allUpdateHistory = await getAllUpdateHistory();
    for (final UpdateHistory item in allUpdateHistory) {
      instance.deleteData(_collectionUpdateHistory, item.updateHistoryId);
    }
  }

  Future<void> insertUpdateHistory(final UpdateHistory updateHistory) async {
    final SecureStorage instance = SecureStorage.instance;
    instance.writeData(StorageItem(_collectionUpdateHistory,
        updateHistory.updateHistoryId, convert.jsonEncode(updateHistory)));
  }

  Future<List<UpdateHistory>> getAllUpdateHistory() async {
    List<UpdateHistory> allUpdateHistory = [];
    final SecureStorage instance = SecureStorage.instance;
    final List<StorageItem> storageItems = await instance.readAllData(_collectionUpdateHistory);
    LogUtil.debug(_tag, 'Number of UpdateHistory records found : ${storageItems.length}');
    for (final StorageItem item in storageItems) {
      allUpdateHistory.add(UpdateHistory.fromJson(convert.jsonDecode(item.getValue())));
    }
    return allUpdateHistory;
  }
}