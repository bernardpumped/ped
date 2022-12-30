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
import 'package:pumped_end_device/data/local/model/ui_settings.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UiSettingsDao {
  static const _tag = 'UiSettingsDao';
  static const _collectionUiSettings = 'ped_ui_settings_coll';
  static const _uiSettingsInstance = 'ped_ui_settings';

  static final UiSettingsDao instance = UiSettingsDao._();

  UiSettingsDao._();

  Future<dynamic> insertUiSettings(final UiSettings uiSettings) async {
    final SecureStorage db = SecureStorage.instance;
    db.writeData(StorageItem(_collectionUiSettings, _uiSettingsInstance, convert.jsonEncode(uiSettings)));
  }

  Future<UiSettings> getUiSettings() async {
    final SecureStorage db = SecureStorage.instance;
    LogUtil.debug(_tag, 'Retrieving instance of UiSettings');
    final String? data = await db.readData(_collectionUiSettings, _uiSettingsInstance);
    if (data != null) {
      return UiSettings.fromJson(convert.jsonDecode(data));
    }
    return UiSettings();
  }
}