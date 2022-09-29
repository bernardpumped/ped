import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/ui_settings.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UiSettingsDao {
  static const _tag = 'UiSettingsDao';
  static const _collectionUiSettings = 'pumped_ui_settings_coll';
  static const _uiSettingsInstance = 'pumped_ui_settings';

  static final UiSettingsDao instance = UiSettingsDao._();

  UiSettingsDao._();

  Future<dynamic> insertUiSettings(final UiSettings uiSettings) async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'inserting UiSettings');
    db.collection(_collectionUiSettings).doc(_uiSettingsInstance).set(uiSettings.toMap(), SetOptions(merge: true));
  }

  Future<UiSettings?> getUiSettings() async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'retrieving instance of UiSettings');
    final Map<String, dynamic>? uiSettingsMap = await db.collection(_collectionUiSettings).doc(_uiSettingsInstance).get();
    if (uiSettingsMap != null && uiSettingsMap.isNotEmpty) {
      return UiSettings.fromMap(uiSettingsMap);
    }
    return UiSettings();
  }
}