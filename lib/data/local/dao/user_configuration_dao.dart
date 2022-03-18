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

import 'package:localstore/localstore.dart';
import 'package:pumped_end_device/data/local/model/user_configuration.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UserConfigurationDao {
  static const _tag = 'UserConfigurationDao';
  static const _collectionUserConfig = 'pumped_user_config';
  static const defaultUserConfigVersion = 1;

  static final UserConfigurationDao instance = UserConfigurationDao._();

  UserConfigurationDao._();

  Future<UserConfiguration?> getUserConfiguration(final String userConfigId) async {
    final db = Localstore.instance;
    final Map<String, dynamic>? userConfig = await db.collection(_collectionUserConfig).doc(userConfigId).get();
    if (userConfig != null && userConfig.isNotEmpty) {
      return UserConfiguration.fromMap(userConfig);
    }
    return null;
  }

  Future<dynamic> insertUserConfiguration(final UserConfiguration userConfiguration) async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'Persisting userConfiguration with id ${userConfiguration.id}');
    db.collection(_collectionUserConfig).doc(userConfiguration.id).set(userConfiguration.toMap());
  }

  Future<dynamic> deleteUserConfiguration(final String userConfigId) async {
    final db = Localstore.instance;
    LogUtil.debug(_tag, 'Deleting user-config with id $userConfigId');
    db.collection(_collectionUserConfig).doc(userConfigId).delete();
  }

  Future<int> getUserConfigurationVersion(final String userConfigId) async {
    final db = Localstore.instance;
    final Map<String, dynamic>? userConfig = await db.collection(_collectionUserConfig).doc(userConfigId).get();
    if (userConfig != null && userConfig.isNotEmpty) {
      return UserConfiguration.fromMap(userConfig).version;
    }
    return defaultUserConfigVersion;
  }
}