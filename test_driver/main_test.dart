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

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' as ft;

void main() {
  ft.group('Splash Screen Test', () {
    FlutterDriver driver;
    ft.setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    ft.tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    ft.test('verify the text on fuel stations screen', () async {
      SerializableFinder message = find.text("Pumped");
      await driver.waitFor(message);
      ft.expect(await driver.getText(message), "Pumped");
    });
  });
}