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
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UserConfigurationDao {
  static const _tag = 'UserConfigurationDao';
  static const _collectionUserConfig = 'ped_user_config';
  static const defaultUserConfigVersion = 1;

  static final UserConfigurationDao instance = UserConfigurationDao._();

  UserConfigurationDao._();

  Future<UserConfiguration?> getUserConfiguration(final String userConfigId) async {
    final SecureStorage db = SecureStorage.instance;
    final String? data = await db.readData(_collectionUserConfig, userConfigId);
    LogUtil.debug(_tag, 'Reading userConfiguration with id $userConfigId');
    if (data != null) {
      final Map<String, dynamic> dataAsMap = convert.jsonDecode(data);
      if (dataAsMap.isNotEmpty) {
        return UserConfiguration.fromMap(convert.jsonDecode(data));
      }
    }
    return null;
  }

  Future<void> insertUserConfiguration(final UserConfiguration userConfiguration) async {
    final SecureStorage db = SecureStorage.instance;
    LogUtil.debug(_tag, 'Persisting userConfiguration with id ${userConfiguration.id}');
    db.writeData(StorageItem(_collectionUserConfig, userConfiguration.id, convert.jsonEncode(userConfiguration)));
  }

  Future<void> deleteUserConfiguration(final String userConfigId) async {
    final SecureStorage db = SecureStorage.instance;
    LogUtil.debug(_tag, 'Deleting user-config with id $userConfigId');
    db.deleteData(_collectionUserConfig, userConfigId);
  }

  Future<int> getUserConfigurationVersion(final String userConfigId) async {
    LogUtil.debug(_tag, 'Reading userConfiguration.version with id $userConfigId');
    UserConfiguration? configuration = await getUserConfiguration(userConfigId);
    if (configuration != null) {
      return configuration.version;
    }
    return defaultUserConfigVersion;
  }
}