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

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//https://blog.logrocket.com/securing-local-storage-flutter/
// https://github.com/mogol/flutter_secure_storage
class SecureStorage {
  static final SecureStorage instance = SecureStorage._();

  SecureStorage._();

  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);

  final _iosOptions = const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  Future<void> writeData(final StorageItem item) async {
    await _secureStorage.write(
        key: _getPersistenceKey(item.getCollection(), item.getKey()),
        value: item.getValue(),
        aOptions: _getAndroidOptions(),
        iOptions: _iosOptions);
  }

  Future<String?> readData(final String collection, final String key) async {
    return await _secureStorage.read(
        key: _getPersistenceKey(collection, key), aOptions: _getAndroidOptions(), iOptions: _iosOptions);
  }

  Future<List<StorageItem>> readAllData(final String collection) async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions(), iOptions: _iosOptions);
    List<StorageItem> list = allData.entries
        .where((e) => e.key.startsWith('$collection-'))
        .map((e) => StorageItem(collection, e.key, e.value))
        .toList();
    return list;
  }

  Future<void> deleteData(final String collection, final String key) async {
    await _secureStorage.delete(
        key: _getPersistenceKey(collection, key), aOptions: _getAndroidOptions(), iOptions: _iosOptions);
  }

  Future<bool> contains(final String collection, final String key) async {
    return await _secureStorage.containsKey(
        key: _getPersistenceKey(collection, key), aOptions: _getAndroidOptions(), iOptions: _iosOptions);
  }

  String _getPersistenceKey(final String collection, final String key) => '$collection-$key';
}

class StorageItem {
  final String _collectionName;
  final String _key;
  final String _value;

  StorageItem(this._collectionName, this._key, this._value);

  String getValue() => _value;
  String getCollection() => _collectionName;
  String getKey() => _key;
}
